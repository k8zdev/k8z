package local

import (
	"bufio"
	"strconv"
	"strings"

	"github.com/gin-gonic/gin"
	"github.com/gorilla/websocket"
	corev1 "k8s.io/api/core/v1"
)

func logstream(ctx *gin.Context) {
	var wsconn, _, clientset = ws(ctx)
	defer wsconn.Close()

	var name = ctx.Query("name")
	var namespace = ctx.Query("namespace")
	var container = ctx.Query("container")
	var tail, _ = strconv.ParseInt(ctx.Query("tail"), 10, 64)
	var since, _ = strconv.ParseInt(ctx.Query("since"), 10, 64)
	if tail == 0 {
		tail = 100
	}
	if since == 0 {
		since = 300
	}

	options := &corev1.PodLogOptions{
		Follow:       true,
		TailLines:    &tail,
		SinceSeconds: &since,
		Container:    container,
	}

	stream, err := clientset.CoreV1().Pods(namespace).GetLogs(name, options).Stream(ctx)
	if err != nil {
		wsconn.WriteMessage(websocket.TextMessage, []byte("could not stream logs: "+err.Error()))
		return
	}

	defer stream.Close()

	reader := bufio.NewReaderSize(stream, 16)
	lastLine := ""

	for {
		data, isPrefix, err := reader.ReadLine()
		if err != nil {
			wsconn.WriteMessage(websocket.TextMessage, []byte("read logs line failed: "+err.Error()))
			return
		}

		lines := strings.Split(string(data), "\r")
		length := len(lines)

		if len(lastLine) > 0 {
			lines[0] = lastLine + lines[0]
			lastLine = ""
		}

		if isPrefix {
			lastLine = lines[length-1]
			lines = lines[:(length - 1)]
		}

		for _, line := range lines {
			if err := wsconn.WriteMessage(websocket.TextMessage, []byte(line)); err != nil {
				return
			}
		}
	}

}
