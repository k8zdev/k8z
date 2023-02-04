import 'dart:ffi';
import 'dart:io';

// ignore: camel_case_types
typedef startlocalserver_func = Void Function();
typedef StartLocalServerFunc = void Function();

class K8zMobile {
  static final K8zMobile _instance = K8zMobile._internal();
  late DynamicLibrary _library;

  factory K8zMobile() {
    return _instance;
  }

  K8zMobile._internal() {
    String libraryPath = _getLibraryPath();
    if (libraryPath == '') {
      exit(0);
    }
    _library = DynamicLibrary.open(libraryPath);
  }

  static String _getLibraryPath() {
    if (Platform.isIOS) {
      return 'libs/k8z.a';
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
