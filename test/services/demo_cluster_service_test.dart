import 'package:flutter_test/flutter_test.dart';
import 'package:k8zdev/services/demo_cluster_service.dart';
import 'package:k8zdev/dao/kube.dart';

void main() {
  group('DemoClusterService', () {
    test('isDemoCluster should return true for demo clusters', () {
      final demoCluster = K8zCluster.createDemo(
        name: '演示集群',
        server: 'https://demo.k8s.io',
        caData: 'test-ca-data',
      );
      
      expect(DemoClusterService.isDemoCluster(demoCluster), isTrue);
    });
    
    test('isDemoCluster should return false for regular clusters', () {
      final regularCluster = K8zCluster(
        name: '生产集群',
        server: 'https://prod.k8s.io',
        caData: 'prod-ca-data',
        namespace: 'default',
        insecure: false,
        clientKey: '',
        clientCert: '',
        username: '',
        password: '',
        token: '',
        createdAt: DateTime.now().millisecondsSinceEpoch,
      );
      
      expect(DemoClusterService.isDemoCluster(regularCluster), isFalse);
    });
    
    test('createDemo factory should create cluster with correct flags', () {
      final demoCluster = K8zCluster.createDemo(
        name: '测试演示集群',
        server: 'https://test.k8s.io',
        caData: 'test-ca',
      );
      
      expect(demoCluster.isDemo, isTrue);
      expect(demoCluster.isReadOnly, isTrue);
      expect(demoCluster.name, equals('测试演示集群'));
      expect(demoCluster.server, equals('https://test.k8s.io'));
    });
  });
}