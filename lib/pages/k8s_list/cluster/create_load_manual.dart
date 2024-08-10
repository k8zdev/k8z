import 'dart:io';

import 'package:code_editor/code_editor.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:k8zdev/common/helpers.dart';
import 'package:k8zdev/common/ops.dart';
import 'package:k8zdev/dao/kube.dart';
import 'package:k8zdev/generated/l10n.dart';
import 'package:path_provider/path_provider.dart';
import 'package:kubeconfig/kubeconfig.dart';

class ManualLoadSubPage extends StatefulWidget {
  const ManualLoadSubPage({super.key});

  @override
  State<ManualLoadSubPage> createState() => _ManualLoadSubPageState();
}

class _ManualLoadSubPageState extends State<ManualLoadSubPage> {
  String _initDir = "";
  String _config = "";
  final buttonsHeight = 200;
  final _model = EditorModel(files: [FileEditor(name: "kubeconfig")]);

  loadFileOnPressed(appbar, lang) async {
    if (Platform.isMacOS) {
      var downloadDir = await getDownloadsDirectory();
      _initDir = downloadDir!.path.replaceAll("Downloads", "./.kube/");
    }
    final XFile? file = await openFile(initialDirectory: _initDir);
    var v = await file?.readAsString();
    setState(() {
      _config = v ?? _config;
    });
  }

  nextStepOnPressed() async {
    var lang = S.of(context);
    try {
      final kubeconfig = Kubeconfig.fromYaml(_config);
      final validation = kubeconfig.validate();
      talker.info("config validation: ${validation.toJson()}");
      // todo: not vaild
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

      GoRouter.of(context).pushNamed("choice_clusters", extra: clusters);
    } catch (err) {
      await showDialog(
        context: context,
        builder: (context) {
          talker.error(err.toString());
          return AlertDialog(
            title: Text(lang.error),
            content: Text(err.toString()),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(lang.ok),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var lang = S.of(context);
    var appbar = AppBar(title: Text(lang.load_file));

    var buttons = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          height: 50,
          child: TextButton.icon(
            onPressed: () async {
              await loadFileOnPressed(appbar, lang);
            },
            label: Text(lang.load_file),
            icon: const Icon(Icons.file_copy_outlined),
          ),
        ),
        const Divider(indent: 20),
        SizedBox(
          height: 50,
          child: TextButton.icon(
            onPressed: nextStepOnPressed,
            label: Text(lang.next_step),
            icon: const Icon(Icons.ac_unit),
          ),
        ),
        const Divider(indent: 10),
      ],
    );
    _model.styleOptions = EditorModelStyleOptions(
      showToolbar: false,
      editButtonName: lang.edit,
      placeCursorAtTheEndOnEdit: false,
      heightOfContainer: availableHeight(
          context, appbar.preferredSize.height + buttonsHeight + 20),
    );
    _model.allFiles = [
      FileEditor(
        name: "kubeconfig",
        language: "yaml",
        code: _config,
        // readonly: false,
      )
    ];

    return Scaffold(
      appBar: appbar,
      body: SingleChildScrollView(
        child: Column(
          children: [
            CodeEditor(
              model: _model,
              formatters: const ["yaml"],
              onSubmit: (language, value) {
                setState(() {
                  _config = value;
                });
              },
            ),

            const Divider(height: 20, color: Colors.transparent),
            // buttons
            buttons,
          ],
        ),
      ),
    );
  }
}
