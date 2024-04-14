package main

// #include <stdlib.h>
// #include "stdint.h"
import "C"

import (
	"context"
	"fmt"
	"net/http"
	"strings"
	"unsafe"

	"github.com/k8zdev/k8z/gopkg/k8z"
	"github.com/k8zdev/k8z/gopkg/local"
	"k8s.io/apimachinery/pkg/types"
	"k8s.io/client-go/rest"
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

//export Json2yaml
func Json2yaml(*C.char) *C.char {
	return C.CString("")
}

//export MultiParams
func MultiParams(name *C.char, nameLen C.int, timeout C.int64_t, insecure C._Bool) (body *C.char, err *C.char) {
	var nameStr = C.GoStringN(name, nameLen)
	var timeoutGo = int64(timeout)
	var insecureGo = bool(insecure)
	if C.GoStringN(name, nameLen) == "err" {
		return nil, C.CString("has error")
	}
	return C.CString(
		fmt.Sprintf("ok, name: %s, timeout: %d, insecure: %t",
			nameStr, timeoutGo, insecureGo,
		),
	), nil
}

// K8zRequest
//
//export K8zRequest
func K8zRequest(
	serverC *C.char, serverLen C.int,
	caDataC *C.char, caDataLen C.int,
	insecureC C._Bool,
	clientCertC *C.char, clientCertLen C.int,
	clientKeyC *C.char, clientKeyLen C.int,
	tokenC *C.char, tokenLen C.int,
	usernameC *C.char, usernameLen C.int,
	passwordC *C.char, passwordLen C.int,
	proxyC *C.char, proxyLen C.int,
	timeoutC C.int64_t,
	methodC *C.char, mehtodLen C.int,
	apiC *C.char, apiLen C.int,
	bodyC *C.char, bodyLen C.int,
) (respC *C.char, errC *C.char) {

	var server string = cstr2String(serverC, serverLen)

	var caData string = cstr2String(caDataC, caDataLen)

	var insecure bool = bool(insecureC)

	var clientCert string = cstr2String(clientCertC, clientCertLen)

	var clientKeyData string = cstr2String(clientKeyC, clientKeyLen)

	var token string = cstr2String(tokenC, tokenLen)

	var username string = cstr2String(usernameC, usernameLen)

	var password string = cstr2String(passwordC, passwordLen)

	var proxy string = cstr2String(proxyC, proxyLen)

	var timeout int64 = int64(timeoutC)

	var mehtod string = cstr2String(methodC, mehtodLen)

	var api string = cstr2String(apiC, apiLen)

	var body string = cstr2String(bodyC, bodyLen)

	var errStr = ""
	var resp, err = k8zRequest(server, caData, insecure, clientCert, clientKeyData, token, username, password, proxy, timeout, mehtod, api, body)

	if err != nil {
		errStr = k8z.NewCError(err)
	}

	respC = C.CString(string(resp))
	errC = C.CString(errStr)

	return
}

func k8zRequest(server string, caData string,
	insecure bool, clientCert, clientKey string,
	token, username, password, proxy string,
	timeout int64, method, api string, body string) (respBody []byte, err error) {

	_, clientset, err := k8z.NewClient("k8z", server, string(caData), insecure, string(clientCert), string(clientKey), token, username, password, proxy, int64(timeout))
	if err != nil {
		err = fmt.Errorf("create k8s client failed, error: %w", err)
		return
	}

	var resp rest.Result
	var req *rest.Request
	var ctx = context.Background()
	var cli = clientset.RESTClient()

	if cli == nil {
		return []byte{}, fmt.Errorf("nil client")
	}

	switch strings.ToUpper(method) {
	case http.MethodGet:
		req = cli.Get()
	case http.MethodPost:
		req = cli.Post()
	case http.MethodDelete:
		req = cli.Delete()
	case http.MethodPatch:
		req = cli.Patch(types.JSONPatchType).Body([]byte(body))
	default:
		req = cli.Verb(strings.ToUpper(method))
	}

	resp = req.RequestURI(api).Do(ctx)

	if resp.Error() != nil {
		return []byte{}, resp.Error()
	}

	var statusCode int
	resp = resp.StatusCode(&statusCode)
	if statusCode == http.StatusUnauthorized {
		return []byte{}, fmt.Errorf(http.StatusText(http.StatusUnauthorized))
	}

	respBody, err = resp.Raw()
	if err != nil {
		return []byte{}, err
	}

	if statusCode < 200 || statusCode >= 300 {
		return []byte{}, fmt.Errorf(string(respBody))
	}

	return
}
