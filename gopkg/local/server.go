package local

import (
	"fmt"
	"net/http"

	"github.com/gin-gonic/gin"
	"k8s.io/apimachinery/pkg/types"
	"k8s.io/client-go/rest"

	"github.com/k8zdev/k8z/gopkg/k8z"
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
