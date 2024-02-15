import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:k8zdev/common/const.dart';
import 'package:k8zdev/common/helpers.dart';
import 'package:k8zdev/common/ops.dart';
import 'package:k8zdev/dao/kube.dart';
import 'package:k8zdev/generated/l10n.dart';
import 'package:k8zdev/models/models.dart';
import 'package:k8zdev/services/k8z_service.dart';
import 'package:k8zdev/widgets/widgets.dart';
import 'package:settings_ui/settings_ui.dart';

class NamespacesPage extends StatefulWidget {
  final K8zCluster cluster;
  const NamespacesPage({super.key, required this.cluster});

  @override
  State<NamespacesPage> createState() => _NamespacesPageState();
}

class _NamespacesPageState extends State<NamespacesPage> {
  AbstractSettingsSection namespaces(S lang) {
    return CustomSettingsSection(
      child: FutureBuilder(
        future: () async {
          // await Future.delayed(const Duration(seconds: 1));
          return await K8zService(cluster: widget.cluster)
              .get("/api/v1/namespaces?limit=500");
        }(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          var list = [];
          String totals = "";
          var title = Text(lang.name);
          Widget trailing = Text(lang.status);

          if (snapshot.connectionState == ConnectionState.waiting) {
            trailing = const SizedBox(
              height: 16,
              width: 16,
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            talker.error(
              "request namespaces faild, error: ${snapshot.error.toString()}",
            );
            trailing = Tooltip(
              message: snapshot.error.toString(),
              child: Text(lang.error),
            );
          } else {
            final nssList =
                IoK8sApiCoreV1NamespaceList.fromJson(snapshot.data.body);

            totals = lang.items_number(nssList?.items.length ?? 0);

            list = nssList?.items.mapIndexed(
                  (index, ns) {
                    talker.debug("ns: ${ns.metadata}\n");

                    var metadata = ns.metadata;
                    var now = DateTime.now();
                    var creation = metadata?.creationTimestamp ?? now;
                    var age = now.difference(creation).pretty;
                    return SettingsTile(
                      title: Text(metadata?.name ?? "<noe>"),
                      trailing: Row(
                        children: [
                          Text(age),
                          const Divider(indent: 12),
                          ns.status?.phase == "Active"
                              ? runningIcon
                              : errorIcon,
                        ],
                      ),
                    );
                  },
                ).toList() ??
                [];
          }

          talker.debug("list ${list.length}");

          return SettingsSection(
            title: Text(lang.namespaces + totals),
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
      appBar: AppBar(title: Text(lang.namespaces)),
      body: Container(
        margin: bottomEdge,
        child: SettingsList(sections: [namespaces(lang)]),
      ),
    );
  }
}
