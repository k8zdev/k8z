package main

// #include <stdlib.h>
// #include "stdint.h"
import "C"

import (
	"github.com/k8zdev/k8z/gopkg/local"
)

// StartLocalServer starts an Go server.
// 
//export StartLocalServer
func StartLocalServer() {
	go local.Server()
}
