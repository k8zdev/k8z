import 'package:flutter_test/flutter_test.dart';
import 'package:k8zdev/services/onboarding_guide_service.dart';
import 'package:k8zdev/dao/kube.dart';

void main() {
  group('OnboardingGuideService', () {
    late OnboardingGuideService service;
    late K8zCluster demoCluster;

    setUp(() {
      service = OnboardingGuideService();
      demoCluster = K8zCluster.createDemo(
        name: 'Test Demo Cluster',
        server: 'https://demo.k8s.io',
        caData: 'test-ca-data',
      );
    });

    test('should start guide correctly', () async {
      expect(service.isGuideActive, isFalse);
      expect(service.currentStep, equals(GuideStep.welcome));

      await service.startGuide(demoCluster);

      expect(service.isGuideActive, isTrue);
      expect(service.currentStep, equals(GuideStep.welcome));
      expect(service.state.demoCluster, equals(demoCluster));
      expect(service.state.startTime, isNotNull);
    });

    test('should progress through guide steps', () async {
      await service.startGuide(demoCluster);

      // Welcome -> Pod List
      await service.nextStep();
      expect(service.currentStep, equals(GuideStep.podList));

      // Pod List -> Pod Logs
      await service.nextStep();
      expect(service.currentStep, equals(GuideStep.podLogs));

      // Pod Logs -> Additional Features
      await service.nextStep();
      expect(service.currentStep, equals(GuideStep.additionalFeatures));

      // Additional Features -> Completed
      await service.nextStep();
      expect(service.currentStep, equals(GuideStep.completed));
      expect(service.isGuideActive, isFalse);
    });

    test('should skip guide correctly', () async {
      await service.startGuide(demoCluster);
      expect(service.isGuideActive, isTrue);

      await service.skipGuide();
      expect(service.isGuideActive, isFalse);
      expect(service.currentStep, equals(GuideStep.welcome));
    });

    test('should reset guide state', () async {
      await service.startGuide(demoCluster);
      await service.nextStep();

      service.reset();
      expect(service.isGuideActive, isFalse);
      expect(service.currentStep, equals(GuideStep.welcome));
      expect(service.state.demoCluster, isNull);
    });

    test('should not progress if guide is not active', () async {
      expect(service.isGuideActive, isFalse);

      await service.showPodListGuide();
      expect(service.currentStep, equals(GuideStep.welcome));

      await service.showLogViewGuide();
      expect(service.currentStep, equals(GuideStep.welcome));
    });

    test('should handle step transitions correctly', () async {
      await service.startGuide(demoCluster);

      // Can only go from welcome to pod list
      await service.showLogViewGuide();
      expect(service.currentStep, equals(GuideStep.welcome));

      await service.showPodListGuide();
      expect(service.currentStep, equals(GuideStep.podList));

      // Can only go from pod list to pod logs
      await service.showAdditionalFeaturesGuide();
      expect(service.currentStep, equals(GuideStep.podList));

      await service.showLogViewGuide();
      expect(service.currentStep, equals(GuideStep.podLogs));
    });
  });
}