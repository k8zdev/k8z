package main

// #include <stdlib.h>
// #include "stdint.h"
import "C"

import (
	"context"
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"reflect"
	"strings"
	"unsafe"

	"github.com/k8zdev/k8z/gopkg/k8z"
	"github.com/k8zdev/k8z/gopkg/local"
	"k8s.io/apimachinery/pkg/types"
	"k8s.io/client-go/rest"
	"sigs.k8s.io/yaml"
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

func isZero(v reflect.Value) bool {
	switch v.Kind() {
	case reflect.Array, reflect.Map, reflect.Slice, reflect.String:
		return v.Len() == 0
	case reflect.Bool:
		return !v.Bool()
	case reflect.Int, reflect.Int8, reflect.Int16, reflect.Int32, reflect.Int64:
		return v.Int() == 0
	case reflect.Uint, reflect.Uint8, reflect.Uint16, reflect.Uint32, reflect.Uint64, reflect.Uintptr:
		return v.Uint() == 0
	case reflect.Float32, reflect.Float64:
		return v.Float() == 0
	case reflect.Interface, reflect.Ptr:
		return v.IsNil()
	}
	return false
}

func omitEmptyFields(i interface{}) interface{} {
	v := reflect.ValueOf(i)

	switch v.Kind() {
	case reflect.Map:
		iter := v.MapRange()
		newMap := reflect.MakeMap(v.Type())
		for iter.Next() {
			key := iter.Key()
			val := iter.Value()
			cleanedVal := omitEmptyFields(val.Interface())
			if !isZero(reflect.ValueOf(cleanedVal)) {
				newMap.SetMapIndex(key, reflect.ValueOf(cleanedVal))
			}
		}
		return newMap.Interface()
	case reflect.Slice:
		newSlice := reflect.MakeSlice(v.Type(), 0, v.Len())
		for i := 0; i < v.Len(); i++ {
			val := v.Index(i)
			cleanedVal := omitEmptyFields(val.Interface())
			if !isZero(reflect.ValueOf(cleanedVal)) {
				newSlice = reflect.Append(newSlice, reflect.ValueOf(cleanedVal))
			}
		}
		return newSlice.Interface()
	default:
		return i
	}
}

//export Json2yaml
func Json2yaml(src *C.char, len C.int) *C.char {
	var yamlBytes = []byte{}
	var bytes = C.GoBytes(unsafe.Pointer(src), len)
	var data interface{}
	var err = json.Unmarshal(bytes, &data)
	if err != nil {
		log.Printf("covert json to yaml faild, unmarshal json error: %#v", err)
		return C.CString("")
	}

	var omited = omitEmptyFields(data)

	yamlBytes, err = yaml.Marshal(omited)
	if err != nil {
		log.Printf("covert json to yaml faild, marshal yaml error: %#v", err)
		return C.CString("")
	}

	return C.CString(string(yamlBytes))
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
