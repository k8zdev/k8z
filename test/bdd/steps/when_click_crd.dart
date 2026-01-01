import 'package:gherkin/gherkin.dart';

StepDefinitionGeneric<World> whenClickCrd() {
  return when<World>(
    '我点击该CRD查看详情',
    (context) async {
      // In a real BDD test, this would:
      // 1. Navigate to the CRD details page
      // 2. Trigger the buildDetailSection method with 'crds' case
      // For now, this is a placeholder
    },
  );
}
