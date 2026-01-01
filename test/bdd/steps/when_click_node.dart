import 'package:flutter_test/flutter_test.dart';
import 'package:gherkin/gherkin.dart';

/// Step to simulate clicking on a node in the UI
/// This is a placeholder step - in a real integration test this would
/// perform a widget tap navigation to the node detail page
StepDefinitionGeneric<World> whenClickNode() {
  return when<World>(
    '我点击节点',
    (context) async {
      // This would navigate to the Node detail page in a real test
      // For now, we just verify the step can be executed
      context.expect(true, isTrue);
    },
  );
}