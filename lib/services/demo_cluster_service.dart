import 'package:http/http.dart' as http;
import 'package:k8zdev/dao/kube.dart';
import 'package:k8zdev/services/encryption_service.dart';
import 'package:k8zdev/services/demo_cluster_exception.dart';
import 'package:k8zdev/services/analytics_service.dart';
import 'package:k8zdev/common/ops.dart';
import 'package:kubeconfig/kubeconfig.dart';

/// Demo cluster service
class DemoClusterService {
  static const String readonlyDemoUrl = 'https://static.k8z.dev/k8z-demo/kubeconfig';
  static const Duration downloadTimeout = Duration(seconds: 5);
  
  /// Get embedded key from compile time
  static String get embeddedKey => 
      const String.fromEnvironment('DEMO_SECRET_KEY', defaultValue: 'k8zdev-demo-key-2024');
  
  /// Load demo cluster
  static Future<K8zCluster> loadDemoCluster() async {
    final startTime = DateTime.now();
    
    try {
      talker.info('Starting to load demo cluster');
      
      // Log start event
      AnalyticsService.logEvent(
        eventName: 'demo_cluster_load_start',
        parameters: {
          'timestamp': startTime.millisecondsSinceEpoch,
        },
      );
      
      // Try to download and decrypt config
      String kubeconfig;
      try {
        final encryptedConfig = await downloadEncryptedConfig();
        kubeconfig = await decryptConfig(encryptedConfig);
      } catch (e) {
        talker.warning('Remote config loading failed, using local demo config: $e');
        // Fallback to local demo config
        // kubeconfig = await _getFallbackDemoConfig();
        kubeconfig = "";
      }

      talker.log("kubeconfig: $kubeconfig");
      
      // Create demo cluster object
      final demoCluster = await createDemoCluster(kubeconfig);
      
      final elapsed = DateTime.now().difference(startTime);
      talker.info('Demo cluster loaded successfully, elapsed: ${elapsed.inMilliseconds}ms');
      
      // Log success event
      AnalyticsService.logEvent(
        eventName: 'demo_cluster_load_success',
        parameters: {
          'elapsed_ms': elapsed.inMilliseconds,
          'cluster_name': demoCluster.name,
        },
      );
      
      return demoCluster;
    } catch (e) {
      final elapsed = DateTime.now().difference(startTime);
      talker.error('Demo cluster loading failed: $e');
      
      // Log error event
      if (e is DemoClusterException) {
        AnalyticsService.logEvent(
          eventName: 'demo_cluster_load_error',
          parameters: {
            'elapsed_ms': elapsed.inMilliseconds,
            'error_type': e.type.name,
            'error_message': e.message,
          },
        );
      }
      
      rethrow;
    }
  }  
/// Download encrypted kubeconfig
  static Future<String> downloadEncryptedConfig() async {
    try {
      final response = await http.get(
        Uri.parse(readonlyDemoUrl),
        headers: {
          'User-Agent': 'K8zDev-Demo-Client/1.0',
          'Accept': 'application/octet-stream',
        },
      ).timeout(downloadTimeout);
      
      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw DemoClusterException(
          'Download failed, status code: ${response.statusCode}',
          DemoClusterErrorType.networkError,
        );
      }
    } catch (e) {
      if (e is DemoClusterException) rethrow;
      
      throw DemoClusterException(
        'Network request failed: ${e.toString()}',
        DemoClusterErrorType.networkError,
      );
    }
  }
  
  /// Decrypt config
  static Future<String> decryptConfig(String encryptedData) async {
    try {
      if (embeddedKey.isEmpty) {
        throw DemoClusterException(
          'Decryption key not found, please check build configuration',
          DemoClusterErrorType.configurationError,
        );
      }
      
      return await EncryptionService.decryptWithKey(
        encryptedData,
        embeddedKey,
      );
    } catch (e) {
      if (e is EncryptionException) {
        throw DemoClusterException(
          e.message,
          DemoClusterErrorType.decryptionError,
        );
      }
      rethrow;
    }
  }
  
  /// Create demo cluster object
  static Future<K8zCluster> createDemoCluster(String raw) async {
    try {
      final kubeconfig = Kubeconfig.fromYaml(raw);
      final validation = kubeconfig.validate();
      talker.info("config validation: ${validation.toJson()}");
      
      // Parse kubeconfig
      // final rawName = kubeconfig.currentContext ??"";
      final cluster = kubeconfig.clusters?[0].cluster;
      final user = kubeconfig.authInfos?[0].user;
      final context = kubeconfig.contexts?[0].context;
      
      final demoCluster = K8zCluster.createDemo(
        name: 'Demo Cluster (Read-only)',
        server: cluster?.server??"",
        caData: cluster?.certificateAuthorityData?? '',
        namespace: context?.namespace ?? 'default',
        clientKey:  user?.clientKeyData ??"",
        clientCert: user?.clientCertificateData ?? '',
        username: user?.username ?? '',
        password: user?.password ?? '',
        token: user?.token ?? '',
      );
      
      // Save to database
      return await K8zCluster.insert(demoCluster);
    } catch (e) {
      throw DemoClusterException(
        'Config parsing failed: ${e.toString()}',
        DemoClusterErrorType.configurationError,
      );
    }
  }
  
  /// Check if cluster is demo
  static bool isDemoCluster(K8zCluster cluster) {
    return cluster.isDemo;
  }
}