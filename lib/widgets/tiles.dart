import 'dart:convert';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_highlighting/flutter_highlighting.dart';
import 'package:flutter_highlighting/themes/github-dark-dimmed.dart';
import 'package:highlighting/languages/yaml.dart';
import 'package:k8zdev/common/styles.dart';
import 'package:k8zdev/services/k8z_native.dart';
import 'package:k8zdev/widgets/widgets.dart';
import 'package:settings_ui/settings_ui.dart';

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
  dynamic value,
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
