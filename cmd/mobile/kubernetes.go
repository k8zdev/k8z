package k8z

import (
	"github.com/k8zdev/k8z/gopkg/local"
)

func StartLocalServer() {
	go local.Server()
}
