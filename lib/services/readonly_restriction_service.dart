import 'package:flutter/material.dart';
import 'package:k8zdev/dao/kube.dart';
import 'package:k8zdev/services/demo_cluster_service.dart';

/// Service for handling read-only restrictions on demo clusters
class ReadOnlyRestrictionService {
  /// Check if a cluster is read-only
  static bool isReadOnlyCluster(K8zCluster? cluster) {
    if (cluster == null) return false;
    return cluster.isReadOnly || DemoClusterService.isDemoCluster(cluster);
  }

  /// Show read-only restriction message
  static void showReadOnlyMessage(BuildContext context, {String? operation}) {
    final message = operation != null 
        ? '此操作在演示集群中不可用：$operation'
        : '此操作在演示集群中不可用。演示集群是只读的，用于展示功能。';
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.info_outline, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.orange,
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: '了解',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  /// Create a disabled action for read-only clusters
  static Widget createReadOnlyAction({
    required BuildContext context,
    required K8zCluster? cluster,
    required Widget enabledAction,
    required String operationName,
  }) {
    if (isReadOnlyCluster(cluster)) {
      return Opacity(
        opacity: 0.5,
        child: AbsorbPointer(
          child: enabledAction,
        ),
      );
    }
    return enabledAction;
  }

  /// Wrap a callback with read-only check
  static VoidCallback? wrapWithReadOnlyCheck({
    required BuildContext context,
    required K8zCluster? cluster,
    required VoidCallback? callback,
    required String operationName,
  }) {
    if (isReadOnlyCluster(cluster)) {
      return () => showReadOnlyMessage(context, operation: operationName);
    }
    return callback;
  }

  /// Wrap a callback that takes BuildContext with read-only check
  static void Function(BuildContext)? wrapWithReadOnlyCheckContext({
    required BuildContext context,
    required K8zCluster? cluster,
    required void Function(BuildContext)? callback,
    required String operationName,
  }) {
    if (isReadOnlyCluster(cluster)) {
      return (_) => showReadOnlyMessage(context, operation: operationName);
    }
    return callback;
  }

  /// Check if operation is allowed and show message if not
  static bool checkOperationAllowed({
    required BuildContext context,
    required K8zCluster? cluster,
    required String operationName,
  }) {
    if (isReadOnlyCluster(cluster)) {
      showReadOnlyMessage(context, operation: operationName);
      return false;
    }
    return true;
  }

  /// Get read-only indicator widget
  static Widget? getReadOnlyIndicator(K8zCluster? cluster) {
    if (isReadOnlyCluster(cluster)) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.orange.withOpacity(0.2),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.orange, width: 1),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.lock_outline, size: 12, color: Colors.orange),
            SizedBox(width: 4),
            Text(
              '只读',
              style: TextStyle(
                color: Colors.orange,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }
    return null;
  }
}