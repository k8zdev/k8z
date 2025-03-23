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
	k8serr "k8s.io/apimachinery/pkg/api/errors"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/apimachinery/pkg/types"
	"k8s.io/apimachinery/pkg/util/wait"
	"k8s.io/client-go/kubernetes"
	"k8s.io/client-go/rest"
)

var backoff = wait.Backoff{
	Steps:    10,
	Factor:   1.5,
	Duration: 1e9,
	Jitter:   0.1,
}

func writeError(wsconn *websocket.Conn, msg string) {
	wsmsg, _ := json.Marshal(terminal.Message{
		Op:   "stderr",
		Data: msg,
	})
	err := wsconn.WriteMessage(websocket.TextMessage, wsmsg)
	if err != nil {
		fmt.Printf("write ws message failed, error: %s", err)
	}
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
	var workingDir = ctx.Request.Header.Get("x-working-dir")
	if workingDir == "" {
		workingDir = "/"
	}

	// 1. create Ephemeral container
	var k8zHeader = &K8zHeader{}
	var err = ctx.ShouldBindHeader(k8zHeader)
	if err != nil {
		writeError(wsconn, fmt.Sprintf("get params failed, error: %s\n", err))
		return
	}
	fmt.Printf("🍉 server: %s, ns: %s, podName: %s, container: %s ,start cmd: \"%s\"\n",
		k8zHeader.Server, namespace, name, container, rawCmd,
	)

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
			ctx, clientset, wsconn, k8zHeader, workingDir,
			"kube-system", name, nodeName, container, image, startCmd,
		)

	default:
		fmt.Println("no pod or container need create")
	}

	// 3. exec to shell
	execapi, err := url.Parse(fmt.Sprintf("%s/api/v1/namespaces/%s/pods/%s/exec?container=%s&command=%s&stdin=true&stdout=true&stderr=true&tty=true", restConfig.Host, namespace, name, container, shell))
	if err != nil {
		var msg = fmt.Sprintf("Could not create request url: %s", err.Error())
		writeError(wsconn, msg)
		return
	}

	if !terminal.IsValidShell(shell) {
		shell = "sh"
	}
	var cmd = []string{shell}
	var session = &terminal.Session{
		WebSocket: wsconn,
		DoneChan:  make(chan struct{}),
		// SizeChan:  make(chan remotecommand.TerminalSize),
	}

	err = terminal.StartProcess(restConfig, execapi, cmd, session)
	if err != nil {
		var msg = fmt.Sprintf("Could not create terminal: %s", err.Error())
		writeError(wsconn, msg)
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
	_ = wsconn.WriteMessage(websocket.TextMessage, msg)
	// return
}

func checkPodFunc(ctx *gin.Context, ns, name, idx string,
	clientset *kubernetes.Clientset, wsconn *websocket.Conn) wait.ConditionFunc {
	return func() (bool, error) {
		var pod, err = clientset.CoreV1().Pods(ns).Get(ctx.Request.Context(), name, metav1.GetOptions{})
		writeError(wsconn, fmt.Sprintf("⚙️ %s try check pod status\r\n", idx))
		if err != nil {
			writeError(wsconn, fmt.Sprintf("check pod status, error: %s\r\n", err))
			return false, nil
		}
		if pod.Status.Phase == corev1.PodRunning {
			writeError(wsconn, "✅ pod is running\r\n")
			return true, nil
		}
		return false, nil
	}
}

// https://github.com/kvaps/kubectl-node-shell/blob/master/kubectl-node_shell
func createNodeshellPod(ctx *gin.Context,
	clientset *kubernetes.Clientset, wsconn *websocket.Conn,
	header *K8zHeader, workingDir string,
	namespace, name, nodeName, container, image string, startCmd []string,
) {
	var err error
	var pod *corev1.Pod
	// 0. check pod exist
	pod, err = clientset.CoreV1().Pods(namespace).Get(ctx.Request.Context(), name, metav1.GetOptions{})

	if pod == nil || k8serr.IsNotFound(err) {
		// 1. create pod
		var pod2 = &corev1.Pod{
			ObjectMeta: metav1.ObjectMeta{
				Name:      name,
				Namespace: namespace,
			},
			Spec: corev1.PodSpec{
				NodeName:    nodeName,
				HostPID:     header.HostPID,
				HostIPC:     header.HostIPC,
				HostNetwork: header.HostNetwork,
				Containers: []corev1.Container{
					{
						Name:       container,
						Image:      image,
						Stdin:      true,
						StdinOnce:  true,
						TTY:        true,
						Command:    startCmd,
						WorkingDir: workingDir,
						SecurityContext: &corev1.SecurityContext{
							Privileged: &[]bool{true}[0],
						},
					},
				},
			},
		}
		var opts = metav1.CreateOptions{}
		writeError(wsconn, fmt.Sprintf("🚀 try create pod: %s, namespace: %s, container: %s, shell: %s\n", name, namespace, container, startCmd))
		pod, err = clientset.CoreV1().Pods(namespace).Create(ctx.Request.Context(), pod2, opts)
		if err != nil {
			writeError(wsconn, fmt.Sprintf("create pod failed, error: %s\n", err))
			return
		}
		fmt.Printf("🍉 create pod: %s, namespace: %s, container: %s, shell: %s, selflink: %s\n", name, namespace, container, startCmd, pod.GetSelfLink())
		writeError(wsconn,
			fmt.Sprintf(
				"create pod: %s, namespace: %s, container: %s, shell: %s, selflink: %s\n",
				name, namespace, container, startCmd, pod.GetSelfLink(),
			),
		)
	}

	// wait pod ready
	err = wait.ExponentialBackoff(backoff, checkPodFunc(ctx, namespace, name, "🏗️", clientset, wsconn))
	if err != nil {
		writeError(wsconn, fmt.Sprintf("check pod status failed, error:%s", err))
		return
	}

}
