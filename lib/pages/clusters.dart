import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:k8zdev/common/const.dart';
import 'package:k8zdev/common/ops.dart';
import 'package:k8zdev/dao/kube.dart';
import 'package:k8zdev/generated/l10n.dart';
import 'package:k8zdev/pages/k8s_list/cluster/create.dart';
import 'package:k8zdev/providers/current_cluster.dart';
import 'package:k8zdev/widgets/overview_metrics.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';

class ClustersPage extends StatefulWidget {
  final int refreshKey;
  const ClustersPage({super.key, this.refreshKey = 0});

  @override
  State<ClustersPage> createState() => _ClustersPageState();
}

class _ClustersPageState extends State<ClustersPage> {
  Future<void> onDeletePress(BuildContext context, K8zCluster cluster) async {
    final lang = S.of(context);
    var ccProvider = Provider.of<CurrentCluster>(context, listen: false);
    showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text(lang.arsure),
            content: Text(
              lang.will_delete(lang.clusters, cluster.name),
            ),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: false,
                child: Text(lang.cancel),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text(lang.ok),
                onPressed: () async {
                  try {
                    if (ccProvider.current?.name == cluster.name) {
                      ccProvider.setCurrent(null);
                    }
                    await K8zCluster.delete(cluster);
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        showCloseIcon: true,
                        closeIconColor: Colors.white,
                        backgroundColor: Colors.green,
                        content: Text(
                          lang.deleted(cluster.name),
                        ),
                      ),
                    );
                  } catch (err) {
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        showCloseIcon: true,
                        closeIconColor: Colors.white,
                        backgroundColor: Colors.red,
                        content: Text(
                          lang.delete_failed(err.toString()),
                        ),
                      ),
                    );
                  }
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop();
                  setState(() {});
                },
              )
            ],
          );
        });
  }

  List<AbstractSettingsTile> genClusterChilds(List<K8zCluster> clusters) {
    final lang = S.of(context);
    var ccProvider = Provider.of<CurrentCluster>(context, listen: false);
    final current = Provider.of<CurrentCluster>(context, listen: false).current;
    return clusters.map((cluster) {
      final tile = SettingsTile.navigation(
        title: Text(
          cluster.name,
          style: const TextStyle(height: 1.5),
        ),
        value: (current?.name == cluster.name) ? const Text("current") : null,
        leading: Icon(Icons.computer,
            color:
                (current?.name == cluster.name) ? Colors.green : Colors.grey),
        onPressed: (context) {
          GoRouter.of(context).pushNamed("cluster_home", extra: cluster);
        },
      );
      return CustomSettingsTile(
        child: Slidable(
          startActionPane: ActionPane(
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                onPressed: (context) async {
                  await onDeletePress(context, cluster);
                },
                backgroundColor: const Color(0xFFFE4A49),
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: lang.delete,
                padding: EdgeInsets.zero,
              ),
              SlidableAction(
                onPressed: (context) async {
                  ccProvider.setCurrent(cluster);
                  setState(() {});
                },
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                icon: Icons.open_in_browser_outlined,
                label: lang.current_cluster,
                padding: EdgeInsets.zero,
              ),
            ],
          ),
          child: tile,
        ),
      );
    }).toList();
  }

  AbstractSettingsSection metrics() {
    var ccProvider = Provider.of<CurrentCluster>(context, listen: false);
    if (ccProvider.current == null) {
      return const CustomSettingsSection(
        child: Center(
          child: Row(children: [
            Icon(Icons.build_circle),
          ]),
        ),
      );
    }
    return CustomSettingsSection(
      child: OverviewMetric(cluster: ccProvider.current!),
    );
  }

  @override
  Widget build(BuildContext context) {
    var lang = S.of(context);

    return FutureBuilder(
      key: ValueKey(context.hashCode),
      future: () async {
        return await K8zCluster.list();
      }(),
      builder: (context, AsyncSnapshot<List<K8zCluster>> snapshot) {
        Widget body = Container();
        var theme = Theme.of(context);
        List<Widget> actions = const [];
        var s = snapshot.connectionState;
        var title = Text(lang.clusters, style: theme.textTheme.titleLarge);
        if (snapshot.hasError) {
          body = Text("Error: ${snapshot.error}");
        } else if (snapshot.hasError) {
          body = Text("Error: ${snapshot.error}");
        } else if (s == ConnectionState.none || s == ConnectionState.waiting) {
          body = const Center(child: CircularProgressIndicator());
        } else {
          List<K8zCluster> clusters = snapshot.data ?? [];
          talker.info("cluster ${clusters.length}");
          if (clusters.isEmpty) {
            title = Text(lang.add_cluster, style: theme.textTheme.titleLarge);
            body = const ClusterCreatePage(hiddenAppBar: true);
          } else {
            actions = [
              IconButton(
                icon: const Icon(Icons.add_box_rounded),
                onPressed: () => GoRouter.of(context).goNamed("create_cluster"),
              ),
            ];
            body = Container(
              padding: EdgeInsets.zero,
              child: SettingsList(
                sections: [
                  metrics(),
                  SettingsSection(
                    tiles: genClusterChilds(clusters),
                  ),
                ],
              ),
            );
          }
        }

        return Scaffold(
          appBar: AppBar(title: title, actions: actions),
          body: Container(
            padding: bottomEdge,
            child: body,
          ),
        );
      },
    );
  }
}
