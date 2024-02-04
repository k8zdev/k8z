import 'dart:io';

import 'package:k8sapp/services/k8z_desktop.dart';

class K8zService {
  K8zService();

  Future<void> startLocalServer() async {
    if (Platform.isMacOS) {
      await K8zDesktop().startLocalServer();
      return;
    }
  }
}
