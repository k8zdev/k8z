import 'dart:io';

import 'package:k8sapp/services/k8z_desktop.dart';
import 'package:k8sapp/services/k8z_mobile.dart';

class K8zService {
  K8zService();

  Future<void> startLocalServer() async {
    if (Platform.isMacOS) {
      await K8zDesktop().startLocalServer();
      return;
    } else if (Platform.isIOS) {
      await K8zMobile().startLocalServer();
    }
  }
}
