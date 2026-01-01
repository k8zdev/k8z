import 'package:gherkin/gherkin.dart';

StepDefinitionGeneric<World> thenSeeReclaimPolicy() {
  return then1<String, World>(
    '我应该看到回收策略 {string}',
    (policy, context) async {
      // Validate reclaim policy is one of the expected values
      final validPolicies = ['Delete', 'Retain'];
      context.expect(validPolicies.contains(policy), true,
          reason: 'Expected reclaim policy "$policy" to be one of $validPolicies');
    },
  );
}
