import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:k8zdev/common/styles.dart';
import 'package:k8zdev/generated/l10n.dart';
import 'package:k8zdev/models/models.dart';
import 'package:k8zdev/widgets/modal.dart';
import 'package:k8zdev/widgets/tiles.dart';
import 'package:k8zdev/widgets/widgets.dart';
import 'package:kubeconfig/kubeconfig.dart';
import 'package:settings_ui/settings_ui.dart';

List<AbstractSettingsTile> buildPodDetailSectionTiels(
  BuildContext context,
  IoK8sApiCoreV1Pod? pod,
  String langCode,
) {
  final lang = S.of(context);

  List<AbstractSettingsTile> tiles = [];

  final spec = pod?.spec;
  if (pod == null || spec == null) {
    return [SettingsTile(title: Text(lang.empty))];
  }

  // initContainers
  tiles.add(
    contianersTile(
      lang,
      lang.initContainers,
      langCode,
      spec.initContainers,
      pod.status,
    ),
  );

  // containers
  tiles.add(
    contianersTile(
      lang,
      lang.containers,
      langCode,
      spec.containers,
      pod.status,
    ),
  );

  // dnsPolicy
  tiles.add(
    SettingsTile(
      title: const Text(""),
      leading: leadingText(lang.dnsPolicy, langCode),
      value: Text(
        spec.dnsPolicy ?? "-",
        style: tileValueStyle,
      ),
    ),
  );

  // hostNetwork
  tiles.add(
    SettingsTile(
      title: const Text(""),
      leading: leadingText(lang.hostNetwork, langCode),
      value: Text(
        (spec.hostNetwork ?? false).toString(),
        style: tileValueStyle,
      ),
      onPressed: null,
    ),
  );

  // hostname
  if (!spec.hostname.isNullOrEmpty) {
    tiles.add(
      SettingsTile(
        title: const Text(""),
        value: Text(
          spec.hostname ?? "",
          style: tileValueStyle,
        ),
        leading: leadingText(lang.hostname, langCode),
      ),
    );
  }

  // imagePullSecrets
  tiles.add(
    SettingsTile.navigation(
      title: const Text(""),
      leading: leadingText(lang.imagePullSecrets, langCode),
      value: Text(spec.imagePullSecrets.length.toString()),
      onPressed: (spec.imagePullSecrets.isEmpty)
          ? null
          : (context) {
              List<AbstractSettingsTile> iPsTiles = [
                SettingsTile(title: Center(child: Text(lang.imagePullSecrets)))
              ];
              spec.imagePullSecrets.forEach(
                (element) {
                  iPsTiles.add(
                    copyTile(element.name!),
                  );
                },
              );
              showModal(
                context,
                SettingsList(sections: [SettingsSection(tiles: iPsTiles)]),
              );
            },
    ),
  );

  return tiles;
}

SettingsTile contianersTile(
  S lang,
  String name,
  String langCode,
  List<IoK8sApiCoreV1Container> containers,
  IoK8sApiCoreV1PodStatus? status,
) {
  Map<String, IoK8sApiCoreV1ContainerStatus> containerStatuses = {};
  status!.containerStatuses.forEachIndexed((index, element) {
    containerStatuses
        .addAll(<String, IoK8sApiCoreV1ContainerStatus>{element.name: element});
  });
  return SettingsTile.navigation(
    title: const Text(""),
    leading: leadingText(name, langCode),
    value: Text(containers.length.toString()),
    onPressed: (containers.isEmpty)
        ? null
        : (context) {
            List<AbstractSettingsSection> podsSections = [];

            containers.forEach(
              (container) {
                List<AbstractSettingsTile> podTiles = [];
                podTiles.add(
                  copyTileValue(
                      "lang.container_id",
                      containerStatuses[container.name]?.containerID ?? "",
                      langCode),
                );

                // image
                podTiles.add(
                  copyTileValue(
                    lang.image,
                    container.image ?? "",
                    langCode,
                  ),
                );
                podTiles.add(
                  copyTileValue(
                      "lang.image_id",
                      containerStatuses[container.name]?.imageID ?? "",
                      langCode),
                );
                // imagePullPolicy
                podTiles.add(
                  copyTileValue(
                    lang.imagePullPolicy,
                    container.imagePullPolicy ?? "",
                    langCode,
                  ),
                );

                if (container.command.isNotEmpty) {
                  podTiles.add(
                    copyTileYaml(lang.command, container.command, langCode),
                  );
                }

                if (container.args.isNotEmpty) {
                  podTiles.add(
                    copyTileYaml(lang.args, container.args, langCode),
                  );
                }

                if (container.env.isNotEmpty) {
                  podTiles.add(
                    copyTileYaml("env", container.env, langCode),
                  );
                }

                // ports
                if (container.ports.isNotEmpty) {
                  podTiles.add(
                    copyTileYaml(lang.ports, container.ports, langCode),
                  );
                }

                // livenessProbe
                if (container.livenessProbe != null) {
                  podTiles.add(
                    copyTileYaml(
                      lang.livenessProbe,
                      container.livenessProbe?.toJson(),
                      langCode,
                    ),
                  );
                }
                // readinessProbe
                if (container.readinessProbe != null) {
                  podTiles.add(
                    copyTileYaml(
                      lang.readinessProbe,
                      container.readinessProbe?.toJson(),
                      langCode,
                    ),
                  );
                }
                // startupProbe
                if (container.startupProbe != null) {
                  podTiles.add(
                    copyTileYaml(
                      lang.startupProbe,
                      container.startupProbe?.toJson(),
                      langCode,
                    ),
                  );
                }
                podsSections.add(
                  SettingsSection(
                    margin: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 10),
                    title: Text(container.name),
                    tiles: podTiles,
                  ),
                );
              },
            );
            showModal(
              context,
              SettingsList(
                sections: podsSections,
                contentPadding: EdgeInsets.zero,
              ),
            );
          },
  );
}
