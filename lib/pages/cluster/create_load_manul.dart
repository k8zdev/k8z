import 'dart:io';

import 'package:code_editor/code_editor.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class ManualLoadSubPage extends StatefulWidget {
  const ManualLoadSubPage({super.key});

  @override
  State<ManualLoadSubPage> createState() => _ManualLoadSubPageState();
}

class _ManualLoadSubPageState extends State<ManualLoadSubPage> {
  String _initDir = "";
  String _config = '''
apiVersion: v1
clusters: [],
contexts: []
''';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("load"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (Platform.isMacOS) {
            var downloadDir = await getDownloadsDirectory();
            _initDir = downloadDir!.path.replaceAll("Downloads", "./.kube/");
          }
          final XFile? file = await openFile(initialDirectory: _initDir);
          var v = await file?.readAsString();
          setState(() {
            _config = v ?? _config;
          });
        },
        child: const Icon(Icons.add),
      ),
      body: Center(
        child: CodeEditor(
          model: EditorModel(
            files: [
              FileEditor(
                name: "kubeconfig",
                language: "yaml",
                code: _config,
                readonly: false,
              )
            ],
            styleOptions: EditorModelStyleOptions(),
          ),
          formatters: const ["yaml"],
        ),
      ),
    );
  }
}
