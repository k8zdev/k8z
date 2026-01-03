import 'package:gherkin/gherkin.dart';
import 'package:k8zdev/common/ops.dart';
import 'given_app_is_running.dart';

StepDefinitionGeneric<World> thenGuideShouldNotBeActive() {
  return then<World>(
    '新手引导不应该再激活',
    (context) async {
      // Use the shared guide service instance
      final guideService = testGuideService;

      talker.debug('[BDD] Verifying guide is not active...');

      // Verify guide is NOT active
      if (guideService.isGuideActive) {
        throw Exception('新手引导不应该激活，但实际已激活 (当前状态: ${guideService.isGuideActive})');
      }

      talker.debug('[BDD] Guide inactive verification passed');
    },
  );
}
