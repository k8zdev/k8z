import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:k8sapp/common/ops.dart';
import 'package:k8sapp/dao/kube.dart';
import 'package:k8sapp/generated/l10n.dart';
import 'package:k8sapp/pages/cluster/create.dart';
import 'package:k8sapp/providers/current_cluster.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';

class ClustersPage extends StatefulWidget {
  final int refreshKey;
  const ClustersPage({super.key, this.refreshKey = 0});

  @override
  State<ClustersPage> createState() => _ClustersPageState();
}

class _ClustersPageState extends State<ClustersPage> {
  List<AbstractSettingsTile> genClusterChilds(List<K8zCluster> clusters) {
    final current = Provider.of<CurrentCluster>(context, listen: false).current;
    return clusters.map((cluster) {
      return SettingsTile.navigation(
        title: Text(cluster.name),
        leading: Icon(Icons.computer,
            color: (current == cluster.name) ? Colors.green : Colors.grey),
        onPressed: (context) {
          GoRouter.of(context).pushNamed("cluster_home", extra: cluster);
        },
      );
    }).toList();
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
                  SettingsSection(
                    tiles: genClusterChilds(clusters),
                  ),
                ],
              ),
            );
          }
        }

        return Scaffold(
          body: Container(
            padding: const EdgeInsets.only(bottom: 60),
            child: body,
          ),
          appBar: AppBar(title: title, actions: actions),
        );
      },
    );
  }
}
