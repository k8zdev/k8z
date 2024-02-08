import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';

// FreePointer free pointer mem.
typedef FreePointerNative = Void Function(Pointer<Utf8>);
typedef FreePointerFn = void Function(Pointer<Utf8>);
// LocalServerAddr returns webserver lisenning address.
typedef LocalServerAddrNative = Pointer<Utf8> Function();
typedef LocalServerAddrFn = Pointer<Utf8> Function();
// StartLocalServer loads the webserver.
typedef StartLocalServerNative = Void Function();
typedef StartLocalServerFn = void Function();

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

  void _startLocalServer() async {
    StartLocalServerFn func =
        _library.lookupFunction<StartLocalServerNative, StartLocalServerFn>(
            "StartLocalServer");
    func();
  }

  Future<void> startLocalServer() async {
    _startLocalServer();
  }
}
