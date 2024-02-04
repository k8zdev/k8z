import 'dart:ffi';
import 'dart:io';

// ignore: camel_case_types
typedef startlocalserver_func = Void Function();
typedef StartLocalServerFunc = void Function();

class K8zDesktop {
  static final K8zDesktop _instance = K8zDesktop._internal();
  late DynamicLibrary _library;

  factory K8zDesktop() {
    return _instance;
  }

  K8zDesktop._internal() {
    String libraryPath = _getLibraryPath();
    if (libraryPath == '') {
      exit(0);
    }
    _library = DynamicLibrary.open(libraryPath);
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

  Future<void> startLocalServer() async {
    var startLocalServerC = _library
        .lookup<NativeFunction<startlocalserver_func>>('StartLocalServer');
    final startLocalServer =
        startLocalServerC.asFunction<StartLocalServerFunc>();

    startLocalServer();

    return;
  }
}
