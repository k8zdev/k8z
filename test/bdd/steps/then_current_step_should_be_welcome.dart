import 'package:gherkin/gherkin.dart';
import 'package:k8zdev/common/ops.dart';
import 'package:k8zdev/models/guide_step_definition.dart';
import 'given_app_is_running.dart';

StepDefinitionGeneric<World> thenCurrentStepShouldBeWelcome() {
  return then<World>(
    '当前步骤应该是欢迎步骤',
    (context) async {
      // Use the shared guide service instance
      final guideService = testGuideService;

      // Verify we are on the welcome step
      if (guideService.currentStepId != DemoClusterGuide.welcomeStepId) {
        throw Exception(
            '当前步骤应该是欢迎步骤 (${DemoClusterGuide.welcomeStepId})，但实际是: ${guideService.currentStepId}');
      }

      // Also verify the welcome step content
      final welcomeStep = DemoClusterGuide.getStepById(DemoClusterGuide.welcomeStepId);
      if (welcomeStep == null) {
        throw Exception('找不到欢迎步骤定义');
      }

      if (welcomeStep.title != 'Welcome to K8zDev!') {
        throw Exception('欢迎步骤标题应该是 "Welcome to K8zDev!"，但实际是: ${welcomeStep.title}');
      }

      talker.debug('[BDD] Current step is welcome: ${guideService.currentStepId}');
      talker.debug('[BDD] Welcome step title: ${welcomeStep.title}');
    },
  );
}
