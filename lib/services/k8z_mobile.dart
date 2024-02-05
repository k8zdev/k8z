import 'dart:ffi';
import 'package:ffi/ffi.dart';

// ignore: camel_case_types
typedef free_pointer_func = Void Function(Pointer<Utf8>);
typedef FreePointerFn = void Function(Pointer<Utf8>);

// ignore: camel_case_types
typedef local_server_addr_func = Pointer<Utf8> Function();
typedef LocalServerAddrFn = Pointer<Utf8> Function();

// ignore: camel_case_types
typedef start_local_server_func = Void Function();
typedef StartLocalServerFn = void Function();

class K8zMobile {
  static final K8zMobile _instance = K8zMobile._internal();
  late DynamicLibrary _library;

  factory K8zMobile() {
    return _instance;
  }

  K8zMobile._internal() {
    // load static libraries
    _library = DynamicLibrary.executable();
  }

  void free(Pointer<Utf8> pointer) {
    var C = _library.lookup<NativeFunction<free_pointer_func>>('FreePointer');
    final func = C.asFunction<FreePointerFn>();

    return func(pointer);
  }

  String localServerAddr() {
    var C = _library
        .lookup<NativeFunction<local_server_addr_func>>("LocalServerAddr");
    var func = C.asFunction<LocalServerAddrFn>();
    var addr = func();
    var result = addr.toDartString();
    free(addr);
    return result;
  }

  Future<void> startLocalServer() async {
    var C = _library
        .lookup<NativeFunction<start_local_server_func>>('StartLocalServer');
    final func = C.asFunction<StartLocalServerFn>();

    return func();
  }
}
