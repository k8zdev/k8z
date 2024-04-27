import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:k8zdev/dao/kube.dart';
import 'package:k8zdev/services/stash.dart';
import 'package:kubeconfig/kubeconfig.dart';

const currentClusterKey = "app_default_cluster";

class CurrentCluster with ChangeNotifier {
  static K8zCluster? _current;
  static K8zCluster? get current {
    assert(_current != null,
        "No instance of K8zCluster.  Try to initialize the K8zCluster before accessing K8zCluster.current");
    return _current;
  }

  init() async {
    String? raw = await vget<String>(currentClusterKey);
    if (raw.isNullOrEmpty || raw == null || raw == "null") {
      return;
    }
    final json = jsonDecode(raw);
    K8zCluster? current = K8zCluster.fromJson(json);
    _current = current;
  }

  void setCurrent(K8zCluster? cluster) {
    _current = cluster;
    vset(currentClusterKey, jsonEncode(_current?.toJson()));

    notifyListeners();
  }

  void updateNamespace(String? namespace) {
    if (_current == null) {
      return;
    }
    _current!.namespace = namespace ?? "";
    vset(currentClusterKey, jsonEncode(_current?.toJson()));
    K8zCluster.update(_current!);

    notifyListeners();
  }
}
