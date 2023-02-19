import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:k8zdev/common/const.dart';
import 'package:k8zdev/common/helpers.dart';
import 'package:k8zdev/common/ops.dart';
import 'package:k8zdev/common/styles.dart';
import 'package:k8zdev/dao/kube.dart';
import 'package:k8zdev/generated/l10n.dart';
import 'package:k8zdev/models/models.dart';
import 'package:k8zdev/services/k8z_service.dart';
import 'package:k8zdev/widgets/widgets.dart';
import 'package:settings_ui/settings_ui.dart';

class IngressesPage extends StatefulWidget {
  final K8zCluster cluster;
  const IngressesPage({super.key, required this.cluster});

  @override
  State<IngressesPage> createState() => _IngressesPageState();
}

class _IngressesPageState extends State<IngressesPage> {
  Widget getStatus(String? hosts, String? address) {
    return (hosts == null ||
            hosts.isEmpty ||
            address == null ||
            address.isEmpty)
        ? quizIcon
        : runningIcon;
  }

  AbstractSettingsSection buildIngressList(S lang) {
    return CustomSettingsSection(
      child: FutureBuilder(
        future: () async {
          // await Future.delayed(const Duration(seconds: 1));
          return await K8zService(cluster: widget.cluster)
              .get("/apis/networking.k8s.io/v1/ingresses");
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
              "request ingresses faild, error: ${snapshot.error.toString()}",
            );
            trailing = Tooltip(
              message: snapshot.error.toString(),
              child: Text(lang.error),
            );
          } else {
            talker.debug(
                "length: ${snapshot.data.body.length}, error: ${snapshot.data.error}");
            final daemonSetList =
                IoK8sApiNetworkingV1IngressList.fromJson(snapshot.data.body);

            final items = daemonSetList?.items;

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
                    final spec = item.spec;

                    final hosts = spec?.rules.map((e) => e.host).join(',');
                    final ports = spec?.rules
                        .map(
                          (e) => e.http?.paths.map(
                            (e2) =>
                                "${e2.backend.service?.port?.number.toString()}",
                          ),
                        )
                        .join(',');
                    final className = spec?.ingressClassName ?? '-';
                    final address = item.status?.loadBalancer?.ingress
                        .map((e) => e.ip)
                        .join(',');

                    final now = DateTime.now();
                    final ctime = metadata?.creationTimestamp ?? now;
                    final age = now.difference(ctime).pretty;

                    final text = lang.ingress_text(name, ns, className,
                        hosts ?? '-', address ?? '-', ports ?? '-');
                    final icon = getStatus(hosts, address);

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
            title: Text(lang.ingresses + totals),
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
      appBar: AppBar(title: Text(lang.ingresses)),
      body: Container(
        margin: bottomEdge,
        child: SettingsList(sections: [buildIngressList(lang)]),
      ),
    );
  }
}
