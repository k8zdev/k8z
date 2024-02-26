import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:isolate';

import 'package:ffi/ffi.dart';
import 'package:flutter/services.dart';
import 'package:k8zdev/dao/kube.dart';
import 'package:k8zdev/services/k8z_service.dart';

// _BodyReturn defines struct of golang reutrn (body, error string)
final class BodyReturnNative extends Struct {
  external Pointer<Utf8> body;
  external Pointer<Utf8> error;
}

class BodyReturn {
  String body;
  String error;

  BodyReturn({required this.body, required this.error});
}

class JsonReturn {
  Map<String, dynamic> body;
  String error;

  JsonReturn({required this.body, required this.error});
}

// FreePointer free pointer mem.
typedef FreePointerNative = Void Function(Pointer<Utf8>);
typedef FreePointerFn = void Function(Pointer<Utf8>);
// LocalServerAddr returns webserver lisenning address.
typedef LocalServerAddrNative = Pointer<Utf8> Function();
typedef LocalServerAddrFn = Pointer<Utf8> Function();
// StartLocalServer loads the webserver.
typedef StartLocalServerNative = Void Function();
typedef StartLocalServerFn = void Function();
typedef K8zRequestNative = BodyReturnNative Function(
  Pointer<Utf8> server,
  Uint32 serverLen,
  Pointer<Utf8> caData,
  Uint32 caDataLen,
  Uint8 insecure,
  Pointer<Utf8> userCertData,
  Uint32 userCertDataLen,
  Pointer<Utf8> userKeyData,
  Uint32 userKeyDataLen,
  Pointer<Utf8> userToken,
  Uint32 userTokenLen,
  Pointer<Utf8> userName,
  Uint32 userNameLen,
  Pointer<Utf8> password,
  Uint32 passwordLen,
  Pointer<Utf8> proxy,
  Uint32 proxyLen,
  Int64 timeout,
  Pointer<Utf8> method,
  Uint32 methodLen,
  Pointer<Utf8> api,
  Uint32 apiLen,
  Pointer<Utf8> body,
  Uint32 bodyLen,
);
typedef K8zRequestFn = BodyReturnNative Function(
  Pointer<Utf8> server,
  int serverLen,
  Pointer<Utf8> caData,
  int caDataLen,
  int insecure,
  Pointer<Utf8> userCertData,
  int userCertDataLen,
  Pointer<Utf8> userKeyData,
  int userKeyDataLen,
  Pointer<Utf8> userToken,
  int userTokenLen,
  Pointer<Utf8> userName,
  int userNameLen,
  Pointer<Utf8> password,
  int passwordLen,
  Pointer<Utf8> proxy,
  int proxyLen,
  int timeout,
  Pointer<Utf8> method,
  int methodLen,
  Pointer<Utf8> api,
  int apiLen,
  Pointer<Utf8> body,
  int bodyLen,
);

class _IsolateK8zRequestArgs {
  final String server;
  final String caData;
  final bool insecure;
  final String clientCert;
  final String clientKey;
  final String token;
  final String username;
  final String password;
  final String proxy;
  final int timeout;
  final String method;
  final String api;
  final String body;
  final SendPort respPort;

  _IsolateK8zRequestArgs(
    this.server,
    this.caData,
    this.insecure,
    this.clientCert,
    this.clientKey,
    this.token,
    this.username,
    this.password,
    this.proxy,
    this.timeout,
    this.method,
    this.api,
    this.body,
    this.respPort,
  );
}

void _isolateK8zRequest(_IsolateK8zRequestArgs args) {
  final Pointer<Utf8> serverPtr = args.server.toNativeUtf8();
  final int serverLen = args.server.length;
  final Pointer<Utf8> caDataPtr = args.caData.toNativeUtf8();
  final caDataLen = args.caData.length;

  final Pointer<Utf8> clientCertPtr = args.clientCert.toNativeUtf8();
  final clientCertLen = args.clientCert.length;
  final Pointer<Utf8> clientKeyPtr = args.clientKey.toNativeUtf8();
  final clientKeyLen = args.clientKey.length;

  final Pointer<Utf8> tokenPtr = args.token.toNativeUtf8();
  final tokenLen = args.token.length;
  final Pointer<Utf8> usernamePtr = args.username.toNativeUtf8();
  final usernameLen = args.username.length;
  final Pointer<Utf8> passwordPtr = args.password.toNativeUtf8();
  final passwordLen = args.password.length;
  final Pointer<Utf8> proxyPtr = args.proxy.toNativeUtf8();
  final proxyLen = args.proxy.length;

  final Pointer<Utf8> methodPtr = args.method.toNativeUtf8();
  final methodLen = args.method.length;
  final Pointer<Utf8> apiPtr = args.api.toNativeUtf8();
  final apiLen = args.api.length;
  final Pointer<Utf8> bodyPtr = args.body.toNativeUtf8();
  final bodyLen = args.body.length;

  final int insecureInt = args.insecure ? 1 : 0;

  final result = K8zNative()._k8zRequest()(
    serverPtr,
    serverLen,
    caDataPtr,
    caDataLen,
    insecureInt,
    clientCertPtr,
    clientCertLen,
    clientKeyPtr,
    clientKeyLen,
    tokenPtr,
    tokenLen,
    usernamePtr,
    usernameLen,
    passwordPtr,
    passwordLen,
    proxyPtr,
    proxyLen,
    args.timeout,
    methodPtr,
    methodLen,
    apiPtr,
    apiLen,
    bodyPtr,
    bodyLen,
  );

  var resp = BodyReturn(
      body: K8zNative().ptr2String(result.body),
      error: K8zNative().ptr2String(result.error));
  args.respPort.send(resp);

  // free
  K8zNative().free(serverPtr.address);
  K8zNative().free(caDataPtr.address);
  K8zNative().free(clientCertPtr.address);
  K8zNative().free(clientKeyPtr.address);
  K8zNative().free(tokenPtr.address);
  K8zNative().free(usernamePtr.address);
  K8zNative().free(passwordPtr.address);
  K8zNative().free(proxyPtr.address);
  K8zNative().free(methodPtr.address);
  K8zNative().free(apiPtr.address);
  K8zNative().free(bodyPtr.address);
}

class K8zNative {
  static final K8zNative _instance = K8zNative._internal();
  late DynamicLibrary _library;

  factory K8zNative() {
    return _instance;
  }

  K8zNative._internal() {
    if (Platform.isIOS) {
      // load static libraries
      _library = DynamicLibrary.executable();
    } else {
      String libraryPath = _getLibraryPath();
      if (libraryPath == '') {
        exit(0);
      }
      _library = DynamicLibrary.open(libraryPath);
    }
  }

  static String _getLibraryPath() {
    if (Platform.isWindows) {
      return 'k8z.dll';
    } else if (Platform.isLinux) {
      return 'k8z.so';
    } else if (Platform.isMacOS) {
      return 'k8z.dylib';
    } else {
      return '';
    }
  }

  void _free(Pointer<Utf8> pointer) {
    FreePointerFn func = _library
        .lookupFunction<FreePointerNative, FreePointerFn>("FreePointer");

    return func(pointer);
  }

  void free(int ptr) {
    this._free(Pointer.fromAddress(ptr));
  }

  String _localServerAddr() {
    LocalServerAddrFn func =
        _library.lookupFunction<LocalServerAddrNative, LocalServerAddrFn>(
            "LocalServerAddr");
    var addr = func();
    var result = addr.toDartString();
    free(addr.address);
    return result;
  }

  String localServerAddr() {
    return _localServerAddr();
  }

  void _startLocalServer() {
    StartLocalServerFn func =
        _library.lookupFunction<StartLocalServerNative, StartLocalServerFn>(
            "StartLocalServer");
    func();
  }

  static Future<void> _localServer(RootIsolateToken rootIsolateToken) async {
    // Register the background isolate with the root isolate.
    BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);

    K8zNative()._startLocalServer();
  }

  static Future<void> startLocalServer() async {
    // Check if the local server is already started.
    if (await K8zService.isStarted()) {
      return;
    }
    var rootIsolateToken = RootIsolateToken.instance!;
    await Isolate.spawn(_localServer, rootIsolateToken);
  }

  K8zRequestFn _k8zRequest() {
    return _library
        .lookupFunction<K8zRequestNative, K8zRequestFn>("K8zRequest");
  }

  Future<BodyReturn> k8zRequest2({
    required String server,
    required String caData,
    required bool insecure,
    String clientCert = "",
    String clientKey = "",
    String token = "",
    String username = "",
    String password = "",
    String proxy = "",
    int timeout = 30,
    required String method,
    required String api,
    String body = "",
  }) async {
    final respPort = ReceivePort();
    final errorPort = ReceivePort();

    await Isolate.spawn(
      _isolateK8zRequest,
      _IsolateK8zRequestArgs(
        server,
        caData,
        insecure,
        clientCert,
        clientKey,
        token,
        username,
        password,
        proxy,
        timeout,
        method,
        api,
        body,
        respPort.sendPort,
        // errorPort.sendPort,
      ),
      errorsAreFatal: true,
      onExit: respPort.sendPort,
      onError: errorPort.sendPort,
    );
    return respPort.first.then((resp) {
      if (resp is BodyReturn) {
        return resp;
      } else {
        throw Exception('Request failed');
      }
    });
  }

  // ptr2String convert native pointer to string.
  String ptr2String(Pointer<Utf8> ptr) {
    var string = "";
    if (ptr.address > 0) {
      string = ptr.toDartString();
    }
    return string;
  }

  Future<JsonReturn> k8zRequest(
    K8zCluster cluster,
    String proxy,
    int timeout,
    String method,
    String api,
    String body,
  ) async {
    final resp = await k8zRequest2(
      server: cluster.server,
      caData: cluster.caData,
      insecure: cluster.insecure,
      clientCert: cluster.clientCert,
      clientKey: cluster.clientKey,
      token: cluster.token,
      username: cluster.username,
      password: cluster.password,
      proxy: proxy,
      timeout: timeout,
      method: method,
      api: api,
      body: body,
    );
    if (resp.error.isNotEmpty) {
      return JsonReturn(body: {}, error: resp.error);
    }

    return JsonReturn(body: jsonDecode(resp.body), error: resp.error);
  }

  Future<BodyReturn> k8zRequestRaw(
    K8zCluster cluster,
    String proxy,
    int timeout,
    String method,
    String api,
    String body,
  ) async {
    final resp = await k8zRequest2(
      server: cluster.server,
      caData: cluster.caData,
      insecure: cluster.insecure,
      clientCert: cluster.clientCert,
      clientKey: cluster.clientKey,
      token: cluster.token,
      username: cluster.username,
      password: cluster.password,
      proxy: proxy,
      timeout: timeout,
      method: method,
      api: api,
      body: body,
    );

    return resp;
  }
}
