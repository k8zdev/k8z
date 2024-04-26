import 'package:clipboard/clipboard.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_highlighting/flutter_highlighting.dart';
import 'package:flutter_highlighting/themes/github-dark-dimmed.dart';
import 'package:highlighting/languages/yaml.dart';
import 'package:k8zdev/common/styles.dart';
import 'package:k8zdev/generated/l10n.dart';
import 'package:k8zdev/models/models.dart';
import 'package:k8zdev/widgets/modal.dart';
import 'package:k8zdev/widgets/widgets.dart';
import 'package:settings_ui/settings_ui.dart';

List<AbstractSettingsTile> buildConfigMapDetailSectionTiels(
  BuildContext context,
  IoK8sApiCoreV1ConfigMap? cm,
  String langCode,
) {
  final lang = S.of(context);

  List<AbstractSettingsTile> tiles = [];

  if (cm == null || cm.data.isEmpty) {
    return [SettingsTile(title: Text(lang.empty))];
  }

  cm.data.entries.forEachIndexed((index, element) {
    tiles.add(
      SettingsTile.navigation(
        title: leadingText(element.key, langCode),
        value: Text(element.value),
        trailing: IconButton(
          onPressed: () async {
            await FlutterClipboard.copy(element.value);
          },
          icon: const Icon(Icons.copy),
        ),
        onPressed: (context) {
          showModal(
            context,
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(element.key),
                    const Divider(indent: 10),
                    ElevatedButton.icon(
                      onPressed: () async {
                        await FlutterClipboard.copy(element.key);
                      },
                      icon: const Icon(
                        Icons.key,
                        size: 12,
                      ),
                      label: const Text(
                        "copy key",
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    const Divider(indent: 10),
                    ElevatedButton.icon(
                      onPressed: () async {
                        await FlutterClipboard.copy(element.value);
                      },
                      icon: const Icon(
                        Icons.text_format,
                        size: 12,
                      ),
                      label: const Text(
                        "copy key",
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 368,
                  padding: const EdgeInsets.only(top: 10),
                  child: SingleChildScrollView(
                    // can not selectable https://github.com/akvelon/dart-highlighting/pull/71/files
                    child: HighlightView(
                      element.value,
                      languageId: yaml.id,
                      theme: githubDarkDimmedTheme,
                      padding: defaultEdge,
                      textStyle: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
    //
  });
  return tiles;
}
