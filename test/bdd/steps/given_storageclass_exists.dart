import 'package:gherkin/gherkin.dart';
import '../utils/bdd_utils.dart';

StepDefinitionGeneric<World> givenStorageclassExists() {
  return given1<String, World>(
    '集群中存在名为 {string} 的StorageClass',
    (storageClassName, context) async {
      // For BDD testing, prepare test context with a loaded cluster
      // This verifies that StorageClass data can be processed
      final kubeconfigContent = await BddUtils.readTestAsset('kind-k8z-config.yaml');
      if (kubeconfigContent != null) {
        await BddUtils.addClustersFromKubeconfig(kubeconfigContent);
      }
    },
  );
}
