package local

import (
	"encoding/json"
	"fmt"
	"net/http"
	"net/url"
	"strings"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/gorilla/websocket"
	"github.com/k8zdev/k8z/gopkg/k8z"
	"github.com/k8zdev/k8z/gopkg/k8z/models"
	"github.com/k8zdev/k8z/gopkg/terminal"
	"k8s.io/apimachinery/pkg/types"
	"k8s.io/client-go/tools/remotecommand"
)

func writeError(wsconn *websocket.Conn, msg string) {
	wsmsg, _ := json.Marshal(terminal.Message{
		Op:   "stderr",
		Data: msg,
	})
	err := wsconn.WriteMessage(websocket.TextMessage, wsmsg)
	fmt.Printf("write ws message failed, error: %s", err)
}

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
				writeError(wsconn, fmt.Sprintf("keep ws connection alive failed, error: %s\n", err))
				return
			}
		}
	}()

	var debug = ctx.Query("debug") == "true"
	var name = ctx.Query("name")
	var shell = ctx.Query("shell")
	var namespace = ctx.Query("namespace")
	var container = ctx.Query("container")
	var image = ctx.Request.Header.Get("x-image")
	var rawCmd = ctx.Request.Header.Get("x-ephemeral-cmd")
	fmt.Printf("🍉 ephemeral cmd: \"%s\"\n", rawCmd)
	var ephemeralCmd = strings.Split(rawCmd, ", ")

	if debug {
		// 1. create Ephemeral container
		var k8zHeader = &K8zHeader{}
		var err = ctx.ShouldBindHeader(k8zHeader)
		if err != nil {
			writeError(wsconn, fmt.Sprintf("get params failed, error: %s\n", err))
			return
		}
		fmt.Printf("server: %s\n", k8zHeader.Server)

		_, clientset, err := k8z.NewClient(k8zHeader.CtxName, k8zHeader.Server, k8zHeader.CAData, k8zHeader.Insecure == "true", k8zHeader.CertData, k8zHeader.KeyData, k8zHeader.Token, k8zHeader.Username, k8zHeader.Password, k8zHeader.Proxy, k8zHeader.Timeout)
		if err != nil {
			writeError(wsconn, fmt.Sprintf("get client failed, error: %s\n", err))
			return
		}

		// e.g. /api/v1/namespaces/oo/pods/oo-nats-box-6c4b44747f-4z9nj/ephemeralcontainers
		ephemeralContainerApi, err := url.Parse(
			fmt.Sprintf(
				"%s/api/v1/namespaces/%s/pods/%s/ephemeralcontainers",
				restConfig.Host, namespace, name,
			),
		)
		if err != nil {
			writeError(wsconn, fmt.Sprintf("build ephemeral container api failed, error: %s\n", err))
			return
		}
		// https://iximiuz.com/en/posts/kubernetes-ephemeral-containers/
		var containers = []models.Ephemeralcontainer{
			{
				Name:    container,
				Image:   image,
				Stdin:   true,
				Tty:     true,
				Command: ephemeralCmd,
			},
		}
		var patch = models.EphemeralPatch{Spec: models.EphemeralPatchSpec{
			Ephemeralcontainers: containers,
		}}
		var patchBytes, _ = json.Marshal(patch)
		var req = clientset.RESTClient().Patch(types.StrategicMergePatchType)
		req = req.Body(patchBytes).RequestURI(ephemeralContainerApi.String())

		resp := req.Do(ctx.Request.Context())
		if resp.Error() != nil {
			var content = fmt.Sprintf("request ephemeral containerd api failed, error: %s\n", resp.Error())
			writeError(wsconn, content)
			return
		}
		var status int
		resp.StatusCode(&status)
		if status == http.StatusUnauthorized {
			writeError(wsconn, "create ephemeral container failed, unauthorized")
			return
		}
		respBody, err := resp.Raw()
		if err != nil {
			writeError(wsconn, fmt.Sprintf("get resp body failed, error: %s\n", err))
			return
		}
		if status < 200 || status >= 300 {
			writeError(wsconn, string(respBody))
			return
		}

		// TODO: 2. wait container create
		time.Sleep(2e9)

		msg, _ := json.Marshal(terminal.Message{
			Op:   "stdout",
			Data: fmt.Sprintf("name: %s, namespace: %s, container: %s, shell: %s\n", name, namespace, container, shell),
		})
		wsconn.WriteMessage(websocket.TextMessage, msg)
		// return
	}

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
