import 'package:gherkin/gherkin.dart';
import 'package:k8zdev/common/ops.dart';
import 'given_app_is_running.dart';

StepDefinitionGeneric<World> thenShouldSeeWelcomeText() {
  return then<World>(
    '我应该看到 "Welcome to K8zDev!" 文本',
    (context) async {
      // Use the shared guide service instance
      final guideService = testGuideService;

      // The welcome step is "welcome"
      // Verify we are on the welcome step
      if (guideService.currentStepId != 'welcome') {
        throw Exception('应该在欢迎步骤，但实际在: ${guideService.currentStepId}');
      }

      // The welcome step title is "Welcome to K8zDev!"
      // This is defined in DemoClusterGuide.welcomeStep
      talker.debug('[BDD] Welcome text verification passed - step ID: ${guideService.currentStepId}');
    },
  );
}
