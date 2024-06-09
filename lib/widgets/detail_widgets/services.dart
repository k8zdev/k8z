import 'package:flutter/material.dart';
import 'package:k8zdev/generated/l10n.dart';
import 'package:k8zdev/models/models.dart';
import 'package:k8zdev/widgets/tiles.dart';
import 'package:settings_ui/settings_ui.dart';

List<AbstractSettingsTile> buildServicesTiles(
  BuildContext context,
  IoK8sApiCoreV1ServiceSpec? spec,
  IoK8sApiCoreV1ServiceStatus? status,
  String langCode,
) {
  final lang = S.of(context);

  List<AbstractSettingsTile> tiles = [];

  if (spec == null) {
    return [SettingsTile(title: Text(lang.empty))];
  }

  var externalIps = "";
  if (spec.type == "LoadBalancer") {
    externalIps = status!.loadBalancer!.ingress
        .map((ingress) => "${ingress.ip}")
        .join(", ");
  }

  tiles.addAll([
    copyTileValue(
      lang.type,
      spec.type ?? "",
      langCode,
      enLen: 72.0,
      zhLen: 72.0,
    ),
    copyTileValue(
      lang.cluster_ip,
      spec.clusterIP ?? "",
      langCode,
      enLen: 72.0,
      zhLen: 72.0,
    ),
    if (spec.externalName != null)
      copyTileValue(
        lang.external_name,
        spec.externalName ?? "",
        langCode,
        enLen: 72.0,
        zhLen: 72.0,
      ),
    if (spec.externalIPs.isNotEmpty || externalIps != "")
      copyTileValue(
        lang.external_ips,
        spec.externalIPs.isNotEmpty ? spec.externalIPs.join(", ") : externalIps,
        langCode,
        enLen: 72.0,
        zhLen: 72.0,
      ),
    if (spec.loadBalancerIP != null)
      copyTileValue(
        lang.load_balancer_ip,
        spec.loadBalancerIP ?? "",
        langCode,
        enLen: 72.0,
        zhLen: 72.0,
      ),
    copyTileValue(
      lang.ports,
      spec.ports
          .map((port) =>
              "${port.port}${(port.nodePort != null) ? ":${port.nodePort}" : ""}/${port.protocol}")
          .join(", "),
      langCode,
      enLen: 72.0,
      zhLen: 72.0,
    ),
    copyTileYaml(
      lang.ports,
      spec.ports,
      langCode,
      enLen: 72.0,
      zhLen: 45.0,
    ),
    copyTileYaml(
      lang.selector,
      spec.selector,
      langCode,
      enLen: 72.0,
      zhLen: 45.0,
    ),
    if (spec.sessionAffinity != null)
      copyTileValue(
        lang.session_affinity,
        spec.sessionAffinity ?? "",
        langCode,
        enLen: 72.0,
        zhLen: 72.0,
      ),
  ]);

  return tiles;
}
