import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:k8zdev/common/const.dart';
import 'package:k8zdev/common/helpers.dart';
import 'package:k8zdev/common/ops.dart';
import 'package:k8zdev/common/styles.dart';
import 'package:k8zdev/dao/kube.dart';
import 'package:k8zdev/generated/l10n.dart';
import 'package:k8zdev/models/models.dart';
import 'package:k8zdev/providers/current_cluster.dart';
import 'package:k8zdev/services/k8z_native.dart';
import 'package:k8zdev/services/k8z_service.dart';
import 'package:k8zdev/widgets/namespace.dart';
import 'package:k8zdev/widgets/settings_tile.dart';
import 'package:k8zdev/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';

class DeploymentsPage extends StatefulWidget {
  final K8zCluster cluster;
  const DeploymentsPage({super.key, required this.cluster});

  @override
  State<DeploymentsPage> createState() => _DeploymentsPageState();
}

class _DeploymentsPageState extends State<DeploymentsPage> {
  final String _path = "apis/apps/v1";
  final String _resource = "deployments";
  late Future<JsonReturn> _futureFetchRes;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      _futureFetchRes = _fetchRes();
    });
  }

  Future<JsonReturn> _fetchRes() async {
    if (!mounted) {
      talker.error("null mounted");
      return JsonReturn(body: {}, error: "", duration: Duration.zero);
    }

    final cluster = Provider.of<CurrentCluster>(context, listen: true).cluster;

    if (cluster == null) {
      talker.error("null cluster");
      return JsonReturn(body: {}, error: "", duration: Duration.zero);
    }

    final namespaced =
        cluster.namespace.isEmpty ? "" : "/namespaces/${cluster.namespace}";

    final resp = await K8zService(context, cluster: cluster)
        .get("$_path$namespaced/$_resource");

    return resp;
  }

  Widget getStatus(
    int replicas,
    int ready,
    int upToDate,
    int available,
  ) {
    if (replicas == 0 || ready == 0 || upToDate == 0 || available == 0) {
      return quizIcon;
    }

    if (replicas == ready && replicas == upToDate && replicas == available) {
      return runningIcon;
    }

    return errorIcon;
  }

  AbstractSettingsSection buildDeploymentList(S lang) {
    return CustomSettingsSection(
      child: FutureBuilder(
        future: _futureFetchRes,
        builder: (BuildContext context, AsyncSnapshot<JsonReturn> snapshot) {
          var list = [];
          String totals = "";
          String duration = "";
          Widget title = Container();
          Widget trailing = Container();

          if (snapshot.connectionState == ConnectionState.waiting) {
            trailing = smallProgressIndicator;
          } else if (snapshot.hasError) {
            talker.error(
              "request events faild, error: ${snapshot.error.toString()}",
            );
            trailing = Tooltip(
              message: snapshot.error.toString(),
              child: Text(lang.error),
            );
          } else {
            if (snapshot.data!.error.isNotEmpty) {
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
              final deploymentList =
                  IoK8sApiAppsV1DeploymentList.fromJson(snapshot.data?.body);

              final items = deploymentList?.items;

              totals = lang.items_number(items?.length ?? 0);
              Duration rd = snapshot.data?.duration ?? Duration.zero;
              duration = lang.api_request_duration(rd.prettyMs);
              talker.debug(
                  "length: ${snapshot.data!.body.length},duration: ${duration}ms");

              if (items != null) {
                items.sort(
                  (a, b) {
                    if (a.metadata?.creationTimestamp != null &&
                        b.metadata?.creationTimestamp != null) {
                      return b.metadata!.creationTimestamp!
                          .compareTo(a.metadata!.creationTimestamp!);
                    }
                    return 0;
                  },
                );
              }
              list = items?.mapIndexed(
                    (index, item) {
                      final metadata = item.metadata;
                      final name = metadata?.name ?? '';
                      final ns = metadata?.namespace ?? '-';
                      final status = item.status;
                      final replicas = status?.replicas ?? 0;
                      final ready = status?.readyReplicas ?? 0;
                      final upToDate = status?.updatedReplicas ?? 0;
                      final available = status?.availableReplicas ?? 0;
                      final now = DateTime.now();
                      final ctime = metadata?.creationTimestamp ?? now;
                      final age = now.difference(ctime).pretty;

                      final text = lang.deployment_text(
                          name, ns, ready, upToDate, available);
                      var icon =
                          getStatus(replicas, ready, upToDate, available);

                      final tile = SettingsTile(
                        title: Text(text, style: smallTextStyle),
                        trailing: Row(
                          children: [
                            Text(age),
                            const Divider(indent: 2),
                            icon,
                          ],
                        ),
                      );

                      return metadataSettingsTile(
                        context,
                        tile,
                        item.metadata!.name!,
                        item.metadata!.namespace!,
                        _path,
                        _resource,
                      );
                    },
                  ).toList() ??
                  [];
            }
          }
          talker.debug(
              "list ${list.length}, duration ${snapshot.data?.duration.inMilliseconds} ms");

          return SettingsSection(
            title: Text(lang.deployments + totals + duration),
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
      appBar: AppBar(title: Text(lang.deployments)),
      body: Container(
        margin: bottomEdge,
        child: RefreshIndicator(
          child: SettingsList(
            sections: [
              namespaceFilter(context),
              buildDeploymentList(lang),
            ],
          ),
          onRefresh: () async {
            setState(() {
              _futureFetchRes = _fetchRes();
            });
          },
        ),
      ),
    );
  }
}
