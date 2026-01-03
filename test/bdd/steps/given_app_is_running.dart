import 'package:gherkin/gherkin.dart';
import 'package:k8zdev/common/ops.dart';
import 'package:k8zdev/services/onboarding_guide_service.dart';

late OnboardingGuideService _testGuideService;

/// Export for use in other step definitions
OnboardingGuideService get testGuideService => _testGuideService;

StepDefinitionGeneric<World> givenAppIsRunning() {
  return given<World>(
    '应用已经启动',
    (context) async {
      // Initialize the test guide service
      _testGuideService = OnboardingGuideService();
      talker.debug('[BDD] App is running');
      talker.debug('[BDD] Test guide service initialized');
    },
  );
}
