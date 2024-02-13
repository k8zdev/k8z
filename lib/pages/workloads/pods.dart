import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:k8sapp/common/const.dart';
import 'package:k8sapp/common/helpers.dart';
import 'package:k8sapp/common/ops.dart';
import 'package:k8sapp/common/resources/pods.dart';
import 'package:k8sapp/common/styles.dart';
import 'package:k8sapp/dao/kube.dart';
import 'package:k8sapp/generated/l10n.dart';
import 'package:k8sapp/models/models.dart';
import 'package:k8sapp/services/k8z_service.dart';
import 'package:settings_ui/settings_ui.dart';

class PodsPage extends StatefulWidget {
  final K8zCluster cluster;
  const PodsPage({super.key, required this.cluster});

  @override
  State<PodsPage> createState() => _PodsPageState();
}

class _PodsPageState extends State<PodsPage> {
  AbstractSettingsSection buildPodList(S lang) {
    return CustomSettingsSection(
      child: FutureBuilder(
        future: () async {
          // await Future.delayed(const Duration(seconds: 1));
          return await K8zService(cluster: widget.cluster).get("/api/v1/pods");
        }(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          var list = [];
          String totals = "";
          Widget title = Container();
          Widget trailing = Container();

          if (snapshot.connectionState == ConnectionState.waiting) {
            trailing = const SizedBox(
              height: 16,
              width: 16,
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            talker.error(
              "request events faild, error: ${snapshot.error.toString()}",
            );
            trailing = Tooltip(
              message: snapshot.error.toString(),
              child: Text(lang.error),
            );
          } else {
            talker.debug(snapshot.data.body.length);
            final podList = IoK8sApiCoreV1PodList.fromJson(snapshot.data.body);

            var podsItems = podList?.items;

            totals = lang.items_number(podsItems?.length ?? 0);

            if (podsItems != null) {
              podsItems.sort(
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
            list = podsItems?.mapIndexed(
                  (index, pod) {
                    final metadata = pod.metadata;
                    final now = DateTime.now();
                    final creation = metadata?.creationTimestamp ?? now;
                    final age = now.difference(creation).pretty;
                    final (status, icon) = getPodStatus(pod);
                    final ns = metadata?.namespace ?? '-';

                    final spec = pod.spec;
                    final restarts = getRestarts(pod);
                    final resources = getPodResources(pod);
                    final containers =
                        spec?.containers.map((e) => e.name).toList().join(",");
                    final ready =
                        '${pod.status?.containerStatuses.where((containerStatus) => containerStatus.ready).length ?? '0'}/${pod.spec?.containers.length ?? '0'}';

                    final text = lang.pod_text(
                        metadata!.name!,
                        ns,
                        ready,
                        status,
                        restarts,
                        containers!,
                        resources?.cpu ?? "-",
                        resources?.memory ?? "-");

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
            title: Text(lang.pods + totals),
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
      appBar: AppBar(title: Text(lang.pods)),
      body: Container(
        margin: bottomEdge,
        child: SettingsList(sections: [buildPodList(lang)]),
      ),
    );
  }
}
