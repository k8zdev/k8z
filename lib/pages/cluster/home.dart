import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:k8sapp/common/ops.dart';
import 'package:k8sapp/dao/kube.dart';
import 'package:k8sapp/generated/l10n.dart';
import 'package:k8sapp/models/models.dart';
import 'package:k8sapp/services/k8z_native.dart';
import 'package:k8sapp/services/k8z_service.dart';
import 'package:k8sapp/widgets/widgets.dart';
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
          trailing: FutureBuilder<JsonReturn>(
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
              var ok = data?.error.isEmpty ?? false;

              talker.info("ok: $ok, body: $body,error: $message");

              var childText = message;
              if (ok) {
                childText = data?.body["gitVersion"];
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

  AbstractSettingsSection nodes(S lang) {
    return CustomSettingsSection(
      child: FutureBuilder(
        future: () async {
          // await Future.delayed(const Duration(seconds: 1));
          return await K8zService(cluster: widget.cluster)
              .get("/api/v1/nodes?limit=3");
        }(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          var title = Text(lang.name);
          Widget trailing = Text(lang.all);

          if (snapshot.connectionState == ConnectionState.waiting) {
            trailing = const SizedBox(
              height: 16,
              width: 16,
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            trailing = Tooltip(
              message: snapshot.error.toString(),
              child: Text(lang.error),
            );
          }

          var data = snapshot.data;
          var body = data?.body;
          var message = data?.error ?? "";
          var ok = message.isEmpty ?? false;

          // talker.debug("ok: $ok, body: $body,error: $message");
          final nodesList = IoK8sApiCoreV1NodeList.fromJson(body);
          final list = nodesList?.items.mapIndexed(
                (index, node) {
                  var metadata = node.metadata;
                  var status = node.status?.conditions
                      .where((condition) => condition.status == 'True')
                      .map((condition) => condition.type);
                  var running = status != null &&
                      status.where((e) => e == 'Ready').isNotEmpty;

                  return SettingsTile.navigation(
                    title: Text(metadata?.name ?? ""),
                    trailing: running ? errorIcon : runningIcon,
                  );
                },
              ).toList() ??
              [];

          return SettingsSection(
            title: Text(lang.nodes),
            tiles: [
              SettingsTile.navigation(title: title, trailing: trailing),
              ...list,
            ],
          );
        },
      ),
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
          nodes(lang),
        ],
      ),
    );
  }
}
