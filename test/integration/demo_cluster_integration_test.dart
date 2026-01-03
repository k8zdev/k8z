// ignore_for_file: deprecated_member_use_from_same_package

import 'package:flutter_test/flutter_test.dart';
import 'package:k8zdev/services/demo_cluster_service.dart';
import 'package:k8zdev/services/encryption_service.dart';
import 'package:k8zdev/services/onboarding_guide_service.dart';
import 'package:k8zdev/services/readonly_restriction_service.dart';
import 'package:k8zdev/dao/kube.dart';
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
      expect(guideService.currentStep, equals(GuideStep.welcome));

      // Progress through steps with 3-step guide:
      // 1. welcome -> podList
      // 2. podList -> nodes (additionalFeatures)
      // 3. nodes -> completed
      await guideService.nextStep();
      expect(guideService.currentStep, equals(GuideStep.podList));

      await guideService.nextStep();
      expect(guideService.currentStep, equals(GuideStep.additionalFeatures));

      await guideService.nextStep();
      expect(guideService.currentStep, equals(GuideStep.completed));
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

      // Complete all steps
      while (guideService.currentStep != GuideStep.completed) {
        await guideService.nextStep();
      }

      expect(guideService.isGuideActive, isFalse);
      expect(guideService.currentStep, equals(GuideStep.completed));
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

      // Complete guide quickly
      await guideService.nextStep(); // welcome -> podList
      await guideService.nextStep(); // podList -> additionalFeatures
      await guideService.nextStep(); // additionalFeatures -> completed

      final elapsed = DateTime.now().difference(startTime);
      
      // The core operations should be very fast (well under 30 seconds)
      expect(elapsed.inSeconds, lessThan(5));
      expect(guideService.currentStep, equals(GuideStep.completed));
    });
  });
}