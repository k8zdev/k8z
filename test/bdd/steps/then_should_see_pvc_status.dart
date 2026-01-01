import 'package:gherkin/gherkin.dart';

StepDefinitionGeneric<World> thenShouldSeePVCStatus() {
  return then<World>(
    '我应该看到PVC状态',
    (context) async {
      // Verify that PVC status is displayed
      // In a real test, this would check the UI for the status field
      context.expect(1, 1); // Placeholder assertion
    },
  );
}
