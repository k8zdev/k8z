import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:k8zdev/models/guide_step_definition.dart';
import 'package:k8zdev/models/guide_keys.dart';

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
    test('should have exactly 8 steps defined', () {
      final steps = DemoClusterGuide.getSteps();
      expect(steps.length, equals(8));
    });

    test('should have welcome step as first step', () {
      final steps = DemoClusterGuide.getSteps();
      expect(steps.first.id, equals(DemoClusterGuide.welcomeStepId));
    });

    test('should have completed step as last step', () {
      final steps = DemoClusterGuide.getSteps();
      expect(steps.last.id, equals(DemoClusterGuide.completedStepId));
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

    test('steps should be in correct order', () {
      final steps = DemoClusterGuide.getSteps();
      const expectedOrder = [
        DemoClusterGuide.welcomeStepId,
        DemoClusterGuide.workloadsOverviewStepId,
        DemoClusterGuide.podListWithSwipeStepId,
        DemoClusterGuide.podDetailStepId,
        DemoClusterGuide.resourcesMenuStepId,
        DemoClusterGuide.nodesListWithSwipeStepId,
        DemoClusterGuide.nodeDetailStepId,
        DemoClusterGuide.completedStepId,
      ];

      for (int i = 0; i < steps.length; i++) {
        expect(
          steps[i].id,
          equals(expectedOrder[i]),
          reason: 'Step $i should be ${expectedOrder[i]}',
        );
      }
    });

    test('should contain all required target keys', () {
      final steps = DemoClusterGuide.getSteps();
      final requiredTargetKeys = {
        DemoClusterGuide.welcomeTargetKey,
        DemoClusterGuide.workloadsTargetKey,
        DemoClusterGuide.podListTargetKey,
        DemoClusterGuide.podDetailTargetKey,
        DemoClusterGuide.resourcesTargetKey,
        DemoClusterGuide.nodesTargetKey,
        DemoClusterGuide.nodeDetailTargetKey,
        DemoClusterGuide.completedTargetKey,
      };

      final actualTargetKeys = steps
          .map((s) => s.targetKey)
          .whereType<String>()
          .toSet();

      expect(
        actualTargetKeys,
        equals(requiredTargetKeys),
        reason: 'All required target keys should be present',
      );
    });

    test('should have routes that map to valid router names', () {
      final steps = DemoClusterGuide.getSteps();
      final validRoutes = {
        'clusters',
        'cluster_home',
        'workloads',
        'pods',
        'nodes',
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

    test('step 7 (nodeDetail) should use details route with correct params', () {
      final step = DemoClusterGuide.getStepById(
        DemoClusterGuide.nodeDetailStepId,
      );
      expect(step, isNotNull);
      expect(step!.routeName, equals('details'));
      expect(step.routeParams['path'], equals('/api/v1'));
      expect(step.routeParams['namespace'], equals('_'));
      expect(step.routeParams['resource'], equals('nodes'));
      expect(step.routeParams['name'], isNull,
          reason: 'node name should be null for dynamic filling');
    });

    test('step 4 (podDetail) should use details route with correct params', () {
      final step = DemoClusterGuide.getStepById(
        DemoClusterGuide.podDetailStepId,
      );
      expect(step, isNotNull);
      expect(step!.routeName, equals('details'));
      expect(step.routeParams['path'], equals('workloads'));
      expect(step.routeParams['namespace'], isNull);
      expect(step.routeParams['resource'], equals('pods'));
      expect(step.routeParams['name'], equals('web-demo'));
    });

    test('should have i18n keys for all steps', () {
      final steps = DemoClusterGuide.getSteps();

      for (int i = 0; i < steps.length; i++) {
        final step = steps[i];
        expect(
          step.l10nTitle,
          isNotNull,
          reason: 'Step ${i + 1} (${step.id}) should have l10nTitle',
        );
        expect(
          step.l10nDescription,
          isNotNull,
          reason: 'Step ${i + 1} (${step.id}) should have l10nDescription',
        );
      }
    });

    test('getNextStepId should return correct next step ID for all steps', () {
      final steps = DemoClusterGuide.getSteps();

      for (int i = 0; i < steps.length - 1; i++) {
        const currentId = DemoClusterGuide.welcomeStepId;
        final nextId =
            DemoClusterGuide.getNextStepId(steps[i].id);
        expect(
          nextId,
          equals(steps[i + 1].id),
          reason: 'Next step for ${steps[i].id} should be ${steps[i + 1].id}',
        );
      }

      // Last step should return null
      final lastNext = DemoClusterGuide.getNextStepId(
        DemoClusterGuide.completedStepId,
      );
      expect(lastNext, isNull);
    });

    test('getPreviousStepId should return correct previous step ID for all steps',
        () {
      final steps = DemoClusterGuide.getSteps();

      for (int i = 1; i < steps.length; i++) {
        final prevId =
            DemoClusterGuide.getPreviousStepId(steps[i].id);
        expect(
          prevId,
          equals(steps[i - 1].id),
          reason:
              'Previous step for ${steps[i].id} should be ${steps[i - 1].id}',
        );
      }

      // First step should return null
      final firstPrev = DemoClusterGuide.getPreviousStepId(
        DemoClusterGuide.welcomeStepId,
      );
      expect(firstPrev, isNull);
    });

    test('isFirstStep should work correctly', () {
      expect(
        DemoClusterGuide.isFirstStep(DemoClusterGuide.welcomeStepId),
        isTrue,
      );
      expect(
        DemoClusterGuide.isFirstStep(DemoClusterGuide.workloadsOverviewStepId),
        isFalse,
      );
      expect(
        DemoClusterGuide.isFirstStep(DemoClusterGuide.completedStepId),
        isFalse,
      );
    });

    test('isLastStep should work correctly', () {
      expect(
        DemoClusterGuide.isLastStep(DemoClusterGuide.completedStepId),
        isTrue,
      );
      expect(
        DemoClusterGuide.isLastStep(DemoClusterGuide.nodeDetailStepId),
        isFalse,
      );
      expect(
        DemoClusterGuide.isLastStep(DemoClusterGuide.welcomeStepId),
        isFalse,
      );
    });
  });

  group('GuideKeys', () {
    test('should have welcomeTargetKey defined', () {
      expect(GuideKeys.welcomeTargetKey, isNotNull);
      expect(GuideKeys.welcomeTargetKey, isA<GlobalKey>());
    });

    test('should have podListTargetKey defined', () {
      expect(GuideKeys.podListTargetKey, isNotNull);
      expect(GuideKeys.podListTargetKey, isA<GlobalKey>());
    });

    test('should have nodesTargetKey defined', () {
      expect(GuideKeys.nodesTargetKey, isNotNull);
      expect(GuideKeys.nodesTargetKey, isA<GlobalKey>());
    });

    test('should have completedTargetKey defined', () {
      expect(GuideKeys.completedTargetKey, isNotNull);
      expect(GuideKeys.completedTargetKey, isA<GlobalKey>());
    });

    test('should have workloadsTargetKey defined', () {
      expect(GuideKeys.workloadsTargetKey, isNotNull);
      expect(GuideKeys.workloadsTargetKey, isA<GlobalKey>());
    });

    test('should have podDetailTargetKey defined', () {
      expect(GuideKeys.podDetailTargetKey, isNotNull);
      expect(GuideKeys.podDetailTargetKey, isA<GlobalKey>());
    });

    test('should have resourcesTargetKey defined', () {
      expect(GuideKeys.resourcesTargetKey, isNotNull);
      expect(GuideKeys.resourcesTargetKey, isA<GlobalKey>());
    });

    test('should have nodeDetailTargetKey defined', () {
      expect(GuideKeys.nodeDetailTargetKey, isNotNull);
      expect(GuideKeys.nodeDetailTargetKey, isA<GlobalKey>());
    });
  });

  group('GuideKeyRegistry', () {
    test('should return correct GlobalKey for welcome target', () {
      final key = GuideKeyRegistry.getKey(DemoClusterGuide.welcomeTargetKey);
      expect(key, equals(GuideKeys.welcomeTargetKey));
    });

    test('should return correct GlobalKey for pod list target', () {
      final key = GuideKeyRegistry.getKey(DemoClusterGuide.podListTargetKey);
      expect(key, equals(GuideKeys.podListTargetKey));
    });

    test('should return correct GlobalKey for nodes target', () {
      final key = GuideKeyRegistry.getKey(DemoClusterGuide.nodesTargetKey);
      expect(key, equals(GuideKeys.nodesTargetKey));
    });

    test('should return correct GlobalKey for completed target', () {
      final key = GuideKeyRegistry.getKey(DemoClusterGuide.completedTargetKey);
      expect(key, equals(GuideKeys.completedTargetKey));
    });

    test('should return correct GlobalKey for workloads target', () {
      final key = GuideKeyRegistry.getKey(DemoClusterGuide.workloadsTargetKey);
      expect(key, equals(GuideKeys.workloadsTargetKey));
    });

    test('should return correct GlobalKey for pod detail target', () {
      final key = GuideKeyRegistry.getKey(DemoClusterGuide.podDetailTargetKey);
      expect(key, equals(GuideKeys.podDetailTargetKey));
    });

    test('should return correct GlobalKey for resources target', () {
      final key = GuideKeyRegistry.getKey(DemoClusterGuide.resourcesTargetKey);
      expect(key, equals(GuideKeys.resourcesTargetKey));
    });

    test('should return correct GlobalKey for node detail target', () {
      final key = GuideKeyRegistry.getKey(DemoClusterGuide.nodeDetailTargetKey);
      expect(key, equals(GuideKeys.nodeDetailTargetKey));
    });

    test('should return null for unknown target key', () {
      final key = GuideKeyRegistry.getKey('unknown-target-key');
      expect(key, isNull);
    });

    test('getAllKeys should return all 8 keys', () {
      final allKeys = GuideKeyRegistry.getAllKeys();
      expect(allKeys.length, equals(8));
    });

    test('getAllKeys should contain all target keys', () {
      final allKeys = GuideKeyRegistry.getAllKeys();
      expect(allKeys.containsKey(DemoClusterGuide.welcomeTargetKey), isTrue);
      expect(allKeys.containsKey(DemoClusterGuide.podListTargetKey), isTrue);
      expect(allKeys.containsKey(DemoClusterGuide.nodesTargetKey), isTrue);
      expect(allKeys.containsKey(DemoClusterGuide.completedTargetKey), isTrue);
      expect(allKeys.containsKey(DemoClusterGuide.workloadsTargetKey), isTrue);
      expect(allKeys.containsKey(DemoClusterGuide.podDetailTargetKey), isTrue);
      expect(allKeys.containsKey(DemoClusterGuide.resourcesTargetKey), isTrue);
      expect(allKeys.containsKey(DemoClusterGuide.nodeDetailTargetKey), isTrue);
    });
  });
}
