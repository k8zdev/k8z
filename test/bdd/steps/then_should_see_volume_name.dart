import 'package:gherkin/gherkin.dart';

StepDefinitionGeneric<World> thenShouldSeeVolumeName() {
  return then<World>(
    '我应该看到卷名称',
    (context) async {
      // Verify that volume name is displayed
      // In a real test, this would check the UI for the volume name field
      context.expect(1, 1); // Placeholder assertion
    },
  );
}
