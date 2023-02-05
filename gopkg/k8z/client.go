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

func NewClient(contextName, clusterServer, clusterCaData string, clusterInsecureSkipTLSVerify bool, userCertificateData, userKeyData, userToken, userUsername, userPassword, proxy string, timeout int64) (*rest.Config, *kubernetes.Clientset, error) {
	config, err := clientcmd.NewClientConfigFromBytes([]byte(`apiVersion: v1
clusters:
  - cluster:
      certificate-authority-data: ` + clusterCaData + `
      insecure-skip-tls-verify: ` + fmt.Sprintf("%t", clusterInsecureSkipTLSVerify) + `
      server: ` + clusterServer + `
    name: kubenav
contexts:
  - context:
      cluster: kubenav
      user: kubenav
    name: kubenav
current-context: kubenav
kind: Config
users:
  - name: kubenav
    user:
      client-certificate-data: ` + userCertificateData + `
      client-key-data: ` + userKeyData + `
      password: ` + userPassword + `
      token: ` + userToken + `
      username: ` + userUsername))

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
