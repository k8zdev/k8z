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
import 'package:k8zdev/widgets/namespace.dart';
import 'package:k8zdev/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';

class EndpointsPage extends StatefulWidget {
  final K8zCluster cluster;
  const EndpointsPage({super.key, required this.cluster});

  @override
  State<EndpointsPage> createState() => _EndpointsPageState();
}

class _EndpointsPageState extends State<EndpointsPage> {
  AbstractSettingsSection buildEndpointList(S lang) {
    return CustomSettingsSection(
      child: FutureBuilder(
        future: () async {
          final c = Provider.of<CurrentCluster>(context, listen: true).current;
          final namespaced = c?.namespace.isEmpty ?? true
              ? ""
              : "/namespaces/${c?.namespace ?? ""}";

          // await Future.delayed(const Duration(seconds: 1));
          return await K8zService(context, cluster: widget.cluster)
              .get("/api/v1$namespaced/services");
        }(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          var list = [];
          String totals = "";
          Widget title = const Text("");
          Widget trailing = Text(lang.age);

          if (snapshot.connectionState == ConnectionState.waiting) {
            trailing = smallProgressIndicator;
          } else if (snapshot.hasError) {
            talker.error(
              "request services faild, error: ${snapshot.error.toString()}",
            );
            trailing = Tooltip(
              message: snapshot.error.toString(),
              child: Text(lang.error),
            );
          } else {
            if (snapshot.data.error.isNotEmpty) {
              trailing = Container();
              title = Text(lang.error);
              list = [
                SettingsTile(
                  title: Text(
                    snapshot.data.error,
                    style: const TextStyle(color: Colors.grey),
                  ),
                )
              ];
            } else {
              talker.debug(
                  "length: ${snapshot.data.body.length}, error: ${snapshot.data.error}");
              final data =
                  IoK8sApiCoreV1EndpointsList.fromJson(snapshot.data.body);

              final items = data?.items;

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
                      final ips = item.subsets
                          .map((subset) => subset.addresses
                              .map((address) => address.ip)
                              .toList())
                          .expand((e) => e)
                          .toList();

                      final now = DateTime.now();
                      final ctime = metadata?.creationTimestamp ?? now;
                      final age = now.difference(ctime).pretty;

                      final text = lang.endpoint_text(name, ns, ips.join(", "));

                      return SettingsTile(
                        title: Text(text, style: smallTextStyle),
                        trailing: Row(
                          children: [
                            Text(age),
                            const Divider(indent: 2),
                          ],
                        ),
                      );
                    },
                  ).toList() ??
                  [];
            }
          }
          talker.debug("list ${list.length}");

          return SettingsSection(
            title: Text(lang.endpoints + totals),
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
      appBar: AppBar(title: Text(lang.endpoints)),
      body: Container(
        padding: bottomEdge,
        child: SettingsList(
          sections: [
            namespaceFilter(context),
            buildEndpointList(lang),
          ],
        ),
      ),
    );
  }
}
