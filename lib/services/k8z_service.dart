import 'package:flutter/material.dart';
import 'package:k8zdev/common/ops.dart';
import 'package:k8zdev/dao/kube.dart';
import 'package:k8zdev/providers/timeout.dart';
import 'package:k8zdev/services/k8z_native.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

/// [K8zService] implements a service to interactiv with Kubernetes cluster.
///
/// To use [K8zService] must provide cluster info when init this service.
class K8zService {
  K8zCluster cluster;
  String proxy;
  int timeout;

  K8zService(
    BuildContext context, {
    required this.cluster,
    this.proxy = "",
    this.timeout = 60,
  }) {
    final timeoutProvider =
        Provider.of<TimeoutProvider>(context, listen: false);
    final timeout = timeoutProvider.timeout;
    this.timeout = timeout;
  }

  /// [isStarted] used to check local server is started.
  /// The local server is used to proxy the request to the Kubernetes cluster.
  static Future<bool> isStarted() async {
    try {
      var resp = await http.get(
        Uri(scheme: "http", host: "localhost", port: 29257, path: "/ping"),
      );
      if (resp.statusCode == 200) {
        return true;
      }
      talker.error(
          "check local server failed, error:  status=${resp.statusCode},body=${resp.body}");
    } catch (e) {
      talker.error("check local server failed, error: $e");
    }
    return false;
  }

  /// [checkHealth] used to check the Kubernetes cluster is health.
  ///
  Future<bool> checkHealth() async {
    var resp = await K8zNative()
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
