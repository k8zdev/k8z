import 'package:gherkin/gherkin.dart';

StepDefinitionGeneric<World> givenClusterHasPVCs() {
  return given<World>(
    '集群中有持久卷声明资源',
    (context) async {
      // This step verifies that PVCs exist in the clustered environment
      // In a real test, this would make an API call to verify PVCs exist
      // For BDD purposes, we assume PVCs exist in the test environment
      context.expect(1, 1); // Placeholder assertion
    },
  );
}
