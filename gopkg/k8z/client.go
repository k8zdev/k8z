package k8z

import (
	"fmt"
	"net/http"
	"net/url"
	"strings"
	"time"

	"k8s.io/client-go/kubernetes"
	"k8s.io/client-go/rest"
	"k8s.io/client-go/tools/clientcmd"
)

func NewCError(err error) string {
	return fmt.Sprintf("{\"error\": \"%s\"}", strings.ReplaceAll(err.Error(), "\"", "'"))
}

func NewClient(contextName, server, ca string, insecure bool, userCert, userKey, userToken, userName, userPassword, proxy string, timeout int64) (*rest.Config, *kubernetes.Clientset, error) {

	var bytes = []byte(`kind: Config
apiVersion: v1
clusters:
- cluster:
    insecure-skip-tls-verify: ` + fmt.Sprintf("%v", insecure) + `
    certificate-authority-data: ` + ca + `
    server: ` + server + `
  name: ` + contextName + `
contexts:
- context:
    cluster: k8z
    user: k8z
  name: ` + contextName + `
current-context: ` + contextName + `
preferences: {}
users:
- name: k8z
  user:
    client-certificate-data: ` + userCert + `
    client-key-data: ` + userKey + `
    username: ` + userName + `
    password: ` + userPassword + `
    token: ` + userToken + `
`)

	config, err := clientcmd.NewClientConfigFromBytes(bytes)

	if err != nil {
		return nil, nil, err
	}

	restClient, err := config.ClientConfig()
	if err != nil {
		return nil, nil, err
	}

	if timeout > 0 {
		restClient.Timeout = time.Duration(timeout) * time.Second
	}

	if proxy != "" {
		proxyURL, err := url.Parse(proxy)
		if err != nil {
			return nil, nil, err
		}

		restClient.Transport = &http.Transport{Proxy: http.ProxyURL(proxyURL)}
	}

	clientset, err := kubernetes.NewForConfig(restClient)
	if err != nil {
		return nil, nil, err
	}

	return restClient, clientset, nil
}
