import 'dart:io';

import 'package:gherkin/gherkin.dart';
import '../utils/bdd_utils.dart';

StepDefinitionGeneric<World> whenLoadKubeconfig() {
  return when<World>(
    '我选择并加载一个有效的 kubeconfig 文件',
    (context) async {
      // In a real test, we bypass the file picker.
      // We load the content from a predefined test asset.
      final kubeconfigContent =
          await File('test/bdd/assets/kind-k8z-config.yaml').readAsString();

      // Call the utility function that processes the kubeconfig.
      await BddUtils.addClustersFromKubeconfig(kubeconfigContent);
    },
  );
}
