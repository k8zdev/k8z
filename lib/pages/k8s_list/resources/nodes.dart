import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:k8zdev/common/const.dart';
import 'package:k8zdev/common/helpers.dart';
import 'package:k8zdev/common/styles.dart';
import 'package:k8zdev/dao/kube.dart';
import 'package:k8zdev/generated/l10n.dart';
import 'package:k8zdev/models/models.dart';
import 'package:k8zdev/services/k8z_native.dart';
import 'package:k8zdev/services/k8z_service.dart';
import 'package:k8zdev/widgets/settings_tile.dart';
import 'package:k8zdev/widgets/widgets.dart';
import 'package:settings_ui/settings_ui.dart';

class NodesPage extends StatefulWidget {
  final K8zCluster cluster;
  const NodesPage({super.key, required this.cluster});

  @override
  State<NodesPage> createState() => _NodesPageState();
}

class _NodesPageState extends State<NodesPage> {
  final _path = "/api/v1";
  final _resource = "nodes";
  late Future<JsonReturn> _futureFetchRes;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      _futureFetchRes =
          fetchCurrentRes(context, _path, _resource, namespaced: false);
    });
  }

  AbstractSettingsSection nodes(S lang) {
    return CustomSettingsSection(
      child: FutureBuilder(
        future: _futureFetchRes,
        builder: (BuildContext context, AsyncSnapshot<JsonReturn> snapshot) {
          var list = [];
          String totals = "";
          String duration = "";
          Widget title = Text(lang.name);
          Widget trailing = Text(lang.status);

          if (snapshot.connectionState == ConnectionState.waiting) {
            trailing = smallProgressIndicator;
          } else if (snapshot.hasError) {
            trailing = Tooltip(
              message: snapshot.error.toString(),
              child: Text(lang.error),
            );
          } else if (snapshot.data?.error != "") {
            title = Text(snapshot.data?.error ?? "");
            trailing = errorIcon;
          } else {
            if (snapshot.data != null && snapshot.data!.error.isNotEmpty) {
              trailing = Container();
              title = Text(lang.error);
              list = [
                SettingsTile(
                  title: Text(
                    snapshot.data!.error,
                    style: const TextStyle(color: Colors.grey),
                  ),
                )
              ];
            } else {
              var data = snapshot.data;
              var body = data?.body;

              final nodesList = IoK8sApiCoreV1NodeList.fromJson(body);

              totals = lang.items_number(nodesList?.items.length ?? 0);
              Duration rd = snapshot.data!.duration;
              duration = lang.api_request_duration(rd.prettyMs);

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

                      final tile = SettingsTile(
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
                              Text(lang.node_roles(roles),
                                  style: smallTextStyle),
                            ]),
                            TableRow(children: [
                              Text(lang.node_os_image(osImage!),
                                  style: smallTextStyle),
                            ]),
                            TableRow(children: [
                              Text(lang.node_arch(arch!),
                                  style: smallTextStyle),
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

                      return metadataSettingsTile(
                        context,
                        tile,
                        node.metadata!.name!,
                        node.metadata!.namespace,
                        _path,
                        _resource,
                      );
                    },
                  ).toList() ??
                  [];
            }
          }

          return SettingsSection(
            title: Text(lang.nodes + totals + duration),
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
      body: Container(
        margin: bottomEdge,
        child: RefreshIndicator(
          child: SettingsList(
            sections: [nodes(lang)],
          ),
          onRefresh: () async => setState(() {
            _futureFetchRes = fetchCurrentRes(context, _path, _resource,
                namespaced: false, listen: false);
          }),
        ),
      ),
    );
  }
}
