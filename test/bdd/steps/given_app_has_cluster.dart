import 'package:gherkin/gherkin.dart';
import 'package:k8zdev/dao/kube.dart';

StepDefinitionGeneric<World> givenAppHasCluster() {
  return given<World>(
    '应用中已加载集群',
    (context) async {
      // Verify that at least one cluster exists
      final clusters = await K8zCluster.list();
      if (clusters.isEmpty) {
        throw Exception('No clusters found. Please load a cluster first.');
      }
      context.expect(clusters.isNotEmpty, true);
    },
  );
}
