import 'package:k8sapp/common/ops.dart';
import 'package:k8sapp/dao/kube.dart';
import 'package:k8sapp/services/k8z_native.dart';

/// [K8zService] implements a service to interactiv with Kubernetes cluster.
///
/// To use [K8zService] must provide cluster info when init this service.
class K8zService {
  K8zCluster cluster;
  String proxy;
  int timeout;

  K8zService({
    required this.cluster,
    this.proxy = "",
    this.timeout = 60,
  });

  /// [checkHealth] used to check the Kubernetes cluster is health.
  ///
  Future<bool> checkHealth() async {
    var resp = K8zNative()
        .k8zRequestRaw(cluster, proxy, timeout, "GET", "/readyz", "");
    if (resp.body == "ok") {
      return true;
    }
    talker.error("check failed, error ${resp.error}");
    return false;
  }

  /// [get] it is used to run the GET request on the Kubernetes cluster.
  ///
  Future<JsonReturn> get(String api) async {
    return K8zNative().k8zRequest(cluster, proxy, timeout, "GET", api, "");
  }

  /// [delete] it is used to run the DELETE request on the Kubernetes cluster.
  ///
  Future<JsonReturn> delete(String api, String body) async {
    return K8zNative().k8zRequest(cluster, proxy, timeout, "DELETE", api, body);
  }

  /// [patch] it is used to run the PATCH request on the Kubernetes cluster.
  /// The [body] must be a valid json patch.
  Future<JsonReturn> patch(String api, String body) async {
    return K8zNative().k8zRequest(cluster, proxy, timeout, "PATCH", api, body);
  }

  /// [post] it is used to run the POST request on the Kubernetes cluster.
  ///
  Future<JsonReturn> post(String api, String body) async {
    return K8zNative().k8zRequest(cluster, proxy, timeout, "POST", api, body);
  }
}
