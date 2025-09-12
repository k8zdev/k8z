import 'package:flutter/material.dart';
import 'package:k8zdev/generated/l10n.dart';

/// 页面标题管理器
/// 负责统一管理页面标题的生成和格式化
class PageTitleManager {
  static const String _appName = 'k8z';
  static const int _maxTitleLength = 100;

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
      final lang = S.of(context);
      
      // 如果提供了自定义标题，直接使用
      if (customTitle != null && customTitle.isNotEmpty) {
        return _formatTitle(customTitle, contextInfo);
      }

      // 根据 screenName 生成对应的本地化标题
      String baseTitle = _getLocalizedTitle(lang, screenName);
      
      return _formatTitle(baseTitle, contextInfo);
    } catch (e) {
      // 如果获取本地化文本失败，使用英文默认标题
      String fallbackTitle = _getFallbackTitle(screenName);
      return _formatTitle(fallbackTitle, contextInfo);
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
    };

    // 添加语言信息
    if (language != null && language.isNotEmpty) {
      parameters['language'] = language;
    }

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

  /// 根据屏幕名称获取本地化标题
  static String _getLocalizedTitle(S lang, String screenName) {
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
        return 'Resource Details';
      case 'YamlPage':
        return lang.resource_yaml;
      case 'NotFoundPage':
        return 'Not Found';
      default:
        // 尝试从 screenName 中提取有意义的名称
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
  static String _formatTitle(String baseTitle, Map<String, String>? contextInfo) {
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
        titleParts.add(namespace);
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
}