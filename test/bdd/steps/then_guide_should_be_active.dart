import 'package:gherkin/gherkin.dart';
import 'package:k8zdev/common/ops.dart';
import 'given_app_is_running.dart';

StepDefinitionGeneric<World> thenGuideShouldBeActive() {
  return then<World>(
    '新手引导应该是激活状态',
    (context) async {
      // Use the shared guide service instance
      final guideService = testGuideService;

      talker.debug('[BDD] Verifying guide state...');
      talker.debug('[BDD] isGuideActive: ${guideService.isGuideActive}');
      talker.debug('[BDD] currentStepId: ${guideService.currentStepId}');
      talker.debug('[BDD] service instance: ${guideService.hashCode}');

      // Simple check - verify guide is active
      if (!guideService.isGuideActive) {
        throw Exception('新手引导应该是激活状态，但实际未激活 (当前状态: ${guideService.isGuideActive})');
      }

      // Verify current step is set
      if (guideService.currentStepId == null || guideService.currentStepId!.isEmpty) {
        throw Exception('当前步骤ID应该已设置');
      }

      talker.debug('[BDD] Guide verification passed');
    },
  );
}
