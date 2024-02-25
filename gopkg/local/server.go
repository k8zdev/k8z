package local

import (
	"encoding/json"
	"fmt"
	"net/http"
	"net/url"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/gorilla/websocket"
	"github.com/k8zdev/k8z/gopkg/k8z"
	"github.com/k8zdev/k8z/gopkg/terminal"
	"github.com/sirupsen/logrus"
	"k8s.io/apimachinery/pkg/types"
	"k8s.io/client-go/rest"
	"k8s.io/client-go/tools/remotecommand"
)

const Addr = ":29257"

var router = gin.New()

func init() {
	router.Use(gin.Logger(), gin.Recovery(), gin.ErrorLogger(), func(ctx *gin.Context) {
		ctx.Header("Server", "K8z")
	})
	router.GET("/ping", func(c *gin.Context) {
		c.JSON(200, gin.H{"message": "pong"})
	})
	router.Any("/forward/*api", forward)
	router.GET("/ws", ws)
}

func Server() {
	router.Run(Addr)
}

type K8zHeader struct {
	CtxName  string `header:"X-CONTEXT-NAME"`
	Server   string `header:"X-CLUSTER-SERVER"`
	CAData   string `header:"X-CLUSTER-CA-DATA"`
	Insecure string `header:"X-CLUSTER-INSECURE"`
	CertData string `header:"X-USER-CERT-DATA"`
	KeyData  string `header:"X-USER-KEY-DATA"`
	Token    string `header:"X-USER-TOKEN"`
	Username string `header:"X-USER-USERNAME"`
	Password string `header:"X-USER-PASSWORD"`
	Proxy    string `header:"X-PROXY"`
	Timeout  int64  `header:"X-TIMEOUT"`
}

func forward(ctx *gin.Context) {
	var api = ctx.Param("api")
	var k8zHeader = &K8zHeader{}
	var err = ctx.ShouldBindHeader(k8zHeader)
	if err != nil {
		ctx.JSON(400, gin.H{"message": "bad request", "error": err.Error()})
	}
	fmt.Printf("server: %s,api: %s\n", k8zHeader.Server, api)

	_, clientset, err := k8z.NewClient(k8zHeader.CtxName, k8zHeader.Server, k8zHeader.CAData, k8zHeader.Insecure == "true", k8zHeader.CertData, k8zHeader.KeyData, k8zHeader.Token, k8zHeader.Username, k8zHeader.Password, k8zHeader.Proxy, k8zHeader.Timeout)
	if err != nil {
		ctx.JSON(500, gin.H{"message": "get client error", "error": err.Error()})
	}
	var req *rest.Request
	switch ctx.Request.Method {
	case "GET":
		req = clientset.RESTClient().Get()
	case "POST":
		req = clientset.RESTClient().Post()
	case "PUT":
		req = clientset.RESTClient().Put()
	case "DELETE":
		req = clientset.RESTClient().Delete()
	case "PATCH":
		req = clientset.RESTClient().Patch(types.JSONPatchType)
	}
	var resp rest.Result
	var status int

	resp = req.RequestURI(api).Do(ctx.Request.Context())
	if resp.Error() != nil {
		ctx.JSON(500, gin.H{"message": "access k8s api error", "error": resp.Error().Error()})
		return
	}
	resp.StatusCode(&status)
	if status == http.StatusUnauthorized {
		ctx.JSON(401, gin.H{"message": "unauthorized", "error": "unauthorized"})
		return
	}
	respBody, err := resp.Raw()
	if err != nil {
		ctx.JSON(500, gin.H{"message": "get resp body error", "error": err.Error()})
	}
	if status < 200 || status >= 300 {
		ctx.String(status, string(respBody))
		return
	}
	ctx.Data(200, "application/json", respBody)
}

func ws(ctx *gin.Context) {
	var k8zHeader = &K8zHeader{}
	var err = ctx.ShouldBindHeader(k8zHeader)
	if err != nil {
		ctx.AbortWithStatusJSON(
			http.StatusBadRequest,
			gin.H{"message": "bad request", "error": err.Error()},
		)
		return
	}

	restConfig, _, err := k8z.NewClient(k8zHeader.CtxName, k8zHeader.Server, k8zHeader.CAData, k8zHeader.Insecure == "true", k8zHeader.CertData, k8zHeader.KeyData, k8zHeader.Token, k8zHeader.Username, k8zHeader.Password, k8zHeader.Proxy, k8zHeader.Timeout)
	if err != nil {
		logrus.WithError(err).Errorln("create client failed")
		ctx.AbortWithStatusJSON(
			http.StatusBadRequest,
			gin.H{"message": "create client failed", "error": err.Error()},
		)
		return
	}

	var upgrader = websocket.Upgrader{}
	upgrader.CheckOrigin = func(r *http.Request) bool { return true }

	wsconn, err := upgrader.Upgrade(ctx.Writer, ctx.Request, nil)
	if err != nil {
		ctx.AbortWithStatusJSON(
			http.StatusBadRequest,
			gin.H{"message": "upgrade connection failed", "error": err.Error()},
		)
		return
	}

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
