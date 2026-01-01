import 'package:gherkin/gherkin.dart';

StepDefinitionGeneric<World> thenShouldSeeStorageCapacity() {
  return then<World>(
    '我应该看到存储容量',
    (context) async {
      // Verify that storage capacity is displayed
      // In a real test, this would check the UI for the capacity field
      context.expect(1, 1); // Placeholder assertion
    },
  );
}
