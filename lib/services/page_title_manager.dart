import 'package:flutter/material.dart';
import 'package:k8zdev/generated/l10n.dart';
import 'package:k8zdev/services/context_info_provider.dart';

/// 页面标题管理器
/// 负责统一管理页面标题的生成和格式化，支持多语言和动态标题更新
class PageTitleManager {
  static const String _appName = 'k8z';
  static const int _maxTitleLength = 100;
  
  // 缓存最近生成的标题，避免重复计算
  static final Map<String, String> _titleCache = {};
  static const int _maxCacheSize = 50;

  /// 生成页面标题
  /// 
  /// [context] - Flutter 上下文，用于获取国际化文本
  /// [screenName] - 屏幕名称，用于 Analytics 识别
  /// [customTitle] - 自定义标题，如果提供则优先使用
  /// [contextInfo] - 上下文信息，如集群名称、命名空间等
  static String generatePageTitle({
    required BuildContext context,
    required String screenName,
    String? customTitle,
    Map<String, String>? contextInfo,
  }) {
    try {
      // 生成缓存键
      final cacheKey = _generateCacheKey(screenName, customTitle, contextInfo);
      
      // 检查缓存
      if (_titleCache.containsKey(cacheKey)) {
        return _titleCache[cacheKey]!;
      }
      
      final lang = S.of(context);
      final currentLanguage = ContextInfoProvider.getCurrentLanguage(context);
      
      String baseTitle;
      
      // 如果提供了自定义标题，直接使用
      if (customTitle != null && customTitle.isNotEmpty) {
        baseTitle = customTitle;
      } else {
        // 根据 screenName 生成对应的本地化标题
        baseTitle = _getLocalizedTitle(lang, screenName, currentLanguage);
      }
      
      final finalTitle = _formatTitle(baseTitle, contextInfo, lang);
      
      // 缓存结果（限制缓存大小）
      if (_titleCache.length >= _maxCacheSize) {
        _titleCache.clear();
      }
      _titleCache[cacheKey] = finalTitle;
      
      return finalTitle;
    } catch (e) {
      // 如果获取本地化文本失败，使用英文默认标题
      debugPrint('PageTitleManager: Failed to generate localized title, using fallback: $e');
      String fallbackTitle = _getFallbackTitle(screenName);
      return _formatTitle(fallbackTitle, contextInfo, null);
    }
  }

  /// 生成 Analytics 参数
  /// 
  /// [pageTitle] - 页面标题
  /// [screenName] - 屏幕名称
  /// [routePath] - 路由路径
  /// [language] - 当前语言
  /// [contextInfo] - 上下文信息
  static Map<String, Object> generateAnalyticsParameters({
    required String pageTitle,
    required String screenName,
    required String routePath,
    String? language,
    Map<String, String>? contextInfo,
  }) {
    final parameters = <String, Object>{
      'page_title': pageTitle,
      'screen_name': screenName,
      'route_path': routePath,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };

    // 添加语言信息（确保总是包含语言信息）
    parameters['language'] = language ?? 'en';
    parameters['language_fallback'] = language == null;

    // 添加上下文信息
    if (contextInfo != null) {
      contextInfo.forEach((key, value) {
        if (value.isNotEmpty) {
          parameters['context_$key'] = value;
        }
      });
    }

    return parameters;
  }
  
  /// 处理语言切换事件
  /// 
  /// [context] - Flutter 上下文
  /// [newLanguage] - 新的语言代码
  /// [oldLanguage] - 旧的语言代码
  static void handleLanguageChange({
    required BuildContext context,
    required String newLanguage,
    String? oldLanguage,
  }) {
    // 清空标题缓存，因为语言已更改
    clearTitleCache();
    
    debugPrint('PageTitleManager: Language changed from ${oldLanguage ?? 'auto'} to $newLanguage');
    
    // 可以在这里触发 Analytics 事件记录语言切换
    // 但为了避免循环依赖，我们让 AnalyticsService 来处理这个事件
  }

  /// 根据屏幕名称获取本地化标题
  /// 
  /// [lang] - 国际化文本对象
  /// [screenName] - 屏幕名称
  /// [languageCode] - 当前语言代码，用于日志记录
  static String _getLocalizedTitle(S lang, String screenName, String languageCode) {
    switch (screenName) {
      case 'ClusterPage':
      case 'ClustersPage':
        return lang.clusters;
      case 'WorkloadsPage':
        return lang.workloads;
      case 'ResourcesPage':
        return lang.resources;
      case 'SettingsPage':
        return lang.settings;
      case 'PodsPage':
        return lang.pods;
      case 'DeploymentsPage':
        return lang.deployments;
      case 'DaemonSetsPage':
        return lang.daemon_sets;
      case 'StatefulSetsPage':
        return lang.stateful_sets;
      case 'ReplicaSetsPage':
        return lang.replicasets;
      case 'ServicesPage':
        return lang.services;
      case 'IngressesPage':
        return lang.ingresses;
      case 'EndpointsPage':
        return lang.endpoints;
      case 'NodesPage':
        return lang.nodes;
      case 'NamespacesPage':
        return lang.namespaces;
      case 'EventsPage':
        return lang.events;
      case 'CrdsPage':
        return lang.crds;
      case 'ConfigMapsPage':
        return lang.config_maps;
      case 'SecretsPage':
        return lang.secrets;
      case 'ServiceAccountsPage':
        return lang.service_accounts;
      case 'StorageClassPage':
        return lang.storage_class;
      case 'PvsPage':
        return lang.pvs;
      case 'PvcsPage':
        return lang.pvcs;
      case 'HelmReleasesPage':
        return '${lang.helm} ${lang.releases}';
      case 'ClusterHomePage':
        return '${lang.clusters} ${lang.overview}';
      case 'ClusterCreatePage':
        return lang.add_cluster;
      case 'ManualLoadSubPage':
        return lang.manual_load_kubeconfig;
      case 'ChoiceClustersSubPage':
        return lang.select_clusters;
      case 'LocaleSettingPage':
        return lang.general_language;
      case 'AppStorePaywallPage':
        return lang.sponsorme;
      case 'DetailsPage':
        return lang.resource_yaml; // Using existing key for now
      case 'YamlPage':
        return lang.resource_yaml;
      case 'NotFoundPage':
        return _getLocalizedTextWithFallback(lang, 'page_not_found', 'Page Not Found');
      default:
        // 尝试从 screenName 中提取有意义的名称
        debugPrint('PageTitleManager: No localized title found for $screenName in language $languageCode, using extracted title');
        return _extractTitleFromScreenName(screenName);
    }
  }

  /// 获取英文默认标题（当本地化失败时使用）
  static String _getFallbackTitle(String screenName) {
    switch (screenName) {
      case 'ClusterPage':
      case 'ClustersPage':
        return 'Clusters';
      case 'WorkloadsPage':
        return 'Workloads';
      case 'ResourcesPage':
        return 'Resources';
      case 'SettingsPage':
        return 'Settings';
      case 'PodsPage':
        return 'Pods';
      case 'DeploymentsPage':
        return 'Deployments';
      case 'DaemonSetsPage':
        return 'DaemonSets';
      case 'StatefulSetsPage':
        return 'StatefulSets';
      case 'ReplicaSetsPage':
        return 'ReplicaSets';
      case 'ServicesPage':
        return 'Services';
      case 'IngressesPage':
        return 'Ingresses';
      case 'EndpointsPage':
        return 'Endpoints';
      case 'NodesPage':
        return 'Nodes';
      case 'NamespacesPage':
        return 'Namespaces';
      case 'EventsPage':
        return 'Events';
      case 'CrdsPage':
        return 'CustomResourceDefinition';
      case 'ConfigMapsPage':
        return 'ConfigMaps';
      case 'SecretsPage':
        return 'Secrets';
      case 'ServiceAccountsPage':
        return 'ServiceAccounts';
      case 'StorageClassPage':
        return 'StorageClass';
      case 'PvsPage':
        return 'Persistent Volumes';
      case 'PvcsPage':
        return 'Persistent Volume Claims';
      case 'HelmReleasesPage':
        return 'Helm Releases';
      case 'ClusterHomePage':
        return 'Cluster Overview';
      case 'ClusterCreatePage':
        return 'Add Cluster';
      case 'ManualLoadSubPage':
        return 'Load Kubeconfig File';
      case 'ChoiceClustersSubPage':
        return 'Select Clusters';
      case 'LocaleSettingPage':
        return 'Language Settings';
      case 'AppStorePaywallPage':
        return 'Sponsor';
      case 'DetailsPage':
        return 'Resource Details';
      case 'YamlPage':
        return 'Resource YAML';
      case 'NotFoundPage':
        return 'Not Found';
      default:
        return _extractTitleFromScreenName(screenName);
    }
  }

  /// 从屏幕名称中提取标题
  static String _extractTitleFromScreenName(String screenName) {
    // 移除 'Page' 后缀
    String title = screenName.replaceAll('Page', '');
    
    // 将驼峰命名转换为空格分隔的标题
    title = title.replaceAllMapped(
      RegExp(r'([A-Z])'),
      (match) => ' ${match.group(1)}',
    ).trim();
    
    return title.isEmpty ? 'Unknown Page' : title;
  }

  /// 格式化最终标题
  /// 
  /// [baseTitle] - 基础标题
  /// [contextInfo] - 上下文信息
  /// [lang] - 国际化文本对象，用于本地化上下文信息
  static String _formatTitle(String baseTitle, Map<String, String>? contextInfo, S? lang) {
    List<String> titleParts = [_appName, baseTitle];

    if (contextInfo != null) {
      // 添加集群信息
      String? clusterName = contextInfo['cluster'];
      if (clusterName != null && clusterName.isNotEmpty) {
        titleParts.add(clusterName);
      }

      // 添加命名空间信息
      String? namespace = contextInfo['namespace'];
      if (namespace != null && namespace.isNotEmpty && namespace != 'default') {
        // 如果有国际化文本，添加命名空间标签
        if (lang != null) {
          titleParts.add('${lang.namespace}: $namespace');
        } else {
          titleParts.add(namespace);
        }
      }

      // 添加资源名称（用于详情页面）
      String? resourceName = contextInfo['resource_name'];
      if (resourceName != null && resourceName.isNotEmpty) {
        titleParts.add(resourceName);
      }
    }

    String fullTitle = titleParts.join(' - ');
    
    // 确保标题不会过长
    if (fullTitle.length > _maxTitleLength) {
      fullTitle = '${fullTitle.substring(0, _maxTitleLength - 3)}...';
    }

    return fullTitle;
  }
  
  /// 生成缓存键
  static String _generateCacheKey(String screenName, String? customTitle, Map<String, String>? contextInfo) {
    final parts = [screenName];
    
    if (customTitle != null) {
      parts.add('custom:$customTitle');
    }
    
    if (contextInfo != null) {
      final sortedKeys = contextInfo.keys.toList()..sort();
      for (final key in sortedKeys) {
        parts.add('$key:${contextInfo[key]}');
      }
    }
    
    return parts.join('|');
  }
  
  /// 获取本地化文本，如果失败则使用回退文本
  static String _getLocalizedTextWithFallback(S lang, String key, String fallback) {
    try {
      // 这里我们需要根据具体的键来获取对应的本地化文本
      // 由于 S 类的方法是生成的，我们无法动态调用，所以这里先返回回退文本
      // 在实际使用中，应该为每个页面添加对应的本地化键
      return fallback;
    } catch (e) {
      debugPrint('PageTitleManager: Failed to get localized text for key $key: $e');
      return fallback;
    }
  }
  
  /// 清空标题缓存（用于语言切换时）
  static void clearTitleCache() {
    _titleCache.clear();
    debugPrint('PageTitleManager: Title cache cleared');
  }
  
  /// 获取缓存统计信息（用于调试）
  static Map<String, dynamic> getCacheStats() {
    return {
      'cache_size': _titleCache.length,
      'max_cache_size': _maxCacheSize,
      'cached_keys': _titleCache.keys.toList(),
    };
  }
}