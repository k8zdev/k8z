import 'dart:convert';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_highlighting/flutter_highlighting.dart';
import 'package:flutter_highlighting/themes/github-dark-dimmed.dart';
import 'package:highlighting/languages/yaml.dart';
import 'package:k8zdev/common/styles.dart';
import 'package:k8zdev/generated/l10n.dart';
import 'package:k8zdev/models/models.dart';
import 'package:k8zdev/services/k8z_native.dart';
import 'package:k8zdev/widgets/modal.dart';
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
    contianersTile(lang, lang.initContainers, langCode, spec.initContainers),
  );

  // containers
  tiles.add(
    contianersTile(lang, lang.containers, langCode, spec.containers),
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
) {
  return SettingsTile.navigation(
    title: const Text(""),
    leading: leadingText(name, langCode),
    value: Text(containers.length.toString()),
    onPressed: (containers.isEmpty)
        ? null
        : (context) {
            List<AbstractSettingsTile> iPsTiles = [
              SettingsTile(title: Center(child: Text(name)))
            ];
            containers.forEach(
              (container) {
                // name
                iPsTiles.add(
                  copyTileValue(lang.name, container.name, langCode),
                );

                // imagePullPolicy
                iPsTiles.add(
                  copyTileValue(
                    lang.imagePullPolicy,
                    container.imagePullPolicy ?? "",
                    langCode,
                  ),
                );
                // image
                iPsTiles.add(
                  copyTileValue(
                    lang.image,
                    container.image ?? "",
                    langCode,
                  ),
                );

                if (container.command.isNotEmpty) {
                  copyTileValue(
                    lang.command,
                    container.command.toString(),
                    langCode,
                  );
                }

                if (container.args.isNotEmpty) {
                  copyTileValue(
                    lang.args,
                    container.args.toString(),
                    langCode,
                  );
                }

                // ports
                if (container.ports.isNotEmpty) {
                  iPsTiles.add(
                    copyTileYaml(
                      lang.ports,
                      {"ports": container.ports},
                      langCode,
                    ),
                  );
                }

                // livenessProbe
                if (container.livenessProbe != null) {
                  iPsTiles.add(
                    copyTileYaml(
                      lang.livenessProbe,
                      container.livenessProbe?.toJson(),
                      langCode,
                    ),
                  );
                }
                // readinessProbe
                if (container.readinessProbe != null) {
                  iPsTiles.add(
                    copyTileYaml(
                      lang.readinessProbe,
                      container.readinessProbe?.toJson(),
                      langCode,
                    ),
                  );
                }
                // startupProbe
                if (container.startupProbe != null) {
                  iPsTiles.add(
                    copyTileYaml(
                      lang.startupProbe,
                      container.startupProbe?.toJson(),
                      langCode,
                    ),
                  );
                }
              },
            );
            showModal(
              context,
              SettingsList(sections: [SettingsSection(tiles: iPsTiles)]),
            );
          },
  );
}

SettingsTile copyTile(String name, {String? value}) {
  return SettingsTile(
    title: Text(
      name,
      style: tileValueStyle,
    ),
    trailing: IconButton(
      onPressed: () async {
        await FlutterClipboard.copy(value ?? name);
      },
      icon: const Icon(Icons.copy),
    ),
    onPressed: null,
  );
}

SettingsTile copyTileValue(String name, String value, String langCode) {
  return SettingsTile(
    leading: leadingText(name, langCode),
    title: Text(
      value,
      style: tileValueStyle,
    ),
    trailing: IconButton(
      onPressed: () async {
        await FlutterClipboard.copy(value);
      },
      icon: const Icon(Icons.copy),
    ),
    onPressed: null,
  );
}

SettingsTile copyTileYaml(
  String name,
  Map<String, dynamic>? value,
  String langCode,
) {
  final yamlValue = K8zNative.json2yaml(jsonEncode(value));

  return SettingsTile(
    leading: leadingText(name, langCode),
    title: HighlightView(
      yamlValue,
      languageId: yaml.id,
      theme: githubDarkDimmedTheme,
      padding: defaultEdge,
      textStyle: const TextStyle(
        fontSize: 16,
      ),
    ),
    trailing: IconButton(
      onPressed: () async {
        await FlutterClipboard.copy(yamlValue.toString());
      },
      icon: const Icon(Icons.copy),
    ),
    onPressed: null,
  );
}
