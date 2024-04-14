import 'dart:async';
import 'dart:io';

import 'package:code_editor/code_editor.dart';
import 'package:flutter/material.dart';
import 'package:k8zdev/common/helpers.dart';
import 'package:k8zdev/generated/l10n.dart';
import 'package:k8zdev/services/k8z_native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:json2yaml/json2yaml.dart';

class YamlPage extends StatefulWidget {
  final String itemUrl;
  final String fileName;
  final JsonReturn resp;
  const YamlPage({
    super.key,
    required this.itemUrl,
    required this.fileName,
    required this.resp,
  });

  @override
  State<YamlPage> createState() => _YamlPageState();
}

class _YamlPageState extends State<YamlPage> {
  late String content;

  @override
  void initState() {
    super.initState();
    content = json2yaml(
      widget.resp.body,
      yamlStyle: YamlStyle.pubspecYaml,
    );
  }

  Future<File> exportFile(S lang) async {
    // ony for iOS
    final directory = await getApplicationDocumentsDirectory();
    final fileName = "exported/${widget.fileName}.yaml";
    final file =
        await File("${directory.path}/$fileName").create(recursive: true);

    final f = file.writeAsString(content, flush: true);
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        showCloseIcon: true,
        closeIconColor: Colors.white,
        backgroundColor: Colors.green,
        content: Text(
          lang.exported(fileName),
        ),
      ),
    );
    return f;
  }

  Widget yamlEditor(S lang, JsonReturn resp, double appbarHeight) {
    var buttons = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          height: 50,
          child: TextButton.icon(
            onPressed: () async {
              await exportFile(lang);
            },
            label: Text(lang.export),
            icon: const Icon(Icons.save_rounded),
          ),
        ),
        const Divider(indent: 10),
      ],
    );
    double buttonsHeight = 270;

    return Column(
      children: [
        CodeEditor(
          model: EditorModel(
            files: [
              FileEditor(
                name: "${widget.fileName}.yaml",
                language: "yaml",
                code: content,
                readonly: true,
              )
            ],
            styleOptions: EditorModelStyleOptions(
              showToolbar: false,
              editButtonName: lang.edit,
              heightOfContainer:
                  availableHeight(context, appbarHeight + buttonsHeight),
            ),
          ),
          formatters: const ["yaml"],
        ),

        const Divider(height: 10, color: Colors.transparent),
        // buttons
        buttons,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    final appbar = AppBar(title: Text(lang.resource_yaml));
    return Scaffold(
      appBar: appbar,
      body: yamlEditor(
        lang,
        widget.resp,
        appbar.preferredSize.height,
      ),
    );
  }
}
