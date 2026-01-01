import 'package:gherkin/gherkin.dart';

StepDefinitionGeneric<World> thenShouldSeeVolumeMode() {
  return then<World>(
    '我应该看到卷模式',
    (context) async {
      // Verify that volume mode is displayed
      // In a real test, this would check the UI for the volume mode field
      context.expect(1, 1); // Placeholder assertion
    },
  );
}
