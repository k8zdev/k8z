import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:k8zdev/providers/current_cluster.dart';
import 'package:k8zdev/generated/l10n.dart';
import 'package:provider/provider.dart';

/// 上下文信息提供器
/// 负责提供页面相关的上下文信息，如当前集群、命名空间等
class ContextInfoProvider {
  /// 获取当前页面的完整上下文信息
  /// 
  /// [context] - Flutter 上下文
  /// 返回包含集群、命名空间、路由等信息的 Map
  static Map<String, String> getCurrentContext(BuildContext context) {
    final contextInfo = <String, String>{};

    try {
      // 获取当前集群信息
      final clusterName = getCurrentClusterName(context);
      if (clusterName != null && clusterName.isNotEmpty) {
        contextInfo['cluster'] = clusterName;
      }

      // 获取当前命名空间（从路由参数中提取）
      final namespace = getCurrentNamespace(context);
      if (namespace != null && namespace.isNotEmpty) {
        contextInfo['namespace'] = namespace;
      }

      // 获取当前语言
      final language = getCurrentLanguage(context);
      if (language.isNotEmpty) {
        contextInfo['language'] = language;
      }

      // 获取路由路径
      final routePath = getCurrentRoutePath(context);
      if (routePath.isNotEmpty) {
        contextInfo['route_path'] = routePath;
      }

      // 从路由参数中提取资源信息
      final resourceInfo = getResourceInfoFromRoute(context);
      contextInfo.addAll(resourceInfo);

    } catch (e) {
      // 如果获取上下文信息失败，记录错误但不影响功能
      debugPrint('Failed to get context info: $e');
    }

    return contextInfo;
  }

  /// 获取当前集群名称
  /// 
  /// [context] - Flutter 上下文，可选参数
  /// 返回当前选中的集群名称，如果没有则返回 null
  static String? getCurrentClusterName([BuildContext? context]) {
    try {
      if (context != null) {
        // 尝试从 Provider 获取当前集群
        final currentCluster = Provider.of<CurrentCluster>(context, listen: false);
        return currentCluster.cluster?.name;
      } else {
        // 如果没有 context，尝试从静态方法获取
        return CurrentCluster.current?.name;
      }
    } catch (e) {
      debugPrint('Failed to get current cluster name: $e');
      return null;
    }
  }

  /// 获取当前命名空间
  /// 
  /// [context] - Flutter 上下文
  /// 从路由参数中提取命名空间信息
  static String? getCurrentNamespace(BuildContext context) {
    try {
      final routerState = GoRouterState.of(context);
      
      // 从路由参数中获取命名空间
      final namespace = routerState.pathParameters['namespace'];
      
      // 如果命名空间是 "_"，表示为空命名空间
      if (namespace == '_') {
        return null;
      }
      
      return namespace;
    } catch (e) {
      debugPrint('Failed to get current namespace: $e');
      return null;
    }
  }

  /// 获取当前语言设置
  /// 
  /// [context] - Flutter 上下文
  /// 返回当前的语言代码（如 'en', 'zh', 'ja'）
  static String getCurrentLanguage(BuildContext context) {
    try {
      final locale = Localizations.localeOf(context);
      return locale.languageCode;
    } catch (e) {
      debugPrint('Failed to get current language: $e');
      return 'en'; // 默认返回英文
    }
  }

  /// 获取当前路由路径
  /// 
  /// [context] - Flutter 上下文
  /// 返回当前的路由路径
  static String getCurrentRoutePath(BuildContext context) {
    try {
      final routerState = GoRouterState.of(context);
      return routerState.matchedLocation;
    } catch (e) {
      debugPrint('Failed to get current route path: $e');
      return '';
    }
  }

  /// 从路由中提取资源信息
  /// 
  /// [context] - Flutter 上下文
  /// 返回包含资源类型、名称等信息的 Map
  static Map<String, String> getResourceInfoFromRoute(BuildContext context) {
    final resourceInfo = <String, String>{};

    try {
      final routerState = GoRouterState.of(context);
      final pathParams = routerState.pathParameters;

      // 提取资源类型
      final resource = pathParams['resource'];
      if (resource != null && resource.isNotEmpty) {
        resourceInfo['resource_type'] = resource;
      }

      // 提取资源名称
      final name = pathParams['name'];
      if (name != null && name.isNotEmpty) {
        resourceInfo['resource_name'] = name;
      }

      // 提取路径信息（用于详情页面）
      final path = pathParams['path'];
      if (path != null && path.isNotEmpty) {
        resourceInfo['resource_path'] = path;
      }

      // 提取文件名（用于 YAML 页面）
      final file = pathParams['file'];
      if (file != null && file.isNotEmpty) {
        resourceInfo['file_name'] = file;
      }

      // 提取 item URL（用于 YAML 页面）
      final itemUrl = pathParams['itemUrl'];
      if (itemUrl != null && itemUrl.isNotEmpty) {
        resourceInfo['item_url'] = itemUrl;
      }

    } catch (e) {
      debugPrint('Failed to get resource info from route: $e');
    }

    return resourceInfo;
  }

  /// 生成页面的上下文描述
  /// 
  /// [context] - Flutter 上下文
  /// 返回人类可读的上下文描述字符串
  static String generateContextDescription(BuildContext context) {
    final contextInfo = getCurrentContext(context);
    final parts = <String>[];

    final clusterName = contextInfo['cluster'];
    if (clusterName != null && clusterName.isNotEmpty) {
      parts.add('Cluster: $clusterName');
    }

    final namespace = contextInfo['namespace'];
    if (namespace != null && namespace.isNotEmpty) {
      parts.add('Namespace: $namespace');
    }

    final resourceType = contextInfo['resource_type'];
    final resourceName = contextInfo['resource_name'];
    if (resourceType != null && resourceName != null) {
      parts.add('Resource: $resourceType/$resourceName');
    }

    return parts.isEmpty ? 'No context' : parts.join(', ');
  }

  /// 检查当前是否在集群上下文中
  /// 
  /// [context] - Flutter 上下文
  /// 返回是否有当前选中的集群
  static bool hasClusterContext([BuildContext? context]) {
    final clusterName = getCurrentClusterName(context);
    return clusterName != null && clusterName.isNotEmpty;
  }

  /// 检查当前是否在命名空间上下文中
  /// 
  /// [context] - Flutter 上下文
  /// 返回是否有当前的命名空间
  static bool hasNamespaceContext(BuildContext context) {
    final namespace = getCurrentNamespace(context);
    return namespace != null && namespace.isNotEmpty;
  }

  /// 检查当前是否在资源详情页面
  /// 
  /// [context] - Flutter 上下文
  /// 返回是否在查看特定资源的详情
  static bool isResourceDetailPage(BuildContext context) {
    final resourceInfo = getResourceInfoFromRoute(context);
    return resourceInfo.containsKey('resource_type') && 
           resourceInfo.containsKey('resource_name');
  }
}