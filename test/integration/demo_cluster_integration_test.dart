// ignore_for_file: deprecated_member_use_from_same_package

import 'package:flutter_test/flutter_test.dart';
import 'package:k8zdev/services/demo_cluster_service.dart';
import 'package:k8zdev/services/encryption_service.dart';
import 'package:k8zdev/services/onboarding_guide_service.dart';
import 'package:k8zdev/services/readonly_restriction_service.dart';
import 'package:k8zdev/dao/kube.dart';
import 'package:k8zdev/models/guide_step_definition.dart';
import 'dart:convert';

void main() {
  group('Demo Cluster Integration Tests', () {
    test('should encrypt and decrypt demo config correctly', () async {
      const testConfig = 'Hello, World!';
      const key = 'k8zdev-demo-key-2024';
      
      // Encrypt (simulate what the tool does)
      final keyBytes = utf8.encode(key);
      final dataBytes = utf8.encode(testConfig);
      
      final encryptedBytes = <int>[];
      for (int i = 0; i < dataBytes.length; i++) {
        encryptedBytes.add(dataBytes[i] ^ keyBytes[i % keyBytes.length]);
      }
      
      final encryptedData = base64.encode(encryptedBytes);
      
      // Decrypt using service
      final decryptedConfig = await EncryptionService.decryptWithKey(
        encryptedData,
        key,
      );
      
      expect(decryptedConfig, equals(testConfig));
    });
    
    test('should identify demo clusters correctly', () {
      final demoCluster = K8zCluster.createDemo(
        name: 'Test Demo',
        server: 'https://demo.k8s.io',
        caData: 'test-ca',
      );
      
      final regularCluster = K8zCluster(
        name: 'Regular Cluster',
        server: 'https://prod.k8s.io',
        caData: 'prod-ca',
        namespace: 'default',
        insecure: false,
        clientKey: '',
        clientCert: '',
        username: '',
        password: '',
        token: '',
        createdAt: DateTime.now().millisecondsSinceEpoch,
      );
      
      expect(DemoClusterService.isDemoCluster(demoCluster), isTrue);
      expect(DemoClusterService.isDemoCluster(regularCluster), isFalse);
    });
    
    test('should have correct embedded key', () {
      expect(DemoClusterService.embeddedKey, equals('k8zdev-demo-key-2024'));
    });

    test('should integrate onboarding guide with demo cluster', () async {
      final demoCluster = K8zCluster.createDemo(
        name: 'Integration Test Demo',
        server: 'https://demo.k8s.io',
        caData: 'test-ca',
      );

      final guideService = OnboardingGuideService();

      // Start guide
      await guideService.startGuide(demoCluster);
      expect(guideService.isGuideActive, isTrue);
      expect(guideService.currentStepId, equals(DemoClusterGuide.welcomeStepId));

      // Progress through 8-step guide:
      // 1. welcome -> workloadsOverview
      // 2. workloadsOverview -> podListWithSwipe
      // 3. podListWithSwipe -> podDetail
      // 4. podDetail -> resourcesMenu
      // 5. resourcesMenu -> nodesListWithSwipe
      // 6. nodesListWithSwipe -> nodeDetail
      // 7. nodeDetail -> completed
      await guideService.nextStep();
      expect(guideService.currentStepId, equals(DemoClusterGuide.workloadsOverviewStepId));

      await guideService.nextStep();
      expect(guideService.currentStepId, equals(DemoClusterGuide.podListWithSwipeStepId));

      await guideService.nextStep();
      expect(guideService.currentStepId, equals(DemoClusterGuide.podDetailStepId));

      await guideService.nextStep();
      expect(guideService.currentStepId, equals(DemoClusterGuide.resourcesMenuStepId));

      await guideService.nextStep();
      expect(guideService.currentStepId, equals(DemoClusterGuide.nodesListWithSwipeStepId));

      await guideService.nextStep();
      expect(guideService.currentStepId, equals(DemoClusterGuide.nodeDetailStepId));

      await guideService.nextStep();
      expect(guideService.currentStepId, equals(DemoClusterGuide.completedStepId));

      await guideService.nextStep();
      expect(guideService.isGuideActive, isFalse);
    });

    test('should apply read-only restrictions to demo clusters', () {
      final demoCluster = K8zCluster.createDemo(
        name: 'Read-Only Test Demo',
        server: 'https://demo.k8s.io',
        caData: 'test-ca',
      );

      final regularCluster = K8zCluster(
        name: 'Regular Cluster',
        server: 'https://prod.k8s.io',
        caData: 'prod-ca',
        namespace: 'default',
        insecure: false,
        clientKey: '',
        clientCert: '',
        username: '',
        password: '',
        token: '',
        createdAt: DateTime.now().millisecondsSinceEpoch,
      );

      // Demo cluster should be read-only
      expect(ReadOnlyRestrictionService.isReadOnlyCluster(demoCluster), isTrue);
      expect(ReadOnlyRestrictionService.getReadOnlyIndicator(demoCluster), isNotNull);

      // Regular cluster should not be read-only
      expect(ReadOnlyRestrictionService.isReadOnlyCluster(regularCluster), isFalse);
      expect(ReadOnlyRestrictionService.getReadOnlyIndicator(regularCluster), isNull);
    });

    test('should handle complete onboarding flow', () async {
      // This test simulates the complete user flow
      final demoCluster = K8zCluster.createDemo(
        name: 'Complete Flow Demo',
        server: 'https://demo.k8s.io',
        caData: 'test-ca',
      );

      // 1. Verify demo cluster properties
      expect(demoCluster.isDemo, isTrue);
      expect(demoCluster.isReadOnly, isTrue);
      expect(DemoClusterService.isDemoCluster(demoCluster), isTrue);

      // 2. Verify read-only restrictions
      expect(ReadOnlyRestrictionService.isReadOnlyCluster(demoCluster), isTrue);

      // 3. Start and complete onboarding guide
      final guideService = OnboardingGuideService();
      await guideService.startGuide(demoCluster);

      expect(guideService.isGuideActive, isTrue);
      expect(guideService.state.demoCluster, equals(demoCluster));

      // Complete all 8 steps
      while (guideService.isGuideActive) {
        await guideService.nextStep();
      }

      expect(guideService.isGuideActive, isFalse);
    });

    test('should measure performance for 30-second goal', () async {
      final startTime = DateTime.now();
      
      // Simulate the key operations that should complete within 30 seconds
      final demoCluster = K8zCluster.createDemo(
        name: 'Performance Test Demo',
        server: 'https://demo.k8s.io',
        caData: 'test-ca',
      );

      final guideService = OnboardingGuideService();
      await guideService.startGuide(demoCluster);

      // Complete guide quickly through all 8 steps
      while (guideService.isGuideActive) {
        await guideService.nextStep();
      }

      final elapsed = DateTime.now().difference(startTime);

      // The core operations should be very fast (well under 30 seconds)
      expect(elapsed.inSeconds, lessThan(5));
      expect(guideService.isGuideActive, isFalse);
    });
  });
}