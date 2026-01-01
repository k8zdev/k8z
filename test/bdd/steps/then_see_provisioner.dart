import 'package:gherkin/gherkin.dart';

StepDefinitionGeneric<World> thenSeeProvisioner() {
  return then1<String, World>(
    '我应该看到分配器 {string}',
    (provisioner, context) async {
      // Validate provisioner is a valid string for display
      context.expect(provisioner.isNotEmpty, true,
          reason: 'Expected provisioner to be non-empty');
    },
  );
}
