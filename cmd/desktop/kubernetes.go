package main

// #include <stdlib.h>
// #include "stdint.h"
import "C"

import (
	"fmt"
	"time"

	"github.com/k8zdev/k8z/gopkg/k8z"
	"github.com/k8zdev/k8z/gopkg/local"
)

// StartLocalServer starts an Go server.
//
//export StartLocalServer
func StartLocalServer() {
	go local.Server()
}

// K8zRequest
//
//export K8zRequest
func K8zRequest(serverC *C.char, serverLen C.int,
	caDataC *C.char, caDataLen C.int, insecureC C._Bool,
	userCertC *C.char, userCertLen C.int, userKeyDataC *C.char, userKeyDataLen C.int,
	userTokenC *C.char, userTokenLen C.int, userNameC *C.char, userNameLen C.int,
	userPasswordC *C.char, userPasswordLen C.int, proxyC *C.char, proxyLen C.int,
	timeoutC C.uint, methodC *C.char, mehtodLen C.int, apiC *C.char, apiLen C.int, bodyC *C.char, bodyLen C.int) (respC *C.char, errC *C.char) {

	var server string = C.GoStringN(serverC, serverLen)
	var certificateAuthorityData string = C.GoStringN(caDataC, caDataLen)
	var insecure bool = bool(insecureC)
	var userCert string = C.GoStringN(userCertC, userCertLen)
	var userKeyData string = C.GoStringN(userKeyDataC, userKeyDataLen)
	var userToken string = C.GoStringN(userTokenC, userKeyDataLen)
	var userName string = C.GoStringN(userNameC, userNameLen)
	var userPassword string = C.GoStringN(userPasswordC, userPasswordLen)
	var proxy string = C.GoStringN(proxyC, proxyLen)
	var timeout time.Duration = time.Duration(timeoutC) * time.Second
	var mehtod string = C.GoStringN(methodC, mehtodLen)
	var url string = C.GoStringN(apiC, apiLen)
	var body string = C.GoStringN(bodyC, bodyLen)

	var resp, err = k8zRequest(server, []byte(certificateAuthorityData), insecure, []byte(userCert), []byte(userKeyData), userToken, userName, userPassword, proxy, timeout, mehtod, url, []byte(body))

	respC = C.CString(string(resp))
	errC = C.CString(k8z.NewCError(err))

	return
}

func k8zRequest(server string, caData []byte,
	insecure bool, userCertData, userKeyData []byte,
	userToken, userName, userPassword, proxy string,
	timeout time.Duration, method, url string, body []byte) (resp []byte, err error) {

	_, _, err = k8z.NewClient("k8z", server, string(caData), insecure, string(userCertData), string(userKeyData), userToken, userName, userPassword, proxy, int64(timeout))

	fmt.Printf("%v", err)

	return
}
