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
import 'package:settings_ui/settings_ui.dart';

class ConfigMapsPage extends StatefulWidget {
  final K8zCluster cluster;
  const ConfigMapsPage({super.key, required this.cluster});

  @override
  State<ConfigMapsPage> createState() => _ConfigMapsPageState();
}

class _ConfigMapsPageState extends State<ConfigMapsPage> {
  AbstractSettingsSection buildEndpointList(S lang) {
    return CustomSettingsSection(
      child: FutureBuilder(
        future: () async {
          // await Future.delayed(const Duration(seconds: 1));
          return await K8zService(cluster: widget.cluster)
              .get("/api/v1/configmaps");
        }(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          var list = [];
          String totals = "";
          Widget title = const Text("");
          Widget trailing = Text(lang.age);

          if (snapshot.connectionState == ConnectionState.waiting) {
            trailing = const SizedBox(
              height: 16,
              width: 16,
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            talker.error(
              "request services faild, error: ${snapshot.error.toString()}",
            );
            trailing = Tooltip(
              message: snapshot.error.toString(),
              child: Text(lang.error),
            );
          } else {
            talker.debug(
                "length: ${snapshot.data.body.length}, error: ${snapshot.data.error}");
            final data =
                IoK8sApiCoreV1ConfigMapList.fromJson(snapshot.data.body);

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
                    final dataNumber = item.data.length;

                    final now = DateTime.now();
                    final ctime = metadata?.creationTimestamp ?? now;
                    final age = now.difference(ctime).pretty;

                    final text = "$name\nNamespace: $ns\nData: $dataNumber";

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

          talker.debug("list ${list.length}");

          return SettingsSection(
            title: Text(lang.config_maps + totals),
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
      appBar: AppBar(title: Text(lang.config_maps)),
      body: Container(
        padding: bottomEdge,
        child: SettingsList(sections: [buildEndpointList(lang)]),
      ),
    );
  }
}
