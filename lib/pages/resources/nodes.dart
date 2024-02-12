import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:k8sapp/common/helpers.dart';
import 'package:k8sapp/common/styles.dart';
import 'package:k8sapp/dao/kube.dart';
import 'package:k8sapp/generated/l10n.dart';
import 'package:k8sapp/models/models.dart';
import 'package:k8sapp/services/k8z_native.dart';
import 'package:k8sapp/services/k8z_service.dart';
import 'package:k8sapp/widgets/widgets.dart';
import 'package:settings_ui/settings_ui.dart';

class NodesPage extends StatefulWidget {
  final K8zCluster cluster;
  const NodesPage({super.key, required this.cluster});

  @override
  State<NodesPage> createState() => _NodesPageState();
}

class _NodesPageState extends State<NodesPage> {
  AbstractSettingsSection nodes(S lang) {
    return CustomSettingsSection(
      child: FutureBuilder(
        future: () async {
          // await Future.delayed(const Duration(seconds: 1));
          return await K8zService(cluster: widget.cluster)
              .get("/api/v1/nodes?limit=500");
        }(),
        builder: (BuildContext context, AsyncSnapshot<JsonReturn> snapshot) {
          var list = [];
          Widget title = Text(lang.name);
          Widget trailing = Text(lang.status);

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
          } else if (snapshot.data?.error != "") {
            title = Text(snapshot.data?.error ?? "");
            trailing = errorIcon;
          } else {
            var data = snapshot.data;
            var body = data?.body;

            final nodesList = IoK8sApiCoreV1NodeList.fromJson(body);

            list = nodesList?.items.mapIndexed(
                  (index, node) {
                    var metadata = node.metadata;
                    var labels = metadata?.labels;
                    var nodeInfo = node.status?.nodeInfo;
                    var status = node.status?.conditions
                        .where((condition) => condition.status == 'True')
                        .map((condition) => condition.type);
                    var running = status != null &&
                        status.where((e) => e == 'Ready').isNotEmpty;
                    var roles = nodeRoles(labels ?? {});
                    var now = DateTime.now();
                    var creation = metadata?.creationTimestamp ?? now;
                    var age = now.difference(creation).pretty;
                    var arch = nodeInfo?.architecture;
                    var version = nodeInfo?.kubeletVersion;
                    var osImage = nodeInfo?.osImage;
                    var os = nodeInfo?.operatingSystem;
                    var kernel = nodeInfo?.kernelVersion;
                    var runtime = nodeInfo?.containerRuntimeVersion;
                    var addresses = node.status?.addresses;
                    var internal = "<none>";
                    var iip = addresses
                        ?.where((e) => e.type == "InternalIP")
                        .toList();
                    if (iip!.isNotEmpty) {
                      internal = iip.first.address;
                    }
                    var external = "<none>";
                    var eip = addresses
                        ?.where((e) => e.type == "ExternalIP")
                        .toList();
                    if (eip!.isNotEmpty) {
                      external = eip.first.address;
                    }

                    return SettingsTile(
                      title: Table(
                        columnWidths: const {
                          0: FlexColumnWidth(120),
                        },
                        children: [
                          TableRow(children: [
                            Text(metadata?.name ?? ""),
                          ]),
                          const TableRow(
                            children: [
                              SizedBox(height: 6),
                            ],
                          ),
                          TableRow(children: [
                            Text(lang.node_roles(roles), style: smallTextStyle),
                          ]),
                          TableRow(children: [
                            Text(lang.node_os_image(osImage!),
                                style: smallTextStyle),
                          ]),
                          TableRow(children: [
                            Text(lang.node_arch(arch!), style: smallTextStyle),
                          ]),
                          TableRow(children: [
                            Text(lang.node_version(version!),
                                style: smallTextStyle),
                          ]),
                          TableRow(children: [
                            Text(lang.node_kernel(os!, kernel!),
                                style: smallTextStyle),
                          ]),
                          TableRow(children: [
                            Text(lang.internel_ip(internal),
                                style: smallTextStyle),
                          ]),
                          TableRow(children: [
                            Text(lang.external_ip(external),
                                style: smallTextStyle),
                          ]),
                          TableRow(children: [
                            Text(lang.container_runtime(runtime!),
                                style: smallTextStyle),
                          ]),
                        ],
                      ),
                      trailing: Row(children: [
                        Text(age),
                        const Divider(indent: 12),
                        running ? runningIcon : errorIcon,
                      ]),
                    );
                  },
                ).toList() ??
                [];
          }

          return SettingsSection(
            title: Text(lang.nodes),
            tiles: [
              SettingsTile.navigation(
                title: title,
                trailing: trailing,
              ),
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
    return Scaffold(
      appBar: AppBar(title: Text(lang.nodes)),
      body: SettingsList(
        sections: [nodes(lang)],
      ),
    );
  }
}
