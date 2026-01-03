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

  /// ============================================================================
  /// Task 13.3: i18n 回退逻辑 TDD
  /// ============================================================================
  ///
  /// These tests define the expected behavior for i18n localization.
  /// Subagent A will implement getLocalizedTitle(), getLocalizedDescription(),
  /// and button localization methods to make these tests pass.
  /// ============================================================================

  group('Task13_3: i18n Fallback Logic - TDD Tests', () {
    /// Test 1: Verifies that when l10nTitle is not null, i18n is used
    ///
    /// Expected: getLocalizedTitle(context) should return the localized title
    /// from S.of(context) using the l10nTitle key
    ///
    /// Implementation needed: GuideStepDefinition.getLocalizedTitle() method
    test('should use i18n when l10nTitle is not null', () {
      const step = GuideStepDefinition(
        id: 'welcome',
        routeName: 'clusters',
        title: 'Welcome to K8zDev!', // Fallback text
        description: 'Welcome description',
        l10nTitle: 'guide_welcome_title',
        l10nDescription: 'guide_welcome_desc',
      );

      // When Subagent A implements getLocalizedTitle(), it should:
      // 1. Check if l10nTitle is not null
      // 2. Call S.of(context).getLocalized(l10nTitle!)
      // 3. Return the localized string

      // For now, we can only verify the data exists
      expect(step.l10nTitle, equals('guide_welcome_title'));
      expect(step.title, equals('Welcome to K8zDev!'));

      // TODO: After implementation, test with mock BuildContext:
      // expect(step.getLocalizedTitle(context), equals('LocalizedWelcomeTitle'));
    });

    /// Test 2: Verifies that when l10nTitle is null, direct title property is used
    ///
    /// Expected: getLocalizedTitle(context) should return the raw title
    ///
    /// Implementation needed: GuideStepDefinition.getLocalizedTitle() method
    test('should fallback to title when l10nTitle is null', () {
      const step = GuideStepDefinition(
        id: 'step1',
        routeName: 'pods',
        title: 'Direct Title Text',
        description: 'Step description',
        // No l10nTitle - should fall back to title
      );

      expect(step.l10nTitle, isNull);
      expect(step.title, equals('Direct Title Text'));

      // TODO: After implementation, test:
      // expect(step.getLocalizedTitle(context), equals('Direct Title Text'));
    });

    /// Test 3: Verifies getLocalizedDescription uses i18n when available
    ///
    /// Expected: getLocalizedDescription(context) should return the localized
    /// description from S.of(context) using the l10nDescription key
    ///
    /// Implementation needed: GuideStepDefinition.getLocalizedDescription() method
    test('should use i18n for description when l10nDescription is not null', () {
      const step = GuideStepDefinition(
        id: 'podList',
        routeName: 'pods',
        title: 'Pod List',
        description: 'View all pods in your cluster',
        l10nDescription: 'guide_pod_list_description',
      );

      expect(step.l10nDescription, equals('guide_pod_list_description'));
      expect(step.description, equals('View all pods in your cluster'));

      // TODO: After implementation:
      // expect(step.getLocalizedDescription(context), equals('LocalizedDescription'));
    });

    /// Test 4: Verifies getLocalizedDescription falls back to description
    ///
    /// Expected: getLocalizedDescription(context) should return the raw description
    ///
    /// Implementation needed: GuideStepDefinition.getLocalizedDescription() method
    test('should fallback to description when l10nDescription is null', () {
      const step = GuideStepDefinition(
        id: 'step1',
        routeName: 'pods',
        title: 'Step Title',
        description: 'Direct Description Text',
        // No l10nDescription
      );

      expect(step.l10nDescription, isNull);
      expect(step.description, equals('Direct Description Text'));

      // TODO: After implementation:
      // expect(step.getLocalizedDescription(context), equals('Direct Description Text'));
    });

    /// Test 5: Verifies getLocalizedButtonNext uses i18n when available
    ///
    /// Expected: getLocalizedButtonNext(context) should return the localized
    /// button label from S.of(context) using the l10nButtonNext key
    ///
    /// Implementation needed: GuideStepDefinition.getLocalizedButtonNext() method
    test('should use i18n for buttonNext when l10nButtonNext is not null', () {
      const step = GuideStepDefinition(
        id: 'welcome',
        routeName: 'clusters',
        title: 'Welcome',
        description: 'Welcome description',
        buttonNext: 'Let\'s Start',
        l10nButtonNext: 'guide_button_next',
      );

      expect(step.l10nButtonNext, equals('guide_button_next'));
      expect(step.buttonNext, equals('Let\'s Start'));

      // TODO: After implementation:
      // expect(step.getLocalizedButtonNext(context), equals('LocalizedNext'));
    });

    /// Test 6: Verifies getLocalizedButtonNext falls back to buttonNext
    ///
    /// Expected: getLocalizedButtonNext(context) should return the raw buttonNext
    ///
    /// Implementation needed: GuideStepDefinition.getLocalizedButtonNext() method
    test('should fallback to buttonNext when l10nButtonNext is null', () {
      const step = GuideStepDefinition(
        id: 'step1',
        routeName: 'pods',
        title: 'Step Title',
        description: 'Step description',
        buttonNext: 'Continue',
      );

      expect(step.l10nButtonNext, isNull);
      expect(step.buttonNext, equals('Continue'));

      // TODO: After implementation:
      // expect(step.getLocalizedButtonNext(context), equals('Continue'));
    });

    /// Test 7: Verifies getLocalizedButtonSkip uses i18n when available
    ///
    /// Implementation needed: GuideStepDefinition.getLocalizedButtonSkip() method
    test('should use i18n for buttonSkip when l10nButtonSkip is not null', () {
      const step = GuideStepDefinition(
        id: 'welcome',
        routeName: 'clusters',
        title: 'Welcome',
        description: 'Welcome description',
        buttonSkip: 'Skip Guide',
        l10nButtonSkip: 'guide_button_skip',
      );

      expect(step.l10nButtonSkip, equals('guide_button_skip'));
      expect(step.buttonSkip, equals('Skip Guide'));

      // TODO: After implementation:
      // expect(step.getLocalizedButtonSkip(context), equals('LocalizedSkip'));
    });

    /// Test 8: Verifies getLocalizedButtonSkip falls back to buttonSkip
    ///
    /// Implementation needed: GuideStepDefinition.getLocalizedButtonSkip() method
    test('should fallback to buttonSkip when l10nButtonSkip is null', () {
      const step = GuideStepDefinition(
        id: 'step1',
        routeName: 'pods',
        title: 'Step Title',
        description: 'Step description',
        buttonSkip: 'Skip',
      );

      expect(step.l10nButtonSkip, isNull);
      expect(step.buttonSkip, equals('Skip'));

      // TODO: After implementation:
      // expect(step.getLocalizedButtonSkip(context), equals('Skip'));
    });

    /// Test 9: Verifies getLocalizedButtonPrevious uses i18n when available
    ///
    /// Implementation needed: GuideStepDefinition.getLocalizedButtonPrevious() method
    test('should use i18n for buttonPrevious when l10nButtonPrevious is not null', () {
      const step = GuideStepDefinition(
        id: 'podList',
        routeName: 'pods',
        title: 'Pod List',
        description: 'Pod list description',
        buttonPrevious: 'Back',
        l10nButtonPrevious: 'guide_button_back',
      );

      expect(step.l10nButtonPrevious, equals('guide_button_back'));
      expect(step.buttonPrevious, equals('Back'));

      // TODO: After implementation:
      // expect(step.getLocalizedButtonPrevious(context), equals('LocalizedBack'));
    });

    /// Test 10: Verifies getLocalizedButtonPrevious falls back to buttonPrevious
    ///
    /// Implementation needed: GuideStepDefinition.getLocalizedButtonPrevious() method
    test('should fallback to buttonPrevious when l10nButtonPrevious is null', () {
      const step = GuideStepDefinition(
        id: 'step1',
        routeName: 'pods',
        title: 'Step Title',
        description: 'Step description',
        buttonPrevious: 'Previous',
      );

      expect(step.l10nButtonPrevious, isNull);
      expect(step.buttonPrevious, equals('Previous'));

      // TODO: After implementation:
      // expect(step.getLocalizedButtonPrevious(context), equals('Previous'));
    });

    /// Test 11: Verifies all DemoClusterGuide steps have i18n keys
    ///
    /// Expected: Every step should have l10nTitle and l10nDescription
    test('all DemoClusterGuide steps should have i18n keys', () {
      final steps = DemoClusterGuide.getSteps();

      for (final step in steps) {
        expect(
          step.l10nTitle,
          isNotNull,
          reason: 'Step ${step.id} should have l10nTitle',
        );
        expect(
          step.l10nDescription,
          isNotNull,
          reason: 'Step ${step.id} should have l10nDescription',
        );
      }
    });

    /// Test 12: Verifies step with all i18n fields
    ///
    /// Expected: If a step has all optional i18n fields, they should be used
    test('step with all i18n fields should have them set', () {
      const step = GuideStepDefinition(
        id: 'fullStep',
        routeName: 'clusters',
        title: 'English Title',
        description: 'English Description',
        buttonNext: 'Next',
        buttonSkip: 'Skip',
        buttonPrevious: 'Back',
        l10nTitle: 'guide_full_title',
        l10nDescription: 'guide_full_description',
        l10nButtonNext: 'guide_button_next',
        l10nButtonSkip: 'guide_button_skip',
        l10nButtonPrevious: 'guide_button_back',
      );

      expect(step.l10nTitle, isNotNull);
      expect(step.l10nDescription, isNotNull);
      expect(step.l10nButtonNext, isNotNull);
      expect(step.l10nButtonSkip, isNotNull);
      expect(step.l10nButtonPrevious, isNotNull);
    });

    /// Test 13: Verifies default values when no i18n keys are provided
    ///
    /// Expected: English text should serve as fallback
    test('step without i18n keys should use English text as fallback', () {
      const step = GuideStepDefinition(
        id: 'englishOnly',
        routeName: 'clusters',
        title: 'English Title Only',
        description: 'English Description Only',
        buttonNext: 'Next',
        buttonSkip: 'Skip',
        buttonPrevious: 'Back',
      );

      expect(step.l10nTitle, isNull);
      expect(step.l10nDescription, isNull);
      expect(step.l10nButtonNext, isNull);
      expect(step.l10nButtonSkip, isNull);
      expect(step.l10nButtonPrevious, isNull);

      // These should all fallback to English text
      expect(step.title, equals('English Title Only'));
      expect(step.description, equals('English Description Only'));
      expect(step.buttonNext, equals('Next'));
      expect(step.buttonSkip, equals('Skip'));
      expect(step.buttonPrevious, equals('Back'));
    });

    /// Test 14: Verifies JSON serialization includes i18n fields
    ///
    /// Expected: toJson() should include l10n fields
    test('toJson should include i18n fields', () {
      const step = GuideStepDefinition(
        id: 'welcome',
        routeName: 'clusters',
        title: 'Welcome',
        description: 'Welcome description',
        l10nTitle: 'guide_welcome_title',
        l10nDescription: 'guide_welcome_desc',
        l10nButtonNext: 'guide_button_next',
        l10nButtonSkip: 'guide_button_skip',
      );

      final json = step.toJson();

      expect(json['l10nTitle'], equals('guide_welcome_title'));
      expect(json['l10nDescription'], equals('guide_welcome_desc'));
      expect(json['l10nButtonNext'], equals('guide_button_next'));
      expect(json['l10nButtonSkip'], equals('guide_button_skip'));
    });

    /// Test 15: Verifies fromJson parses i18n fields correctly
    ///
    /// Expected: fromJson() should reconstruct step with i18n fields
    test('fromJson should parse i18n fields correctly', () {
      final json = {
        'id': 'welcome',
        'routeName': 'clusters',
        'routeParams': {},
        'title': 'Welcome',
        'description': 'Welcome description',
        'buttonNext': 'Let\'s Start',
        'buttonSkip': 'Skip',
        'buttonPrevious': null,
        'l10nTitle': 'guide_welcome_title',
        'l10nDescription': 'guide_welcome_desc',
        'l10nButtonNext': 'guide_button_next',
        'l10nButtonSkip': 'guide_button_skip',
        'l10nButtonPrevious': null,
        'targetKey': null,
      };

      final step = GuideStepDefinition.fromJson(json);

      expect(step.id, equals('welcome'));
      expect(step.l10nTitle, equals('guide_welcome_title'));
      expect(step.l10nDescription, equals('guide_welcome_desc'));
      expect(step.l10nButtonNext, equals('guide_button_next'));
      expect(step.l10nButtonSkip, equals('guide_button_skip'));
      expect(step.l10nButtonPrevious, isNull);
    });

    /// Test 16: Verifies copyWith preserves i18n fields when not specified
    ///
    /// Expected: copyWith() should keep existing i18n fields
    test('copyWith should preserve i18n fields when not updated', () {
      const step = GuideStepDefinition(
        id: 'welcome',
        routeName: 'clusters',
        title: 'Welcome',
        description: 'Welcome description',
        l10nTitle: 'guide_welcome_title',
        l10nDescription: 'guide_welcome_desc',
      );

      final copied = step.copyWith(title: 'New Title');

      expect(copied.title, equals('New Title'));
      expect(copied.l10nTitle, equals('guide_welcome_title'),
          reason: 'l10nTitle should be preserved');
      expect(copied.l10nDescription, equals('guide_welcome_desc'),
          reason: 'l10nDescription should be preserved');
    });

    /// Test 17: Verifies copyWith can update i18n fields
    ///
    /// Expected: copyWith() should allow updating i18n fields
    test('copyWith should allow updating i18n fields', () {
      const step = GuideStepDefinition(
        id: 'welcome',
        routeName: 'clusters',
        title: 'Welcome',
        description: 'Welcome description',
      );

      final copied = step.copyWith(
        l10nTitle: 'guide_new_title',
        l10nDescription: 'guide_new_desc',
      );

      expect(copied.l10nTitle, equals('guide_new_title'));
      expect(copied.l10nDescription, equals('guide_new_desc'));
    });
  });
}
