package main

// #include <stdlib.h>
// #include "stdint.h"
import "C"

import (
	"unsafe"

	"github.com/k8zdev/k8z/gopkg/local"
)

// PinStatic do nothing, call it at swift just keep the static libarary be linked.
//
//export PinStatic
func PinStatic() {}

// FreePointer can be used to free a returned pointer.
//
//export FreePointer
func FreePointer(ptr *C.char) {
	C.free(unsafe.Pointer(ptr))
}

// LocalServerAddr return listen address of web server.
//
//export LocalServerAddr
func LocalServerAddr() *C.char {
	return C.CString(local.Addr)
}

// StartLocalServer starts an Go server.
//
//export StartLocalServer
func StartLocalServer() {
	go local.Server()
}
