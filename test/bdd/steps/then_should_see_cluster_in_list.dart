import 'package:gherkin/gherkin.dart';
import 'package:k8zdev/dao/kube.dart';

StepDefinitionGeneric<World> thenShouldSeeClusterInList() {
  return then1<String, World>(
    '我应该在集群列表中看到 {string}',
    (clusterName, context) async {
      // For now, verify the cluster exists in the database
      // This tests the business logic without requiring full UI setup
      final clusters = await K8zCluster.list();

      // Find cluster with the expected name
      final clusterExists = clusters.any((c) => c.name == clusterName);

      context.expect(clusterExists, true, reason: 'Expected cluster "$clusterName" to exist in database');
    },
  );
}
