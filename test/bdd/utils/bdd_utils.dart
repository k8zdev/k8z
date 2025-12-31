import 'package:kubeconfig/kubeconfig.dart';
import 'package:k8zdev/dao/kube.dart';
import 'package:k8zdev/common/ops.dart';

/// Utility functions for BDD tests
class BddUtils {
  /// Load clusters from a kubeconfig YAML string and save them to the database
  static Future<void> addClustersFromKubeconfig(String kubeconfigContent) async {
    try {
      final kubeconfig = Kubeconfig.fromYaml(kubeconfigContent);
      final validation = kubeconfig.validate();
      talker.info("Config validation: ${validation.toJson()}");

      var clusters = kubeconfig.contexts?.map((ctx) {
            var name = ctx.context?.cluster ?? "";
            var authName = ctx.context?.authInfo ?? "";
            var namespace = ctx.context?.namespace ?? "";
            talker.debug("context: ${ctx.context?.toJson()}");

            var cluster = kubeconfig.clusters
                ?.where((ele) => ele.name == name)
                .first
                .cluster;

            var certificateAuthority = cluster?.certificateAuthorityData ?? "";
            var insecure = cluster?.insecureSkipTlsVerify;

            var authInfo = kubeconfig.authInfos
                ?.where((ele) => ele.name == authName)
                .first;
            var clientKey = authInfo?.user?.clientKeyData ?? "";
            var clientCert = authInfo?.user?.clientCertificateData ?? "";

            var username = authInfo?.user?.username;
            var password = authInfo?.user?.password;
            var token = authInfo?.user?.token;

            return K8zCluster(
              name: name,
              server: cluster?.server ?? "",
              caData: certificateAuthority,
              namespace: namespace,
              insecure: insecure ?? false,
              clientKey: clientKey,
              clientCert: clientCert,
              username: username ?? "",
              password: password ?? "",
              token: token ?? "",
              createdAt: DateTime.now().millisecondsSinceEpoch,
            );
          }).toList() ??
          [];

      // Insert all clusters into the database
      for (var cluster in clusters) {
        await K8zCluster.insert(cluster);
      }

      talker.info("Inserted ${clusters.length} clusters from kubeconfig");
    } catch (err) {
      talker.error("Failed to load kubeconfig: $err");
      rethrow;
    }
  }
}
