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
import 'package:k8zdev/services/k8z_service.dart';
import 'package:k8zdev/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';

class StatefulSetsPage extends StatefulWidget {
  final K8zCluster cluster;
  const StatefulSetsPage({super.key, required this.cluster});

  @override
  State<StatefulSetsPage> createState() => _StatefulSetsPageState();
}

class _StatefulSetsPageState extends State<StatefulSetsPage> {
  Widget getStatus(int replicas, int ready, int upToDate) {
    if (replicas == 0 || ready == 0 || upToDate == 0) {
      return quizIcon;
    }

    if (replicas == ready && replicas == upToDate) {
      return runningIcon;
    }

    return errorIcon;
  }

  AbstractSettingsSection buildStatefulSetList(S lang) {
    return CustomSettingsSection(
      child: FutureBuilder(
        future: () async {
          final c = Provider.of<CurrentCluster>(context, listen: true).current;
          final namespaced = c?.namespace.isEmpty ?? true
              ? ""
              : "/namespaces/${c?.namespace ?? ""}";

          // await Future.delayed(const Duration(seconds: 1));
          return await K8zService(cluster: widget.cluster)
              .get("/apis/apps/v1$namespaced/statefulsets");
        }(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          var list = [];
          String totals = "";
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
            talker.debug(
                "length: ${snapshot.data.body.length}, error: ${snapshot.data.error}");
            final dataList =
                IoK8sApiAppsV1StatefulSetList.fromJson(snapshot.data.body);

            final items = dataList?.items;

            totals = lang.items_number(items?.length ?? 0);

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

                    final text = lang.stateful_set_text(
                        name, ns, ready, upToDate, available);
                    var icon = getStatus(replicas, ready, upToDate);

                    return SettingsTile(
                      title: Text(text, style: smallTextStyle),
                      trailing: Row(
                        children: [
                          Text(age),
                          const Divider(indent: 2),
                          icon,
                        ],
                      ),
                    );
                  },
                ).toList() ??
                [];
          }

          talker.debug("list ${list.length}");

          return SettingsSection(
            title: Text(lang.stateful_sets + totals),
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
      appBar: AppBar(title: Text(lang.stateful_sets)),
      body: Container(
        margin: bottomEdge,
        child: SettingsList(sections: [buildStatefulSetList(lang)]),
      ),
    );
  }
}
