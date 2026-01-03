import 'package:gherkin/gherkin.dart';
import 'package:k8zdev/services/pro_features.dart';

/// Step definitions for cluster count limitation scenarios
StepDefinitionGeneric<World> givenUserIsNotGrandfathered() {
  return given<World>(
    '用户未被祖父条款保护',
    (context) async {},
  );
}

StepDefinitionGeneric<World> givenUserIsGrandfathered() {
  return given<World>(
    '用户被祖父条款保护',
    (context) async {},
  );
}

StepDefinitionGeneric<World> whenCheckIfCanAddCluster() {
  return when<World>(
    '检查是否可以添加集群',
    (context) async {
      // Test will check with different parameters in the then steps
    },
  );
}

StepDefinitionGeneric<World> thenShouldReturnFalseWithLimitMessage() {
  return then<World>(
    '返回false和集群限制提示信息',
    (context) async {
      // Free user without grandfathering at limit (2 clusters) should not allow adding
      final result = ProFeatures.canAddCluster(2, false, false);
      context.expect(result.$1, false);
      context.expect(result.$2 != null, true);
    },
  );
}

StepDefinitionGeneric<World> thenShouldReturnTrueWithNullMessage() {
  return then<World>(
    '返回true和null提示信息',
    (context) async {
      // Free user with grandfathering should allow adding
      final result = ProFeatures.canAddCluster(2, false, true);
      context.expect(result.$1, true);
      context.expect(result.$2 == null, true);

      // Pro user should always allow adding
      final proResult = ProFeatures.canAddCluster(2, true, false);
      context.expect(proResult.$1, true);
      context.expect(proResult.$2 == null, true);
    },
  );
}

StepDefinitionGeneric<World> thenShouldAllowAddingCluster() {
  return then<World>(
    '应该允许添加集群',
    (context) async {
      // Pro user should allow adding
      final result = ProFeatures.canAddCluster(2, true, false);
      context.expect(result.$1, true);

      // Free user with grandfathering should allow adding
      final grandfatheredResult = ProFeatures.canAddCluster(2, false, true);
      context.expect(grandfatheredResult.$1, true);
    },
  );
}
