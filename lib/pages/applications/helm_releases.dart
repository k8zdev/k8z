import 'dart:convert';

import 'package:archive/archive_io.dart';
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
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';

class HelmReleasesPage extends StatefulWidget {
  final K8zCluster cluster;
  const HelmReleasesPage({super.key, required this.cluster});

  @override
  State<HelmReleasesPage> createState() => _HelmReleasesPageState();
}

class _HelmReleasesPageState extends State<HelmReleasesPage> {
  AbstractSettingsSection buildHelmReleasesList(S lang) {
    return CustomSettingsSection(
      child: FutureBuilder(
        future: () async {
          final c = Provider.of<CurrentCluster>(context, listen: true).current;
          final namespaced = c?.namespace.isEmpty ?? true
              ? ""
              : "/namespaces/${c?.namespace ?? ""}";

          // await Future.delayed(const Duration(seconds: 1));
          return await K8zService(context, cluster: widget.cluster)
              .get("/api/v1$namespaced/secrets?labelSelector=owner%3Dhelm");
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
              final data =
                  IoK8sApiCoreV1SecretList.fromJson(snapshot.data.body);

              final items = data?.items;

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

              final groupedItems =
                  groupBy(items!.toSet(), (IoK8sApiCoreV1Secret item) {
                final metadata = item.metadata;
                final labels = metadata?.labels;
                return labels?['name'] ?? '';
              });

              List<IoK8sApiCoreV1Secret> uniqueItems = [];

              groupedItems.forEach((key, value) {
                value.sort((a, b) => b.metadata!.labels['version']!
                    .compareTo(a.metadata!.labels['version'] ?? '0'));
                uniqueItems.add(value.first);
              });
              totals = lang.items_number(uniqueItems.length);

              list = uniqueItems.mapIndexed(
                (index, item) {
                  final metadata = item.metadata;
                  final labels = metadata?.labels;
                  final name = labels?['name'] ?? '';
                  final status = labels?['status'] ?? '';
                  final revision = labels?['version'] ?? '';
                  final ns = metadata?.namespace ?? '-';
                  final releaseRaw = base64.decode(item.data['release'] ?? '');
                  final releaseData = base64.decode(utf8.decode(releaseRaw));
                  final release =
                      utf8.decode(GZipDecoder().decodeBytes(releaseData));
                  final releaseJson = json.decode(release);
                  final String releaseUpdated =
                      releaseJson?['info']['last_deployed'] ?? "";
                  var chartMeta = releaseJson?['chart']['metadata'];
                  final String releaseChart =
                      "${chartMeta['name']}-${chartMeta['version']}";
                  final String releaseAppVersion =
                      chartMeta['appVersion'] ?? "";

                  final now = DateTime.now();
                  final ctime = metadata?.creationTimestamp ?? now;
                  final age = now.difference(ctime).pretty;

                  final text = lang.release_text(name, ns, revision,
                      releaseAppVersion, releaseUpdated, status, releaseChart);

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
              ).toList();
              // list = [];
            }
          }
          talker.debug("list ${list.length}");

          return SettingsSection(
            title: Text(lang.releases + totals),
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
      appBar: AppBar(title: Text(lang.releases)),
      body: Container(
        padding: bottomEdge,
        child: SettingsList(
          sections: [
            namespaceFilter(context),
            buildHelmReleasesList(lang),
          ],
        ),
      ),
    );
  }
}
