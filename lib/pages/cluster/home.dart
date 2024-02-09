import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:k8sapp/common/ops.dart';
import 'package:k8sapp/dao/kube.dart';
import 'package:k8sapp/generated/l10n.dart';
import 'package:k8sapp/services/k8z_native.dart';
import 'package:k8sapp/services/k8z_service.dart';
import 'package:settings_ui/settings_ui.dart';

class ClusterHomePage extends StatefulWidget {
  final K8zCluster cluster;
  const ClusterHomePage({super.key, required this.cluster});

  @override
  State<ClusterHomePage> createState() => _ClusterHomePageState();
}

class _ClusterHomePageState extends State<ClusterHomePage> {
  SettingsSection overview(S lang) {
    return SettingsSection(
      title: Text(lang.overview),
      tiles: [
        SettingsTile(
          title: Text(lang.version),
          trailing: FutureBuilder<BodyReturn>(
            future: () async {
              return await K8zService(cluster: widget.cluster).get("/version");
            }(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(color: Colors.blue),
                );
              } else if (snapshot.hasError) {
                return Tooltip(
                  child: Text('Error: ${snapshot.error}'),
                );
              }
              var data = snapshot.data;
              var body = data?.body ?? "";
              var message = data?.error ?? "";
              var childText = data?.body ?? "";
              var ok = data?.error.isEmpty ?? false;

              talker.info("ok: $ok, body: $body,error: $message");

              if (ok) {
                Map<String, dynamic> version = jsonDecode(body);
                message = body;
                childText = version["gitVersion"];
              }

              return Tooltip(
                message: message,
                child: Text(childText),
              );
            },
          ),
        ),
        SettingsTile(
          title: Text(lang.status),
          trailing: FutureBuilder(
            future: () async {
              return await K8zService(cluster: widget.cluster).checkHealth();
            }(),
            builder: (context, snapshot) {
              var running = snapshot.data ?? false;
              var style =
                  TextStyle(color: running ? Colors.green : Colors.redAccent);

              return Text(running ? lang.running : lang.error, style: style);
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var lang = S.of(context);
    var appbar = AppBar(title: Text(widget.cluster.name));

    return Scaffold(
      appBar: appbar,
      body: SettingsList(
        sections: [
          overview(lang),
        ],
      ),
    );
  }
}
