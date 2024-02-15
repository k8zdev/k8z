import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:k8zdev/dao/kube.dart';
import 'package:k8zdev/services/stash.dart';

const currentClusterKey = "app_default_cluster";

class CurrentCluster with ChangeNotifier {
  K8zCluster? _current;
  K8zCluster? get current => _current;

  init() async {
    String? raw = await vget<String>(currentClusterKey);
    var current = K8zCluster.fromJson(jsonDecode(raw ?? ""));
    _current = current;
  }

  void setCurrent(K8zCluster? cluster) {
    _current = cluster;
    vset(currentClusterKey, jsonEncode(_current?.toJson()));

    notifyListeners();
  }
}
