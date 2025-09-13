import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:k8zdev/dao/kube.dart';
import 'package:k8zdev/services/stash.dart';
import 'package:k8zdev/services/title_update_service.dart';
import 'package:kubeconfig/kubeconfig.dart';

const currentClusterKey = "app_default_cluster";

class CurrentCluster with ChangeNotifier {
  static K8zCluster? _current;
  static K8zCluster? get current {
    return _current;
  }

  K8zCluster? get cluster {
    return _current;
  }

  // 保存当前的 BuildContext 用于标题更新
  BuildContext? _currentContext;

  init() async {
    String? raw = await vget<String>(currentClusterKey);
    if (raw.isNullOrEmpty || raw == null || raw == "null") {
      return;
    }
    final json = jsonDecode(raw);
    K8zCluster? current = K8zCluster.fromJson(json);
    _current = current;
  }

  /// 设置当前的 BuildContext（用于标题更新）
  void setCurrentContext(BuildContext? context) {
    _currentContext = context;
  }

  void setCurrent(K8zCluster? cluster) {
    final oldCluster = _current?.name;
    final newCluster = cluster?.name;
    
    CurrentCluster._current = cluster;
    vset(currentClusterKey, jsonEncode(_current?.toJson()));

    // 如果有当前上下文且集群发生了变化，处理集群切换的标题更新
    if (_currentContext != null && _currentContext!.mounted && oldCluster != newCluster) {
      TitleUpdateService.handleClusterChange(
        context: _currentContext!,
        newCluster: newCluster,
        oldCluster: oldCluster,
      );
    }

    notifyListeners();
  }

  void updateNamespace(String? namespace) {
    if (_current == null) {
      return;
    }
    
    final oldNamespace = _current!.namespace.isEmpty ? null : _current!.namespace;
    final newNamespace = namespace?.isEmpty == true ? null : namespace;
    
    _current!.namespace = namespace ?? "";
    vset(currentClusterKey, jsonEncode(_current?.toJson()));
    K8zCluster.update(_current!);

    // 如果有当前上下文且命名空间发生了变化，处理命名空间切换的标题更新
    if (_currentContext != null && _currentContext!.mounted && oldNamespace != newNamespace) {
      TitleUpdateService.handleNamespaceChange(
        context: _currentContext!,
        newNamespace: newNamespace,
        oldNamespace: oldNamespace,
      );
    }

    notifyListeners();
  }
}
