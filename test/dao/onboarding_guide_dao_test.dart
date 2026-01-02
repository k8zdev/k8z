import 'package:flutter_test/flutter_test.dart';
import 'package:k8zdev/dao/onboarding_guide.dart';
import 'package:k8zdev/models/guide_step_definition.dart';

void main() {
  group('OnboardingGuideState', () {
    test('should create state with required fields', () {
      final state = OnboardingGuideState(
        id: 1,
        guideName: 'demo_cluster',
        completedAt: 1234567890,
        lastStep: 'step3',
        clusterId: 'cluster-1',
      );

      expect(state.id, equals(1));
      expect(state.guideName, equals('demo_cluster'));
      expect(state.completedAt, equals(1234567890));
      expect(state.lastStep, equals('step3'));
      expect(state.clusterId, equals('cluster-1'));
    });

    test('should create state with minimal fields', () {
      final state = OnboardingGuideState(
        guideName: 'demo_cluster',
      );

      expect(state.id, isNull);
      expect(state.guideName, equals('demo_cluster'));
      expect(state.completedAt, isNull);
      expect(state.lastStep, isNull);
      expect(state.clusterId, isNull);
    });

    test('should convert to and from JSON', () {
      final state = OnboardingGuideState(
        id: 1,
        guideName: 'demo_cluster',
        completedAt: 1234567890,
        lastStep: 'step3',
        clusterId: 'cluster-1',
      );

      final json = state.toJson();
      final restored = OnboardingGuideState.fromJson(json);

      expect(restored.id, equals(state.id));
      expect(restored.guideName, equals(state.guideName));
      expect(restored.completedAt, equals(state.completedAt));
      expect(restored.lastStep, equals(state.lastStep));
      expect(restored.clusterId, equals(state.clusterId));
    });

    test('should identify completed state correctly', () {
      final completed = OnboardingGuideState.completed(
        guideName: 'guide1',
        clusterId: 'cluster-1',
      );
      expect(completed.isCompleted, isTrue);
      expect(completed.completedAt, isNotNull);
      expect(completed.clusterId, equals('cluster-1'));
    });

    test('should identify incomplete state correctly', () {
      final incomplete = OnboardingGuideState.incomplete(
        guideName: 'guide2',
        clusterId: 'cluster-2',
      );
      expect(incomplete.isCompleted, isFalse);
      expect(incomplete.completedAt, isNull);
      expect(incomplete.clusterId, equals('cluster-2'));
    });

    test('should have valid completedTime for completed state', () {
      final beforeTime = DateTime.now();
      final state = OnboardingGuideState.completed(
        guideName: 'guide1',
      );
      final afterTime = DateTime.now();

      expect(state.completedTime, isNotNull);
      expect(
        state.completedTime!.isAfter(beforeTime.subtract(const Duration(seconds: 1))),
        isTrue,
      );
      expect(
        state.completedTime!.isBefore(afterTime.add(const Duration(seconds: 1))),
        isTrue,
      );
    });

    test('should have null completedTime for incomplete state', () {
      final state = OnboardingGuideState.incomplete(
        guideName: 'guide1',
      );

      expect(state.completedTime, isNull);
    });

    test('should handle JSON with null values', () {
      final json = <String, dynamic>{
        'guide_name': 'demo_cluster',
      };

      final state = OnboardingGuideState.fromJson(json);

      expect(state.guideName, equals('demo_cluster'));
      expect(state.id, isNull);
      expect(state.completedAt, isNull);
      expect(state.lastStep, isNull);
      expect(state.clusterId, isNull);
    });

    test('should handle JSON with all values', () {
      final json = <String, dynamic>{
        'id': 42,
        'guide_name': 'demo_cluster',
        'completed_at': 1234567890,
        'last_step': 'welcome',
        'cluster_id': 'cluster-1',
      };

      final state = OnboardingGuideState.fromJson(json);

      expect(state.id, equals(42));
      expect(state.guideName, equals('demo_cluster'));
      expect(state.completedAt, equals(1234567890));
      expect(state.lastStep, equals('welcome'));
      expect(state.clusterId, equals('cluster-1'));
    });

    test('should handle JSON with empty routeParams in toJson', () {
      // OnboardingGuideState toJson doesn't have routeParams, but we should
      // ensure the model doesn't have unexpected fields in JSON
      final state = OnboardingGuideState(
        guideName: 'test_guide',
      );

      final json = state.toJson();

      expect(json['guide_name'], equals('test_guide'));
      expect(json.keys, contains('guide_name'));
    });
  });

  group('OnboardingGuideState factories', () {
    test('completed factory should create completed state', () {
      final state = OnboardingGuideState.completed(
        guideName: 'demo_cluster',
        clusterId: 'cluster-123',
        lastStep: 'final',
      );

      expect(state.isCompleted, isTrue);
      expect(state.completedAt, isNotNull);
      expect(state.guideName, equals('demo_cluster'));
      expect(state.clusterId, equals('cluster-123'));
      expect(state.lastStep, equals('final'));
    });

    test('incomplete factory should create incomplete state', () {
      final state = OnboardingGuideState.incomplete(
        guideName: 'demo_cluster',
        clusterId: 'cluster-456',
        lastStep: 'step2',
      );

      expect(state.isCompleted, isFalse);
      expect(state.completedAt, isNull);
      expect(state.guideName, equals('demo_cluster'));
      expect(state.clusterId, equals('cluster-456'));
      expect(state.lastStep, equals('step2'));
    });
  });

  group('DemoClusterGuide integration', () {
    test('should have a unique guide name', () {
      expect(DemoClusterGuide.guideName, equals('demo_cluster_onboarding'));
    });

    test('should have unique step IDs', () {
      final steps = DemoClusterGuide.getSteps();
      final ids = steps.map((s) => s.id).toSet();
      expect(ids.length, equals(steps.length),
          reason: 'All step IDs should be unique');
    });

    test('should support navigation helpers', () {
      final steps = DemoClusterGuide.getSteps();

      if (steps.isNotEmpty) {
        // First step has no previous
        expect(DemoClusterGuide.getPreviousStepId(steps.first.id), isNull);

        // Last step has no next
        expect(DemoClusterGuide.getNextStepId(steps.last.id), isNull);

        // Middle steps should have both
        if (steps.length > 2) {
          final middleStepId = steps[1].id;
          final prevId = DemoClusterGuide.getPreviousStepId(middleStepId);
          final nextId = DemoClusterGuide.getNextStepId(middleStepId);

          expect(prevId, isNotNull);
          expect(nextId, isNotNull);
          expect(prevId, equals(steps[0].id));
          expect(nextId, equals(steps[2].id));
        }
      }
    });

    test('should identify first and last steps correctly', () {
      final steps = DemoClusterGuide.getSteps();

      if (steps.isNotEmpty) {
        expect(DemoClusterGuide.isFirstStep(steps.first.id), isTrue);
        expect(DemoClusterGuide.isLastStep(steps.last.id), isTrue);

        if (steps.length > 1) {
          expect(DemoClusterGuide.isFirstStep(steps.last.id), isFalse);
          expect(DemoClusterGuide.isLastStep(steps.first.id), isFalse);
        }
      }
    });

    test('should get correct step index', () {
      final steps = DemoClusterGuide.getSteps();

      for (int i = 0; i < steps.length; i++) {
        final index = DemoClusterGuide.getStepIndex(steps[i].id);
        expect(index, equals(i));
      }

      expect(DemoClusterGuide.getStepIndex('non_existent'), equals(-1));
    });
  });

  group('GuideStepDefinition and persistence', () {
    test('should be compatible with onboarding guide state', () {
      final step = DemoClusterGuide.getSteps().first;
      final state = OnboardingGuideState.completed(
        guideName: DemoClusterGuide.guideName,
        lastStep: step.id,
      );

      expect(state.lastStep, equals(step.id));
    });
  });
}