import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';
import 'package:k8sapp/dao/kube.dart';

// _BodyReturn defines struct of golang reutrn (body, error string)
final class BodyReturnNative extends Struct {
  external Pointer<Utf8> body;
  external Pointer<Utf8> error;
}

class BodyReturn {
  String? body;
  String? error;

  BodyReturn(body, error);
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

class K8zService {
  static final K8zService _instance = K8zService._internal();
  late DynamicLibrary _library;

  factory K8zService() {
    return _instance;
  }

  K8zService._internal() {
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

  Future<void> startLocalServer() async {
    _startLocalServer();
  }

  BodyReturnNative _k8zRequest(
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
  ) {
    K8zRequestFn func =
        _library.lookupFunction<K8zRequestNative, K8zRequestFn>("K8zRequest");
    return func(
      server,
      serverLen,
      caData,
      caDataLen,
      insecure,
      userCertData,
      userCertDataLen,
      userKeyData,
      userKeyDataLen,
      userToken,
      userTokenLen,
      userName,
      userNameLen,
      password,
      passwordLen,
      proxy,
      proxyLen,
      timeout,
      method,
      methodLen,
      api,
      apiLen,
      body,
      bodyLen,
    );
  }

  BodyReturn k8zRequest(
    K8zCluster cluster,
    String proxy,
    int timeout,
    String method,
    String api,
    String body,
  ) {
    final Pointer<Utf8> serverPtr = cluster.server.toNativeUtf8();
    final int serverLen = cluster.server.length;
    final Pointer<Utf8> caDataPtr = cluster.caData.toNativeUtf8();
    final caDataLen = cluster.caData.length;

    final Pointer<Utf8> userCertDataPtr = cluster.clientCert.toNativeUtf8();
    final userCertDataLen = cluster.clientCert.length;
    final Pointer<Utf8> userKeyDataPtr = cluster.clientKey.toNativeUtf8();
    final userKeyDataLen = cluster.clientKey.length;

    final Pointer<Utf8> userTokenPtr = cluster.token.toNativeUtf8();
    final userTokenLen = cluster.token.length;
    final Pointer<Utf8> usernamePtr = cluster.username.toNativeUtf8();
    final usernameLen = cluster.username.length;
    final Pointer<Utf8> passwordPtr = cluster.password.toNativeUtf8();
    final passwordLen = cluster.password.length;
    final Pointer<Utf8> proxyPtr = proxy.toNativeUtf8();
    final proxyLen = proxy.length;

    final Pointer<Utf8> methodPtr = method.toNativeUtf8();
    final methodLen = method.length;
    final Pointer<Utf8> apiPtr = api.toNativeUtf8();
    final apiLen = api.length;
    final Pointer<Utf8> bodyPtr = body.toNativeUtf8();
    final bodyLen = body.length;

    final int insecureInt = cluster.insecure ? 1 : 0;

    final result = _k8zRequest(
      serverPtr,
      serverLen,
      caDataPtr,
      caDataLen,
      insecureInt,
      userCertDataPtr,
      userCertDataLen,
      userKeyDataPtr,
      userKeyDataLen,
      userTokenPtr,
      userTokenLen,
      usernamePtr,
      usernameLen,
      passwordPtr,
      passwordLen,
      proxyPtr,
      proxyLen,
      timeout,
      methodPtr,
      methodLen,
      apiPtr,
      apiLen,
      bodyPtr,
      bodyLen,
    );

    var resp = BodyReturn(result.body, result.error);

    // free
    free(serverPtr.address);
    free(caDataPtr.address);
    free(userCertDataPtr.address);
    free(userKeyDataPtr.address);
    free(userTokenPtr.address);
    free(usernamePtr.address);
    free(passwordPtr.address);
    free(proxyPtr.address);
    free(methodPtr.address);
    free(apiPtr.address);
    free(bodyPtr.address);
    return resp;
  }
}
