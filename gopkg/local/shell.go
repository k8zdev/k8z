package local

import (
	"encoding/json"
	"fmt"
	"net/url"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/gorilla/websocket"
	"github.com/k8zdev/k8z/gopkg/terminal"
	"k8s.io/client-go/tools/remotecommand"
)

func shell(ctx *gin.Context) {

	wsconn, restConfig, _ := ws(ctx)

	defer wsconn.Close()

	// keep ws connection alive
	wsconn.SetPongHandler(func(string) error { return nil })
	go func() {
		ticker := time.NewTicker(30 * time.Second)
		defer ticker.Stop()

		for range ticker.C {
			if err := wsconn.WriteMessage(websocket.PingMessage, nil); err != nil {
				return
			}
		}
	}()

	var name = ctx.Query("name")
	var shell = ctx.Query("shell")
	var namespace = ctx.Query("namespace")
	var container = ctx.Query("container")

	execapi, err := url.Parse(fmt.Sprintf("%s/api/v1/namespaces/%s/pods/%s/exec?container=%s&command=%s&stdin=true&stdout=true&stderr=true&tty=true", restConfig.Host, namespace, name, container, shell))
	if err != nil {
		msg, _ := json.Marshal(terminal.Message{
			Op:   "stdout",
			Data: fmt.Sprintf("Could not create request url: %s", err.Error()),
		})
		wsconn.WriteMessage(websocket.TextMessage, msg)
		return
	}

	if !terminal.IsValidShell(shell) {
		shell = "sh"
	}
	var cmd = []string{shell}
	var session = &terminal.Session{
		WebSocket: wsconn,
		SizeChan:  make(chan remotecommand.TerminalSize),
	}

	err = terminal.StartProcess(restConfig, execapi, cmd, session)
	if err != nil {
		msg, _ := json.Marshal(terminal.Message{
			Op:   "stdout",
			Data: fmt.Sprintf("Could not create terminal: %s", err.Error()),
		})
		wsconn.WriteMessage(websocket.TextMessage, msg)
		return
	}
}
