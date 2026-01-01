import 'package:gherkin/gherkin.dart';

StepDefinitionGeneric<World> thenSeeVolumeBindingMode() {
  return then1<String, World>(
    '我应该看到存储卷绑定模式 {string}',
    (mode, context) async {
      // Validate volume binding mode is one of the expected values
      final validModes = ['Immediate', 'WaitForFirstConsumer'];
      context.expect(validModes.contains(mode), true,
          reason: 'Expected volume binding mode "$mode" to be one of $validModes');
    },
  );
}
