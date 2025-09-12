import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:k8zdev/services/page_title_manager.dart';
import 'package:k8zdev/services/context_info_provider.dart';
import 'package:k8zdev/common/ops.dart';

/// 增强的 Analytics 服务
/// 提供完整的页面追踪和事件记录功能，包含页面标题和上下文信息
class AnalyticsService {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  
  // 事件队列，用于批量上报和重试
  static final List<_PendingEvent> _eventQueue = [];
  static const int _maxRetries = 3;
  static const Duration _retryDelay = Duration(seconds: 2);
  static const int _maxQueueSize = 100; // 最大队列大小，防止内存泄漏
  
  // 网络连接检查
  static final Connectivity _connectivity = Connectivity();
  static bool _isProcessingQueue = false;

  /// 记录页面访问事件
  /// 
  /// [context] - Flutter 上下文，用于获取页面信息和国际化文本
  /// [screenName] - 屏幕名称，用于 Analytics 识别
  /// [customTitle] - 自定义标题，如果提供则优先使用
  /// [additionalParams] - 额外的事件参数
  static Future<void> logPageView({
    required BuildContext context,
    required String screenName,
    String? customTitle,
    Map<String, Object>? additionalParams,
  }) async {
    try {
      // 获取上下文信息
      final contextInfo = ContextInfoProvider.getCurrentContext(context);
      
      // 生成页面标题
      final pageTitle = PageTitleManager.generatePageTitle(
        context: context,
        screenName: screenName,
        customTitle: customTitle,
        contextInfo: contextInfo,
      );

      // 获取当前路由路径和语言
      final routePath = ContextInfoProvider.getCurrentRoutePath(context);
      final language = ContextInfoProvider.getCurrentLanguage(context);

      // 构建 Analytics 参数
      final parameters = PageTitleManager.generateAnalyticsParameters(
        pageTitle: pageTitle,
        screenName: screenName,
        routePath: routePath,
        language: language,
        contextInfo: contextInfo,
      );

      // 添加页面特定的元数据
      parameters['page_load_time'] = DateTime.now().millisecondsSinceEpoch;
      parameters['has_cluster_context'] = ContextInfoProvider.hasClusterContext(context);
      parameters['has_namespace_context'] = ContextInfoProvider.hasNamespaceContext(context);
      parameters['is_resource_detail'] = ContextInfoProvider.isResourceDetailPage(context);

      // 添加额外参数
      if (additionalParams != null) {
        parameters.addAll(additionalParams);
      }

      // 记录页面访问事件
      await _logEventWithRetry(
        eventName: 'screen_view',
        parameters: parameters,
        screenName: screenName,
        screenClass: _extractScreenClass(screenName),
      );

      debugPrint('Analytics: Page view logged - $pageTitle (${language.toUpperCase()})');
    } catch (e) {
      debugPrint('Analytics: Failed to log page view - $e');
      // 不抛出异常，避免影响用户体验
    }
  }

  /// 记录屏幕转换事件
  /// 
  /// [fromScreen] - 来源屏幕名称
  /// [toScreen] - 目标屏幕名称
  /// [additionalParams] - 额外的事件参数
  static Future<void> logScreenTransition({
    required String fromScreen,
    required String toScreen,
    Map<String, Object>? additionalParams,
  }) async {
    try {
      final parameters = <String, Object>{
        'from_screen': fromScreen,
        'to_screen': toScreen,
        'transition_time': DateTime.now().millisecondsSinceEpoch,
      };

      if (additionalParams != null) {
        parameters.addAll(additionalParams);
      }

      await _logEventWithRetry(
        eventName: 'screen_transition',
        parameters: parameters,
      );

      debugPrint('Analytics: Screen transition logged - $fromScreen -> $toScreen');
    } catch (e) {
      debugPrint('Analytics: Failed to log screen transition - $e');
    }
  }

  /// 记录自定义事件
  /// 
  /// [eventName] - 事件名称
  /// [parameters] - 事件参数
  static Future<void> logEvent({
    required String eventName,
    Map<String, Object>? parameters,
  }) async {
    try {
      await _logEventWithRetry(
        eventName: eventName,
        parameters: parameters ?? {},
      );

      debugPrint('Analytics: Custom event logged - $eventName');
    } catch (e) {
      debugPrint('Analytics: Failed to log custom event - $e');
    }
  }

  /// 记录购买事件（保持向后兼容）
  /// 
  /// [currency] - 货币类型
  /// [value] - 金额
  /// [items] - 购买项目
  /// [transactionId] - 交易ID
  /// [parameters] - 额外参数
  static Future<void> logPurchase({
    String? currency = "CNY",
    double? value,
    List<AnalyticsEventItem>? items,
    String? transactionId,
    Map<String, Object>? parameters,
  }) async {
    try {
      await _analytics.logPurchase(
        currency: currency,
        value: value,
        transactionId: transactionId,
        parameters: parameters,
      );

      debugPrint('Analytics: Purchase logged - $value $currency');
    } catch (e) {
      debugPrint('Analytics: Failed to log purchase - $e');
    }
  }

  /// 设置用户属性
  /// 
  /// [name] - 属性名称
  /// [value] - 属性值
  static Future<void> setUserProperty({
    required String name,
    required String value,
  }) async {
    try {
      await _analytics.setUserProperty(name: name, value: value);
      debugPrint('Analytics: User property set - $name: $value');
    } catch (e) {
      debugPrint('Analytics: Failed to set user property - $e');
    }
  }

  /// 设置用户ID
  /// 
  /// [userId] - 用户ID
  static Future<void> setUserId(String? userId) async {
    try {
      await _analytics.setUserId(id: userId);
      debugPrint('Analytics: User ID set - $userId');
    } catch (e) {
      debugPrint('Analytics: Failed to set user ID - $e');
    }
  }

  /// 记录语言切换事件
  /// 
  /// [oldLanguage] - 旧语言代码
  /// [newLanguage] - 新语言代码
  /// [context] - Flutter 上下文（可选）
  static Future<void> logLanguageChange({
    String? oldLanguage,
    required String newLanguage,
    BuildContext? context,
  }) async {
    try {
      final parameters = <String, Object>{
        'old_language': oldLanguage ?? 'auto',
        'new_language': newLanguage,
        'change_time': DateTime.now().millisecondsSinceEpoch,
      };

      // 如果有上下文，添加当前页面信息
      if (context != null) {
        final routePath = ContextInfoProvider.getCurrentRoutePath(context);
        if (routePath.isNotEmpty) {
          parameters['current_page'] = routePath;
        }
      }

      await _logEventWithRetry(
        eventName: 'language_change',
        parameters: parameters,
      );

      // 清空页面标题缓存
      PageTitleManager.clearTitleCache();

      debugPrint('Analytics: Language change logged - ${oldLanguage ?? 'auto'} -> $newLanguage');
    } catch (e) {
      debugPrint('Analytics: Failed to log language change - $e');
    }
  }

  /// 记录上下文切换事件（集群或命名空间切换）
  /// 
  /// [contextType] - 上下文类型（'cluster' 或 'namespace'）
  /// [oldValue] - 旧值
  /// [newValue] - 新值
  /// [context] - Flutter 上下文（可选）
  static Future<void> logContextChange({
    required String contextType,
    String? oldValue,
    required String newValue,
    BuildContext? context,
  }) async {
    try {
      final parameters = <String, Object>{
        'context_type': contextType,
        'old_value': oldValue ?? 'none',
        'new_value': newValue,
        'change_time': DateTime.now().millisecondsSinceEpoch,
      };

      // 如果有上下文，添加当前页面和语言信息
      if (context != null) {
        final routePath = ContextInfoProvider.getCurrentRoutePath(context);
        final language = ContextInfoProvider.getCurrentLanguage(context);
        
        if (routePath.isNotEmpty) {
          parameters['current_page'] = routePath;
        }
        parameters['language'] = language;
      }

      await _logEventWithRetry(
        eventName: 'context_change',
        parameters: parameters,
      );

      // 清空页面标题缓存，因为上下文已更改
      PageTitleManager.clearTitleCache();

      debugPrint('Analytics: Context change logged - $contextType: ${oldValue ?? 'none'} -> $newValue');
    } catch (e) {
      debugPrint('Analytics: Failed to log context change - $e');
    }
  }

  /// 带重试机制的事件记录
  static Future<void> _logEventWithRetry({
    required String eventName,
    required Map<String, Object> parameters,
    String? screenName,
    String? screenClass,
    int retryCount = 0,
  }) async {
    try {
      // 检查网络连接
      if (!await _isNetworkAvailable()) {
        throw Exception('No network connection available');
      }

      if (eventName == 'screen_view') {
        // 使用 logScreenView 方法
        await _analytics.logScreenView(
          screenName: screenName,
          screenClass: screenClass,
          parameters: parameters,
        );
      } else {
        // 使用通用的 logEvent 方法
        await _analytics.logEvent(
          name: eventName,
          parameters: parameters,
        );
      }
    } catch (e) {
      // 记录错误到 talker
      talker.error('Analytics event failed: $eventName - $e');
      
      if (retryCount < _maxRetries) {
        // 检查队列大小，防止内存泄漏
        if (_eventQueue.length < _maxQueueSize) {
          _eventQueue.add(_PendingEvent(
            eventName: eventName,
            parameters: parameters,
            screenName: screenName,
            screenClass: screenClass,
            retryCount: retryCount + 1,
            timestamp: DateTime.now(),
          ));

          // 延迟后重试
          Future.delayed(_retryDelay, () {
            _processPendingEvents();
          });
        } else {
          talker.warning('Analytics queue is full, dropping event: $eventName');
        }
      } else {
        talker.error('Analytics: Event failed after $retryCount retries - $eventName');
      }
      
      // 不重新抛出异常，避免影响用户体验
    }
  }

  /// 处理待处理的事件队列
  static Future<void> _processPendingEvents() async {
    if (_eventQueue.isEmpty || _isProcessingQueue) return;

    _isProcessingQueue = true;
    
    try {
      // 检查网络连接
      if (!await _isNetworkAvailable()) {
        talker.info('Analytics: No network connection, keeping events in queue');
        return;
      }

      // 清理过期事件（超过1小时的事件）
      final now = DateTime.now();
      _eventQueue.removeWhere((event) {
        final isExpired = now.difference(event.timestamp).inHours > 1;
        if (isExpired) {
          talker.info('Analytics: Removing expired event - ${event.eventName}');
        }
        return isExpired;
      });

      final eventsToProcess = List<_PendingEvent>.from(_eventQueue);
      _eventQueue.clear();

      int successCount = 0;
      int failureCount = 0;

      for (final event in eventsToProcess) {
        try {
          await _logEventWithRetry(
            eventName: event.eventName,
            parameters: event.parameters,
            screenName: event.screenName,
            screenClass: event.screenClass,
            retryCount: event.retryCount,
          );
          successCount++;
        } catch (e) {
          failureCount++;
          talker.error('Analytics: Failed to process pending event - ${event.eventName}: $e');
        }
      }

      if (successCount > 0 || failureCount > 0) {
        talker.info('Analytics: Processed queue - Success: $successCount, Failed: $failureCount');
      }
    } finally {
      _isProcessingQueue = false;
    }
  }

  /// 检查网络连接是否可用
  static Future<bool> _isNetworkAvailable() async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      return connectivityResult.contains(ConnectivityResult.mobile) ||
             connectivityResult.contains(ConnectivityResult.wifi) ||
             connectivityResult.contains(ConnectivityResult.ethernet);
    } catch (e) {
      talker.warning('Analytics: Failed to check network connectivity - $e');
      // 如果无法检查网络状态，假设网络可用
      return true;
    }
  }

  /// 批量处理事件队列（用于应用启动时或网络恢复时）
  static Future<void> processPendingEventsIfNeeded() async {
    if (_eventQueue.isNotEmpty && await _isNetworkAvailable()) {
      await _processPendingEvents();
    }
  }

  /// 从屏幕名称提取屏幕类别
  static String _extractScreenClass(String screenName) {
    // 移除 'Page' 后缀
    String className = screenName.replaceAll('Page', '');
    
    // 根据屏幕名称分类
    if (className.contains('Cluster')) {
      return 'cluster_management';
    } else if (className.contains('Pod') || 
               className.contains('Deployment') || 
               className.contains('DaemonSet') || 
               className.contains('StatefulSet') || 
               className.contains('ReplicaSet')) {
      return 'workloads';
    } else if (className.contains('Service') || 
               className.contains('Ingress') || 
               className.contains('Endpoint')) {
      return 'networking';
    } else if (className.contains('ConfigMap') || 
               className.contains('Secret') || 
               className.contains('ServiceAccount')) {
      return 'configuration';
    } else if (className.contains('Node') || 
               className.contains('Namespace') || 
               className.contains('Event') || 
               className.contains('Crd')) {
      return 'cluster_resources';
    } else if (className.contains('Storage') || 
               className.contains('Pv')) {
      return 'storage';
    } else if (className.contains('Setting')) {
      return 'settings';
    } else if (className.contains('Detail') || 
               className.contains('Yaml')) {
      return 'resource_details';
    } else {
      return 'general';
    }
  }

  /// 获取待处理事件数量（用于调试）
  static int get pendingEventsCount => _eventQueue.length;

  /// 清空事件队列（用于测试）
  static void clearEventQueue() {
    _eventQueue.clear();
  }
}

/// 待处理的事件
class _PendingEvent {
  final String eventName;
  final Map<String, Object> parameters;
  final String? screenName;
  final String? screenClass;
  final int retryCount;
  final DateTime timestamp;

  const _PendingEvent({
    required this.eventName,
    required this.parameters,
    this.screenName,
    this.screenClass,
    required this.retryCount,
    required this.timestamp,
  });
}