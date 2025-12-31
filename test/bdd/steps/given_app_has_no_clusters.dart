import 'package:gherkin/gherkin.dart';
import 'package:k8zdev/dao/dao.dart';
import 'package:k8zdev/dao/kube.dart';

StepDefinitionGeneric<World> givenAppHasNoClusters() {
  return given<World>(
    '应用内没有集群',
    (context) async {
      // This is a destructive action, only for testing.
      // It ensures that we start from a clean state.
      // Delete all clusters from the database
      await database.delete(clustersTable);
      final clusters = await K8zCluster.list();
      if (clusters.isNotEmpty) {
        throw Exception('Database cleanup failed. Clusters still exist.');
      }
      context.expect(clusters.isEmpty, true);
    },
  );
}
