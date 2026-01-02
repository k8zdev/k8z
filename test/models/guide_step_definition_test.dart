import 'package:flutter_test/flutter_test.dart';
import 'package:k8zdev/models/guide_step_definition.dart';

void main() {
  group('GuideStepDefinition', () {
    test('should create step definition with all fields', () {
      final step = GuideStepDefinition(
        id: 'welcome',
        routeName: 'cluster_home',
        routeParams: {'cluster': 'demo-cluster'},
        targetKey: 'guide-target-welcome',
        title: 'Welcome',
        description: 'Welcome to K8zDev',
        buttonNext: 'Next',
        buttonSkip: 'Skip',
      );

      expect(step.id, equals('welcome'));
      expect(step.routeName, equals('cluster_home'));
      expect(step.routeParams, equals({'cluster': 'demo-cluster'}));
      expect(step.targetKey, equals('guide-target-welcome'));
      expect(step.title, equals('Welcome'));
      expect(step.description, equals('Welcome to K8zDev'));
      expect(step.buttonNext, equals('Next'));
      expect(step.buttonSkip, equals('Skip'));
    });

    test('should create step definition with minimal fields', () {
      const step = GuideStepDefinition(
        id: 'step1',
        routeName: 'pods',
        title: 'Step 1',
        description: 'View your pods',
      );

      expect(step.id, equals('step1'));
      expect(step.routeName, equals('pods'));
      expect(step.routeParams, isEmpty);
      expect(step.targetKey, isNull);
      expect(step.title, equals('Step 1'));
      expect(step.description, equals('View your pods'));
      expect(step.buttonNext, isNull);
      expect(step.buttonSkip, isNull);
    });

    test('should support copyWith to create modified copies', () {
      const step = GuideStepDefinition(
        id: 'step1',
        routeName: 'pods',
        title: 'Original Title',
        description: 'Original Description',
      );

      final modified = step.copyWith(
        title: 'Modified Title',
        buttonNext: 'Continue',
      );

      expect(modified.id, equals('step1'));
      expect(modified.routeName, equals('pods'));
      expect(modified.title, equals('Modified Title'));
      expect(modified.description, equals('Original Description'));
      expect(modified.buttonNext, equals('Continue'));
      expect(modified.buttonSkip, isNull);
    });

    test('should be comparable by id', () {
      const step1 = GuideStepDefinition(
        id: 'step1',
        routeName: 'pods',
        title: 'Step 1',
        description: 'Description 1',
      );

      const step2 = GuideStepDefinition(
        id: 'step1',
        routeName: 'cluster_home',
        title: 'Different Title',
        description: 'Different Description',
      );

      const step3 = GuideStepDefinition(
        id: 'step2',
        routeName: 'pods',
        title: 'Step 1',
        description: 'Description 1',
      );

      // Steps with same id should be equal
      expect(step1, equals(step2));

      // Steps with different ids should not be equal
      expect(step1, isNot(equals(step3)));
    });

    test('should implement hashCode correctly', () {
      const step1 = GuideStepDefinition(
        id: 'step1',
        routeName: 'pods',
        title: 'Step 1',
        description: 'Description 1',
      );

      const step2 = GuideStepDefinition(
        id: 'step1',
        routeName: 'cluster_home',
        title: 'Different Title',
        description: 'Different Description',
      );

      // Same id should produce same hash
      expect(step1.hashCode, equals(step2.hashCode));
    });

    test('should have correct toString representation', () {
      const step = GuideStepDefinition(
        id: 'welcome',
        routeName: 'cluster_home',
        title: 'Welcome',
        description: 'Welcome to K8zDev',
      );

      final str = step.toString();
      expect(str, contains('GuideStepDefinition'));
      expect(str, contains('welcome'));
      expect(str, contains('cluster_home'));
    });
  });

  group('DemoClusterGuide', () {
    test('should have at least 4 steps defined', () {
      final steps = DemoClusterGuide.getSteps();
      expect(steps.length, greaterThanOrEqualTo(4));
    });

    test('should have welcome step as first step', () {
      final steps = DemoClusterGuide.getSteps();
      expect(steps.first.id, equals('welcome'));
    });

    test('each step should have valid required fields', () {
      final steps = DemoClusterGuide.getSteps();

      for (final step in steps) {
        expect(step.id.isNotEmpty, isTrue);
        expect(step.routeName.isNotEmpty, isTrue);
        expect(step.title.isNotEmpty, isTrue);
        expect(step.description.isNotEmpty, isTrue);
      }
    });

    test('should contain pod list step', () {
      final steps = DemoClusterGuide.getSteps();
      expect(
        steps.any((s) => s.id == 'podList'),
        isTrue,
        reason: 'DemoClusterGuide should contain pod list step',
      );
    });

    test('should contain pod logs step', () {
      final steps = DemoClusterGuide.getSteps();
      expect(
        steps.any((s) => s.id == 'podLogs'),
        isTrue,
        reason: 'DemoClusterGuide should contain pod logs step',
      );
    });

    test('should have routes that map to valid router names', () {
      final steps = DemoClusterGuide.getSteps();
      final validRoutes = {
        'clusters',
        'cluster_home',
        'workloads',
        'pods',
        'details',
        'resources',
        'settings',
      };

      for (final step in steps) {
        expect(
          validRoutes.contains(step.routeName) ||
              step.routeName.startsWith('/'),
          isTrue,
          reason: 'Route ${step.routeName} should be valid',
        );
      }
    });
  });
}
