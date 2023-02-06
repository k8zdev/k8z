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
	userCertC *C.char, userCertLen C.int,
	userKeyDataC *C.char, userKeyDataLen C.int,
	userTokenC *C.char, userTokenLen C.int,
	userNameC *C.char, userNameLen C.int,
	userPasswordC *C.char, userPasswordLen C.int,
	proxyC *C.char, proxyLen C.int,
	timeoutC C.int64_t,
	methodC *C.char, mehtodLen C.int,
	apiC *C.char, apiLen C.int,
	bodyC *C.char, bodyLen C.int,
) (respC *C.char, errC *C.char) {

	var server string = cstr2String(serverC, serverLen)

	var caData string = cstr2String(caDataC, caDataLen)

	var insecure bool = bool(insecureC)

	var userCert string = cstr2String(userCertC, userCertLen)

	var userKeyData string = cstr2String(userKeyDataC, userKeyDataLen)

	var userToken string = cstr2String(userTokenC, userTokenLen)

	var userName string = cstr2String(userNameC, userNameLen)

	var userPassword string = cstr2String(userPasswordC, userPasswordLen)

	var proxy string = cstr2String(proxyC, proxyLen)

	var timeout int64 = int64(timeoutC)

	var mehtod string = cstr2String(methodC, mehtodLen)

	var api string = cstr2String(apiC, apiLen)

	var body string = cstr2String(bodyC, bodyLen)

	var errStr = ""
	var resp, err = k8zRequest(server, caData, insecure, userCert, userKeyData, userToken, userName, userPassword, proxy, timeout, mehtod, api, body)

	if err != nil {
		errStr = k8z.NewCError(err)
	}

	respC = C.CString(string(resp))
	errC = C.CString(errStr)

	return
}

func k8zRequest2(server string, caData string,
	insecure bool, userCertData, userKeyData string,
	userToken, userName, userPassword, proxy string,
	timeout int64, method, url string, body string) (resp string, err error) {

	_, _, err = k8z.NewClient("k8z", server, string(caData), insecure, string(userCertData), string(userKeyData), userToken, userName, userPassword, proxy, timeout)
	if err != nil {
		err = fmt.Errorf("create k8s client failed, error: %w", err)
		return
	}

	return
}

func k8zRequest(server string, caData string,
	insecure bool, userCertData, userKeyData string,
	userToken, userName, userPassword, proxy string,
	timeout int64, method, api string, body string) (respBody []byte, err error) {

	_, clientset, err := k8z.NewClient("k8z", server, string(caData), insecure, string(userCertData), string(userKeyData), userToken, userName, userPassword, proxy, int64(timeout))

	fmt.Printf("%v", err)

	var resp rest.Result
	var req *rest.Request
	var ctx = context.Background()
	var cli = clientset.RESTClient()

	switch strings.ToUpper(method) {
	case http.MethodGet:
		req = cli.Get()
	case http.MethodPost:
		req = cli.Post()
	case http.MethodDelete:
		req = cli.Delete()
	case http.MethodPatch:
		req = cli.Patch(types.JSONPatchType)
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
