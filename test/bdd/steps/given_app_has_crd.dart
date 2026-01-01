import 'package:gherkin/gherkin.dart';

StepDefinitionGeneric<World> givenClusterHasCrd() {
  return given1<String, World>(
    '集群中存在名为 {string} 的CRD',
    (crdName, context) async {
      // In a real BDD test, we would set up a mock cluster with CRDs
      // For now, this is a placeholder - the actual test will verify
      // the UI rendering logic
      // Example: This would typically involve:
      // 1. Loading a cluster
      // 2. Creating mock CRD data
      // 3. Setting up the current cluster context
    },
  );
}
