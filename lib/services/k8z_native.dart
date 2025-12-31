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
  Duration duration;

  BodyReturn({required this.body, required this.error, required this.duration});
}

class JsonReturn {
  Map<String, dynamic> body;
  String error;
  Duration duration;

  JsonReturn({required this.body, required this.error, required this.duration});

  Map<String, dynamic> toJson() => {
        'error': error,
        'body': body,
        "duration": duration.inMilliseconds,
      };
}

// Json2yaml
typedef Json2yamlNative = Pointer<Utf8> Function(Pointer<Utf8> src, Uint32 len);
typedef Json2yamlFn = Pointer<Utf8> Function(Pointer<Utf8>, int);

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
  final reqStart = DateTime.now();
  final k8zNative = K8zNative();

  // Use an Arena for scoped memory management of request parameters.
  // Pointers allocated within the arena are automatically released.
  final result = using((Arena arena) {
    final serverPtr = args.server.toNativeUtf8(allocator: arena);
    final caDataPtr = args.caData.toNativeUtf8(allocator: arena);
    final clientCertPtr = args.clientCert.toNativeUtf8(allocator: arena);
    final clientKeyPtr = args.clientKey.toNativeUtf8(allocator: arena);
    final tokenPtr = args.token.toNativeUtf8(allocator: arena);
    final usernamePtr = args.username.toNativeUtf8(allocator: arena);
    final passwordPtr = args.password.toNativeUtf8(allocator: arena);
    final proxyPtr = args.proxy.toNativeUtf8(allocator: arena);
    final methodPtr = args.method.toNativeUtf8(allocator: arena);
    final apiPtr = args.api.toNativeUtf8(allocator: arena);
    final bodyPtr = args.body.toNativeUtf8(allocator: arena);
    final insecureInt = args.insecure ? 1 : 0;

    // Call the cached native function.
    return k8zNative.k8zRequestFn(
      serverPtr,
      args.server.length,
      caDataPtr,
      args.caData.length,
      insecureInt,
      clientCertPtr,
      args.clientCert.length,
      clientKeyPtr,
      args.clientKey.length,
      tokenPtr,
      args.token.length,
      usernamePtr,
      args.username.length,
      passwordPtr,
      args.password.length,
      proxyPtr,
      args.proxy.length,
      args.timeout,
      methodPtr,
      args.method.length,
      apiPtr,
      args.api.length,
      bodyPtr,
      args.body.length,
    );
  });

  final duration = DateTime.now().difference(reqStart);

  var resp = BodyReturn(
    body: k8zNative.ptr2String(result.body),
    error: k8zNative.ptr2String(result.error),
    duration: duration,
  );
  args.respPort.send(resp);

  // Manually free pointers returned from the Go function.
  k8zNative.freePointer(result.body);
  k8zNative.freePointer(result.error);
}

class K8zNative {
  static final K8zNative _instance = K8zNative._internal();
  late final DynamicLibrary _library;

  // Cached native function pointers.
  late final FreePointerFn _freePointerFn;
  late final Json2yamlFn _json2yamlFn;
  late final LocalServerAddrFn _localServerAddrFn;
  late final StartLocalServerFn _startLocalServerFn;
  late final K8zRequestFn k8zRequestFn;

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

    // Eagerly lookup and cache native functions upon initialization.
    _freePointerFn = _library
        .lookupFunction<FreePointerNative, FreePointerFn>("FreePointer");
    _json2yamlFn =
        _library.lookupFunction<Json2yamlNative, Json2yamlFn>("Json2yaml");
    _localServerAddrFn =
        _library.lookupFunction<LocalServerAddrNative, LocalServerAddrFn>(
            "LocalServerAddr");
    _startLocalServerFn =
        _library.lookupFunction<StartLocalServerNative, StartLocalServerFn>(
            "StartLocalServer");
    k8zRequestFn =
        _library.lookupFunction<K8zRequestNative, K8zRequestFn>("K8zRequest");
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

  /// Frees a pointer allocated by the native library.
  void freePointer(Pointer<Utf8> pointer) {
    return _freePointerFn(pointer);
  }

  String _json2yaml(Pointer<Utf8> src, int len) {
    final ptr = _json2yamlFn(src, len);
    final result = ptr2String(ptr);
    // Free the pointer returned by the native function to prevent a memory leak.
    freePointer(ptr);
    return result;
  }

  static String json2yaml(String src) {
    // Use an arena to manage the memory of the source pointer.
    return using((arena) {
      final srcPtr = src.toNativeUtf8(allocator: arena);
      return K8zNative()._json2yaml(srcPtr, src.length);
    });
  }

  String _localServerAddr() {
    final addr = _localServerAddrFn();
    final result = addr.toDartString();
    // Free the pointer returned by the native function.
    freePointer(addr);
    return result;
  }

  String localServerAddr() {
    return _localServerAddr();
  }

  void _startLocalServer() {
    _startLocalServerFn();
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
      return JsonReturn(body: {}, error: resp.error, duration: resp.duration);
    }

    final jsonBody = jsonDecode(resp.body);
    return JsonReturn(
      body: jsonBody,
      error: resp.error,
      duration: resp.duration,
    );
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

