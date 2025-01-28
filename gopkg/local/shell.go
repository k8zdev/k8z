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
	corev1 "k8s.io/api/core/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/apimachinery/pkg/types"
	"k8s.io/client-go/kubernetes"
	"k8s.io/client-go/rest"
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

	var name = ctx.Query("name")
	var shell = ctx.Query("shell")
	var namespace = ctx.Query("namespace")
	var container = ctx.Query("container")
	var image = ctx.Request.Header.Get("x-image")
	var rawCmd = ctx.Request.Header.Get("x-start-cmd")
	var startCmd = strings.Split(rawCmd, ", ")
	var shellType = ctx.Request.Header.Get("x-shell-type")
	var nodeName = ctx.Request.Header.Get("x-node-name")

	// 1. create Ephemeral container
	var k8zHeader = &K8zHeader{}
	var err = ctx.ShouldBindHeader(k8zHeader)
	if err != nil {
		writeError(wsconn, fmt.Sprintf("get params failed, error: %s\n", err))
		return
	}
	fmt.Printf("🍉 server: %s, ephemeral cmd: \"%s\"\n", k8zHeader.Server, rawCmd)

	_, clientset, err := k8z.NewClient(k8zHeader.CtxName, k8zHeader.Server, k8zHeader.CAData, k8zHeader.Insecure == "true", k8zHeader.CertData, k8zHeader.KeyData, k8zHeader.Token, k8zHeader.Username, k8zHeader.Password, k8zHeader.Proxy, k8zHeader.Timeout)
	if err != nil {
		writeError(wsconn, fmt.Sprintf("get client failed, error: %s\n", err))
		return
	}

	// 2. create pod or container
	switch shellType {
	case "debug":
		createEphemeralContainer(
			ctx, restConfig, clientset, wsconn, shell,
			namespace, name, container, image, startCmd,
		)
	case "node":
		createNodeshellPod(
			ctx, clientset, wsconn,
			"kube-system", name, nodeName, container, image, startCmd,
		)

	default:
		fmt.Println("no pod or container need create")
	}

	// 3. exec to shell
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

func createEphemeralContainer(
	ctx *gin.Context,
	restConfig *rest.Config, clientset *kubernetes.Clientset, wsconn *websocket.Conn,
	shell, ns, podName, container, image string, startCmd []string,
) {
	// e.g. /api/v1/namespaces/oo/pods/oo-nats-box-6c4b44747f-4z9nj/ephemeralcontainers
	ephemeralContainerApi, err := url.Parse(
		fmt.Sprintf(
			"%s/api/v1/namespaces/%s/pods/%s/ephemeralcontainers",
			restConfig.Host, ns, podName,
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
			Command: startCmd,
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
		Data: fmt.Sprintf("name: %s, namespace: %s, container: %s, shell: %s\n", podName, ns, container, shell),
	})
	wsconn.WriteMessage(websocket.TextMessage, msg)
	// return
}

// https://github.com/kvaps/kubectl-node-shell/blob/master/kubectl-node_shell
func createNodeshellPod(ctx *gin.Context,
	clientset *kubernetes.Clientset, wsconn *websocket.Conn,
	namespace, name, nodeName, container, image string, startCmd []string,
) {
	// 1. create pod
	var pod = &corev1.Pod{
		ObjectMeta: metav1.ObjectMeta{
			Name:      name,
			Namespace: namespace,
		},
		Spec: corev1.PodSpec{
			NodeName: nodeName,
			Containers: []corev1.Container{
				{
					Name:      container,
					Image:     image,
					Stdin:     true,
					StdinOnce: true,
					TTY:       true,
					Command:   startCmd,
				},
			},
		},
	}
	var opts = metav1.CreateOptions{}
	var pod2, err = clientset.CoreV1().Pods(namespace).Create(ctx.Request.Context(), pod, opts)
	if err != nil {
		writeError(wsconn, fmt.Sprintf("create pod failed, error: %s\n", err))
		return
	}
	fmt.Printf("🍉 create pod: %s, namespace: %s, container: %s, shell: %s, selflink: %s\n", name, namespace, container, startCmd, pod2.GetSelfLink())
	writeError(wsconn,
		fmt.Sprintf(
			"create pod: %s, namespace: %s, container: %s, shell: %s, selflink: %s\n",
			name, namespace, container, startCmd, pod2.GetSelfLink(),
		),
	)
}
