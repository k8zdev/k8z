import 'dart:async';
import 'package:flutter/material.dart';
import 'package:k8zdev/services/analytics_service.dart';
import 'package:k8zdev/services/title_update_service.dart';
import 'package:k8zdev/services/context_info_provider.dart';
import 'package:k8zdev/common/ops.dart';

/// Analytics 路由观察器
/// 监听路由变化并自动触发页面标题更新和 Analytics 事件
class AnalyticsRouteObserver extends NavigatorObserver {
  // 防抖机制，避免频繁触发事件
  static const Duration _debounceDelay = Duration(milliseconds: 500);
  Timer? _debounceTimer;
  String? _currentScreenName;
  String? _previousScreenName;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _handleRouteChange(route, previousRoute, 'push');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _handleRouteChange(previousRoute, route, 'pop');
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _handleRouteChange(newRoute, oldRoute, 'replace');
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    // 通常不需要为 remove 操作记录 Analytics 事件
    talker.debug('Analytics: Route removed - ${_getRouteName(route)}');
  }

  /// 处理路由变化
  void _handleRouteChange(
    Route<dynamic>? currentRoute,
    Route<dynamic>? previousRoute,
    String action,
  ) {
    if (currentRoute == null) return;

    final currentScreenName = _getScreenNameFromRoute(currentRoute);
    final previousScreenName = previousRoute != null 
        ? _getScreenNameFromRoute(previousRoute) 
        : null;

    // 防抖处理，避免快速连续的路由变化
    _debounceTimer?.cancel();
    _debounceTimer = Timer(_debounceDelay, () {
      _processRouteChange(
        currentScreenName,
        previousScreenName,
        currentRoute,
        action,
      );
    });
  }

  /// 处理路由变化的核心逻辑
  void _processRouteChange(
    String currentScreenName,
    String? previousScreenName,
    Route<dynamic> currentRoute,
    String action,
  ) {
    try {
      // 只处理命名路由（定义在 GoRouter 中的路由）
      // 跳过 MaterialPageRoute、CupertinoPageRoute 等非命名路由
      final routeName = _getRouteName(currentRoute);
      if (routeName.isEmpty) {
        return; // 跳过非命名路由
      }

      // 避免重复记录相同的屏幕
      if (_currentScreenName == currentScreenName) {
        return;
      }

      _previousScreenName = _currentScreenName;
      _currentScreenName = currentScreenName;

      talker.debug(
        'Analytics: Route change detected - '
        'Action: $action, '
        'From: ${_previousScreenName ?? 'none'}, '
        'To: $currentScreenName'
      );

      // 获取当前路由的 BuildContext
      final context = currentRoute.navigator?.context;
      if (context == null) {
        talker.warning('Analytics: No context available for route analytics');
        return;
      }

      // 记录页面访问事件
      _logPageViewEvent(context, currentScreenName, action);

      // 记录屏幕转换事件（如果有前一个屏幕）
      if (_previousScreenName != null && _previousScreenName != currentScreenName) {
        _logScreenTransitionEvent(_previousScreenName!, currentScreenName, action);
      }

    } catch (e) {
      talker.error('Analytics: Failed to process route change - $e');
    }
  }

  /// 记录页面访问事件
  void _logPageViewEvent(
    BuildContext context,
    String screenName,
    String action,
  ) {
    try {
      // 获取当前路由路径
      final routePath = ContextInfoProvider.getCurrentRoutePath(context);
      
      // 使用 TitleUpdateService 处理路由变化
      TitleUpdateService.handleRouteChange(
        context: context,
        newRoutePath: routePath,
        screenName: screenName,
      );
      
      // 记录页面访问事件（TitleUpdateService 会处理标题更新和 Analytics）
      // 这里我们仍然记录一个额外的导航事件
      AnalyticsService.logPageView(
        context: context,
        screenName: screenName,
        additionalParams: {
          'navigation_action': action,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
          'route_observer_triggered': 'true',
        },
      );
    } catch (e) {
      talker.error('Analytics: Failed to log page view event - $e');
    }
  }

  /// 记录屏幕转换事件
  void _logScreenTransitionEvent(
    String fromScreen,
    String toScreen,
    String action,
  ) {
    try {
      AnalyticsService.logScreenTransition(
        fromScreen: fromScreen,
        toScreen: toScreen,
        additionalParams: {
          'navigation_action': action,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
      );
    } catch (e) {
      talker.error('Analytics: Failed to log screen transition event - $e');
    }
  }

  /// 从路由中提取屏幕名称
  String _getScreenNameFromRoute(Route<dynamic> route) {
    // 尝试从路由设置中获取名称
    final routeName = _getRouteName(route);
    
    if (routeName.isNotEmpty) {
      return _convertRouteNameToScreenName(routeName);
    }

    // 如果没有路由名称，尝试从路由类型推断
    final routeType = route.runtimeType.toString();
    return _convertRouteTypeToScreenName(routeType);
  }

  /// 获取路由名称
  String _getRouteName(Route<dynamic> route) {
    final settings = route.settings;
    return settings.name ?? '';
  }

  /// 将路由名称转换为屏幕名称
  String _convertRouteNameToScreenName(String routeName) {
    // 移除前导斜杠
    String screenName = routeName.startsWith('/') 
        ? routeName.substring(1) 
        : routeName;

    // 处理嵌套路由路径
    final pathSegments = screenName.split('/');
    
    // 根据路径段生成屏幕名称
    if (pathSegments.isEmpty) {
      return 'HomePage';
    }

    // 处理特殊路径
    switch (pathSegments[0]) {
      case 'clusters':
        if (pathSegments.length > 1) {
          switch (pathSegments[1]) {
            case 'home':
              return 'ClusterHomePage';
            case 'create':
              if (pathSegments.length > 2 && pathSegments[2] == 'manual') {
                return 'ManualLoadSubPage';
              }
              return 'ClusterCreatePage';
            case 'choice':
              return 'ChoiceClustersSubPage';
          }
        }
        return 'ClustersPage';
        
      case 'workloads':
        if (pathSegments.length > 1) {
          switch (pathSegments[1]) {
            case 'pods':
              return 'PodsPage';
            case 'deployments':
              return 'DeploymentsPage';
            case 'daemon_sets':
              return 'DaemonSetsPage';
            case 'stateful_sets':
              return 'StatefulSetsPage';
            case 'replicasets':
              return 'ReplicaSetsPage';
            case 'services':
              return 'ServicesPage';
            case 'ingresses':
              return 'IngressesPage';
            case 'endpoints':
              return 'EndpointsPage';
            case 'helm_releases':
              return 'HelmReleasesPage';
          }
        }
        return 'WorkloadsPage';
        
      case 'resources':
        if (pathSegments.length > 1) {
          switch (pathSegments[1]) {
            case 'nodes':
              return 'NodesPage';
            case 'namespaces':
              return 'NamespacesPage';
            case 'events':
              return 'EventsPage';
            case 'crds':
              return 'CrdsPage';
            case 'config_maps':
              return 'ConfigMapsPage';
            case 'secrets':
              return 'SecretsPage';
            case 'service_accounts':
              return 'ServiceAccountsPage';
            case 'storage_class':
              return 'StorageClassPage';
            case 'pvs':
              return 'PvsPage';
            case 'pvcs':
              return 'PvcsPage';
          }
        }
        return 'ResourcesPage';
        
      case 'settings':
        if (pathSegments.length > 1) {
          if (pathSegments.contains('locale')) {
            return 'LocaleSettingPage';
          } else if (pathSegments.contains('appstore')) {
            return 'AppStorePaywallPage';
          }
        }
        return 'SettingsPage';
        
      case 'details':
        if (pathSegments.length > 1 && pathSegments[1] == 'yaml') {
          return 'YamlPage';
        }
        return 'DetailsPage';
        
      default:
        // 将路径转换为 PascalCase 并添加 Page 后缀
        return '${_toPascalCase(pathSegments[0])}Page';
    }
  }

  /// 将路由类型转换为屏幕名称
  String _convertRouteTypeToScreenName(String routeType) {
    // 处理常见的路由类型
    if (routeType.contains('MaterialPageRoute')) {
      return 'MaterialPage';
    } else if (routeType.contains('CupertinoPageRoute')) {
      return 'CupertinoPage';
    } else if (routeType.contains('PageRouteBuilder')) {
      return 'CustomPage';
    } else {
      return 'UnknownPage';
    }
  }

  /// 将字符串转换为 PascalCase
  String _toPascalCase(String input) {
    if (input.isEmpty) return input;
    
    // 处理下划线分隔的字符串
    final words = input.split('_');
    return words.map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join();
  }

  /// 获取当前屏幕名称
  String? get currentScreenName => _currentScreenName;

  /// 获取前一个屏幕名称
  String? get previousScreenName => _previousScreenName;

  /// 清理资源
  void dispose() {
    _debounceTimer?.cancel();
    _debounceTimer = null;
  }
}