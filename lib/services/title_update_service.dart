import 'dart:async';
import 'package:flutter/material.dart';
import 'package:k8zdev/services/page_title_manager.dart';
import 'package:k8zdev/services/analytics_service.dart';
import 'package:k8zdev/services/context_info_provider.dart';

/// 标题更新服务
/// 负责处理动态标题更新，包括语言切换和上下文变化时的标题刷新
class TitleUpdateService {
  static Timer? _debounceTimer;
  static const Duration _debounceDelay = Duration(milliseconds: 500);
  
  // 记录最后的标题和上下文，用于防抖和变化检测
  static String? _lastTitle;
  static String? _lastLanguage;
  static String? _lastCluster;
  static String? _lastNamespace;
  static String? _lastRoutePath;

  /// 处理语言切换时的标题更新
  /// 
  /// [context] - Flutter 上下文
  /// [newLanguage] - 新的语言代码
  /// [oldLanguage] - 旧的语言代码
  static void handleLanguageChange({
    required BuildContext context,
    required String newLanguage,
    String? oldLanguage,
  }) {
    debugPrint('TitleUpdateService: Language change detected - ${oldLanguage ?? 'auto'} -> $newLanguage');
    
    // 清空标题缓存
    PageTitleManager.clearTitleCache();
    
    // 记录语言切换事件
    AnalyticsService.logLanguageChange(
      oldLanguage: oldLanguage,
      newLanguage: newLanguage,
      context: context,
    );
    
    // 延迟更新标题，避免频繁触发
    _scheduleDelayedTitleUpdate(context, 'language_change');
    
    // 更新记录的语言
    _lastLanguage = newLanguage;
  }

  /// 处理集群切换时的标题更新
  /// 
  /// [context] - Flutter 上下文
  /// [newCluster] - 新的集群名称
  /// [oldCluster] - 旧的集群名称
  static void handleClusterChange({
    required BuildContext context,
    required String? newCluster,
    String? oldCluster,
  }) {
    debugPrint('TitleUpdateService: Cluster change detected - ${oldCluster ?? 'none'} -> ${newCluster ?? 'none'}');
    
    // 清空标题缓存，因为集群上下文已更改
    PageTitleManager.clearTitleCache();
    
    // 记录集群切换事件
    AnalyticsService.logContextChange(
      contextType: 'cluster',
      oldValue: oldCluster,
      newValue: newCluster ?? 'none',
      context: context,
    );
    
    // 延迟更新标题
    _scheduleDelayedTitleUpdate(context, 'cluster_change');
    
    // 更新记录的集群
    _lastCluster = newCluster;
  }

  /// 处理命名空间切换时的标题更新
  /// 
  /// [context] - Flutter 上下文
  /// [newNamespace] - 新的命名空间
  /// [oldNamespace] - 旧的命名空间
  static void handleNamespaceChange({
    required BuildContext context,
    required String? newNamespace,
    String? oldNamespace,
  }) {
    debugPrint('TitleUpdateService: Namespace change detected - ${oldNamespace ?? 'none'} -> ${newNamespace ?? 'none'}');
    
    // 清空标题缓存
    PageTitleManager.clearTitleCache();
    
    // 记录命名空间切换事件
    AnalyticsService.logContextChange(
      contextType: 'namespace',
      oldValue: oldNamespace,
      newValue: newNamespace ?? 'none',
      context: context,
    );
    
    // 延迟更新标题
    _scheduleDelayedTitleUpdate(context, 'namespace_change');
    
    // 更新记录的命名空间
    _lastNamespace = newNamespace;
  }

  /// 处理路由变化时的标题更新
  /// 
  /// [context] - Flutter 上下文
  /// [newRoutePath] - 新的路由路径
  /// [screenName] - 屏幕名称
  static void handleRouteChange({
    required BuildContext context,
    required String newRoutePath,
    required String screenName,
  }) {
    // 检查路由是否真的发生了变化
    if (_lastRoutePath == newRoutePath) {
      return;
    }
    
    debugPrint('TitleUpdateService: Route change detected - ${_lastRoutePath ?? 'none'} -> $newRoutePath');
    
    // 延迟更新标题，避免路由变化过程中的中间状态
    _scheduleDelayedTitleUpdate(context, 'route_change', screenName: screenName);
    
    // 更新记录的路由
    _lastRoutePath = newRoutePath;
  }

  /// 强制刷新当前页面标题
  /// 
  /// [context] - Flutter 上下文
  /// [screenName] - 屏幕名称
  /// [reason] - 刷新原因（用于日志）
  static void forceRefreshTitle({
    required BuildContext context,
    required String screenName,
    String reason = 'manual_refresh',
  }) {
    debugPrint('TitleUpdateService: Force refresh title - reason: $reason');
    
    // 清空缓存
    PageTitleManager.clearTitleCache();
    
    // 立即更新标题
    _updateTitleAndAnalytics(context, screenName, reason);
  }

  /// 检查是否需要更新标题
  /// 
  /// [context] - Flutter 上下文
  /// [screenName] - 屏幕名称
  /// 返回是否需要更新
  static bool shouldUpdateTitle({
    required BuildContext context,
    required String screenName,
  }) {
    try {
      // 获取当前状态
      final currentLanguage = ContextInfoProvider.getCurrentLanguage(context);
      final currentCluster = ContextInfoProvider.getCurrentClusterName(context);
      final currentNamespace = ContextInfoProvider.getCurrentNamespace(context);
      final currentRoutePath = ContextInfoProvider.getCurrentRoutePath(context);
      
      // 检查是否有变化
      final languageChanged = _lastLanguage != currentLanguage;
      final clusterChanged = _lastCluster != currentCluster;
      final namespaceChanged = _lastNamespace != currentNamespace;
      final routeChanged = _lastRoutePath != currentRoutePath;
      
      return languageChanged || clusterChanged || namespaceChanged || routeChanged;
    } catch (e) {
      debugPrint('TitleUpdateService: Error checking if title update needed - $e');
      return true; // 如果检查失败，假设需要更新
    }
  }

  /// 安排延迟的标题更新（防抖机制）
  static void _scheduleDelayedTitleUpdate(BuildContext context, String reason, {String? screenName}) {
    // 取消之前的定时器
    _debounceTimer?.cancel();
    
    // 设置新的定时器
    _debounceTimer = Timer(_debounceDelay, () {
      try {
        // 确保 context 仍然有效
        if (context.mounted) {
          final effectiveScreenName = screenName ?? _extractScreenNameFromRoute(context);
          _updateTitleAndAnalytics(context, effectiveScreenName, reason);
        }
      } catch (e) {
        debugPrint('TitleUpdateService: Error in delayed title update - $e');
      }
    });
  }

  /// 更新标题和 Analytics
  static void _updateTitleAndAnalytics(BuildContext context, String screenName, String reason) {
    try {
      // 获取上下文信息
      final contextInfo = ContextInfoProvider.getCurrentContext(context);
      
      // 生成新的页面标题
      final newTitle = PageTitleManager.generatePageTitle(
        context: context,
        screenName: screenName,
        contextInfo: contextInfo,
      );
      
      // 检查标题是否真的发生了变化
      if (_lastTitle != newTitle) {
        debugPrint('TitleUpdateService: Title updated - "$_lastTitle" -> "$newTitle" (reason: $reason)');
        
        // 记录新的页面访问事件
        AnalyticsService.logPageView(
          context: context,
          screenName: screenName,
          additionalParams: {
            'title_update_reason': reason,
            'previous_title': _lastTitle ?? 'none',
          },
        );
        
        _lastTitle = newTitle;
      } else {
        debugPrint('TitleUpdateService: Title unchanged, skipping Analytics update (reason: $reason)');
      }
      
      // 更新记录的状态
      _updateLastKnownState(context);
      
    } catch (e) {
      debugPrint('TitleUpdateService: Error updating title and analytics - $e');
    }
  }

  /// 更新最后已知的状态
  static void _updateLastKnownState(BuildContext context) {
    try {
      _lastLanguage = ContextInfoProvider.getCurrentLanguage(context);
      _lastCluster = ContextInfoProvider.getCurrentClusterName(context);
      _lastNamespace = ContextInfoProvider.getCurrentNamespace(context);
      _lastRoutePath = ContextInfoProvider.getCurrentRoutePath(context);
    } catch (e) {
      debugPrint('TitleUpdateService: Error updating last known state - $e');
    }
  }

  /// 从路由中提取屏幕名称
  static String _extractScreenNameFromRoute(BuildContext context) {
    try {
      final routePath = ContextInfoProvider.getCurrentRoutePath(context);
      
      // 简单的路由到屏幕名称映射
      if (routePath.contains('/clusters')) {
        if (routePath.contains('/create')) {
          return 'ClusterCreatePage';
        } else if (routePath.contains('/home')) {
          return 'ClusterHomePage';
        } else {
          return 'ClustersPage';
        }
      } else if (routePath.contains('/workloads')) {
        return 'WorkloadsPage';
      } else if (routePath.contains('/resources')) {
        return 'ResourcesPage';
      } else if (routePath.contains('/settings')) {
        if (routePath.contains('/locale')) {
          return 'LocaleSettingPage';
        } else {
          return 'SettingsPage';
        }
      } else if (routePath.contains('/details')) {
        return 'DetailsPage';
      } else if (routePath.contains('/yaml')) {
        return 'YamlPage';
      } else {
        return 'UnknownPage';
      }
    } catch (e) {
      debugPrint('TitleUpdateService: Error extracting screen name from route - $e');
      return 'UnknownPage';
    }
  }

  /// 清理资源
  static void dispose() {
    _debounceTimer?.cancel();
    _debounceTimer = null;
    
    // 清空状态
    _lastTitle = null;
    _lastLanguage = null;
    _lastCluster = null;
    _lastNamespace = null;
    _lastRoutePath = null;
    
    debugPrint('TitleUpdateService: Disposed');
  }

  /// 获取调试信息
  static Map<String, dynamic> getDebugInfo() {
    return {
      'last_title': _lastTitle,
      'last_language': _lastLanguage,
      'last_cluster': _lastCluster,
      'last_namespace': _lastNamespace,
      'last_route_path': _lastRoutePath,
      'has_pending_timer': _debounceTimer?.isActive ?? false,
      'cache_stats': PageTitleManager.getCacheStats(),
    };
  }
}