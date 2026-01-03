import 'package:gherkin/gherkin.dart';

/// Common step definitions shared across multiple Pro feature test files

/// Background step - shared across all Pro feature tests
StepDefinitionGeneric<World> givenAppIsInitialized() {
  return given<World>(
    '应用已初始化',
    (context) async {},
  );
}

StepDefinitionGeneric<World> givenUserIsFree() {
  return given<World>(
    '用户是Free用户',
    (context) async {},
  );
}

StepDefinitionGeneric<World> givenUserIsPro() {
  return given<World>(
    '用户是Pro用户',
    (context) async {},
  );
}
