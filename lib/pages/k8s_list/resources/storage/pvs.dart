import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:k8zdev/common/const.dart';
import 'package:k8zdev/common/helpers.dart';
import 'package:k8zdev/common/ops.dart';
import 'package:k8zdev/common/styles.dart';
import 'package:k8zdev/dao/kube.dart';
import 'package:k8zdev/generated/l10n.dart';
import 'package:k8zdev/models/models.dart';
import 'package:k8zdev/services/k8z_native.dart';
import 'package:k8zdev/services/k8z_service.dart';
import 'package:k8zdev/widgets/settings_tile.dart';
import 'package:settings_ui/settings_ui.dart';

class PvsPage extends StatefulWidget {
  final K8zCluster cluster;
  const PvsPage({super.key, required this.cluster});

  @override
  State<PvsPage> createState() => _PvsPageState();
}

class _PvsPageState extends State<PvsPage> {
  final String _path = "/api/v1";
  final String _resource = "persistentvolumes";
  late Future<JsonReturn> _futureFetchRes;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      _futureFetchRes =
          fetchCurrentRes(context, _path, _resource, namespaced: false);
    });
  }

  AbstractSettingsSection buildPvList(S lang) {
    return CustomSettingsSection(
      child: FutureBuilder(
        future: _futureFetchRes,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          var list = [];
          String totals = "";
          String duration = "";
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
              "request secrets faild, error: ${snapshot.error.toString()}",
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
              final data = IoK8sApiCoreV1PersistentVolumeList.fromJson(
                  snapshot.data.body);

              final items = data?.items;

              totals = lang.items_number(items?.length ?? 0);
              Duration rd = snapshot.data.duration;
              duration = lang.api_request_duration(rd.prettyMs);

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
                      final capacity = item.spec?.capacity['storage'] ?? "";
                      final accessModes =
                          item.spec?.accessModes.join(',') ?? "";
                      final reclaimPolicy =
                          item.spec?.persistentVolumeReclaimPolicy ?? "";
                      final status = item.status?.phase ?? "";
                      final claim =
                          "${item.spec?.claimRef?.namespace}/${item.spec?.claimRef?.name}";
                      final storageClass = item.spec?.storageClassName ?? "";
                      final reason = item.status?.reason ?? "";

                      final now = DateTime.now();
                      final ctime = metadata?.creationTimestamp ?? now;
                      final age = now.difference(ctime).pretty;

                      final text = lang.pv_text(name, capacity, accessModes,
                          reclaimPolicy, status, claim, storageClass, reason);

                      final tile = SettingsTile(
                        title: Text(text, style: smallTextStyle),
                        trailing: Row(
                          children: [
                            Text(age),
                            const Divider(indent: 2),
                          ],
                        ),
                      );

                      return metadataSettingsTile(
                        context,
                        tile,
                        item.metadata!.name!,
                        item.metadata!.namespace,
                        _path,
                        _resource,
                      );
                    },
                  ).toList() ??
                  [];
            }
          }
          talker.debug("list ${list.length}");

          return SettingsSection(
            title: Text(lang.pvs + totals + duration),
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
      appBar: AppBar(title: Text(lang.pvs)),
      body: Container(
        padding: bottomEdge,
        child: RefreshIndicator(
          child: SettingsList(sections: [buildPvList(lang)]),
          onRefresh: () async => setState(() {
            _futureFetchRes = fetchCurrentRes(context, _path, _resource,
                namespaced: false, listen: false);
          }),
        ),
      ),
    );
  }
}
