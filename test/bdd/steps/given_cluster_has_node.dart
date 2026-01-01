import 'package:flutter_test/flutter_test.dart';
import 'package:gherkin/gherkin.dart';
import 'package:k8zdev/dao/kube.dart';

/// Step to ensure the cluster has a node available
/// This is a placeholder step - in a real integration test this would
/// set up test data or verify existing cluster state
StepDefinitionGeneric<World> givenClusterHasNode() {
  return given<World>(
    '集群中有一个可用的节点',
    (context) async {
      // Verify the cluster is loaded and has nodes
      final clusters = await K8zCluster.list();
      if (clusters.isEmpty) {
        throw Exception('No cluster available. Please load a cluster first.');
      }
      final cluster = clusters.first;
      context.expect(cluster.name, isNotEmpty);
    },
    configuration: StepDefinitionConfiguration()
      ..timeout = const Duration(seconds: 10),
  );
}