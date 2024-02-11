import 'package:flutter/foundation.dart';
import 'package:k8sapp/services/stash.dart';

const currentClusterKey = "app_default_cluster";

class CurrentCluster with ChangeNotifier {
  late String? _current;
  String? get current => _current;

  init() async {
    String? current = await vget<String>(currentClusterKey);
    _current = current;
  }

  void setCurrent(String? cluster) {
    _current = cluster;
    vset(currentClusterKey, _current);
    notifyListeners();
  }
}
