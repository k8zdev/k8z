import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:k8zdev/common/helpers.dart';
import 'package:k8zdev/common/ops.dart';
import 'package:k8zdev/dao/kube.dart';
import 'package:k8zdev/generated/l10n.dart';
import 'package:k8zdev/models/models.dart';
import 'package:k8zdev/providers/current_cluster.dart';
import 'package:k8zdev/services/k8z_service.dart';
import 'package:k8zdev/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';

AbstractSettingsSection namespaceFilter(BuildContext context) {
  final lang = S.of(context);
  final cluster = CurrentCluster.current;

  return SettingsSection(tiles: [
    SettingsTile.navigation(
      title: Text(lang.namespaces),
      onPressed: (context) => showCurrentNamespace(context, cluster),
      value: Text(cluster!.namespace.isEmpty ? lang.all : cluster.namespace),
    ),
  ]);
}

void showCurrentNamespace(BuildContext context, K8zCluster? cluster) {
  showModalBottomSheet(
    context: context,
    isDismissible: true,
    showDragHandle: true,
    useRootNavigator: true,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
    ),
    builder: (BuildContext context) {
      return CurrentNamespace(cluster: cluster!);
    },
  );
}

class CurrentNamespace extends StatelessWidget {
  final K8zCluster cluster;
  const CurrentNamespace({super.key, required this.cluster});

  AbstractSettingsSection namespaces(
      BuildContext context, S lang, CurrentCluster ccProvider) {
    return CustomSettingsSection(
      child: FutureBuilder(
        future: () async {
          // await Future.delayed(const Duration(seconds: 1));
          return await K8zService(context, cluster: cluster)
              .get("/api/v1/namespaces?limit=500");
        }(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          var list = [];
          String totals = "";
          String duration = "";
          var title = Text(lang.name);
          Widget trailing = Text(lang.status);

          if (snapshot.connectionState == ConnectionState.waiting) {
            trailing = smallProgressIndicator;
          } else if (snapshot.hasError) {
            talker.error(
              "request namespaces faild, error: ${snapshot.error.toString()}",
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
              final nssList =
                  IoK8sApiCoreV1NamespaceList.fromJson(snapshot.data.body);

              totals = lang.items_number(nssList?.items.length ?? 0);
              Duration rd = snapshot.data.duration;
              duration = lang.api_request_duration(rd.prettyMs);

              list = nssList?.items.mapIndexed(
                    (index, ns) {
                      talker.debug("ns: ${ns.metadata}\n");
                      var name = ns.metadata?.name ?? "";
                      return SettingsTile(
                        title: Text(name),
                        trailing: Radio(
                          value: name,
                          groupValue: cluster.namespace,
                          onChanged: (value) {
                            ccProvider.updateNamespace(value);

                            Navigator.pop(context);
                          },
                        ),
                      );
                    },
                  ).toList() ??
                  [];
            }
          }

          talker.debug("list ${list.length}");

          return SettingsSection(
            title: Text(lang.namespaces + totals + duration),
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
    final lang = S.of(context);
    final ccProvider = Provider.of<CurrentCluster>(context, listen: true);
    return Container(
      constraints: BoxConstraints(
        minHeight: 400,
        minWidth: MediaQuery.of(context).size.width,
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      child: SettingsList(
        sections: [
          SettingsSection(
            tiles: [
              SettingsTile(
                title: Text(lang.all),
                trailing: Radio(
                  value: "",
                  groupValue: cluster.namespace,
                  onChanged: (value) {
                    ccProvider.updateNamespace("");
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
          //
          namespaces(context, lang, ccProvider),
        ],
      ),
    );
  }
}
