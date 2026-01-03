import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:k8zdev/common/const.dart';
import 'package:k8zdev/common/ops.dart';
import 'package:k8zdev/dao/kube.dart';
import 'package:k8zdev/generated/l10n.dart';
import 'package:k8zdev/models/guide_keys.dart';
import 'package:k8zdev/pages/k8s_list/cluster/create.dart';
import 'package:k8zdev/providers/current_cluster.dart';
import 'package:k8zdev/widgets/overview_metrics.dart';
import 'package:k8zdev/widgets/demo_cluster_indicator.dart';
import 'package:k8zdev/services/onboarding_guide_service.dart';
import 'package:k8zdev/services/demo_cluster_service.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';

class ClustersPage extends StatefulWidget {
  final int refreshKey;
  const ClustersPage({super.key, this.refreshKey = 0});

  @override
  State<ClustersPage> createState() => _ClustersPageState();
}

class _ClustersPageState extends State<ClustersPage> {
  bool _guideTriggered = false;

  /// Start onboarding guide if demo cluster exists and guide is not completed
  Future<void> _checkAndStartGuide(List<K8zCluster> clusters) async {
    if (_guideTriggered) return;

    // Check if there's a demo cluster
    final demoCluster = clusters.firstWhereOrNull(
      (c) => DemoClusterService.isDemoCluster(c),
    );

    if (demoCluster == null) return;

    final guideService = Provider.of<OnboardingGuideService>(
      context,
      listen: false,
    );

    // Don't start if guide is already active
    if (guideService.isGuideActive) {
      return;
    }

    // Only start guide if not already completed
    final isCompleted = await guideService.isGuideCompleted(
      clusterId: demoCluster.server,
    );

    if (!isCompleted) {
      talker.info('[BDD] Starting onboarding guide from cluster list page');
      _guideTriggered = true;
      await guideService.startGuide(demoCluster);
    }
  }
  Future<void> onDeletePress(BuildContext context, K8zCluster cluster) async {
    final lang = S.of(context);
    final current = CurrentCluster.current;
    final ccProvider = Provider.of<CurrentCluster>(context, listen: false);
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
                    if (current!.name == cluster.name) {
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
    final current = CurrentCluster.current;
    final ccProvider = Provider.of<CurrentCluster>(context, listen: false);
    return clusters.map((cluster) {
      final tile = SettingsTile.navigation(
        title: Row(
          children: [
            Expanded(
              child: Text(
                cluster.name,
                style: const TextStyle(height: 1.5),
              ),
            ),
            if (cluster.isDemo || cluster.isReadOnly) ...[
              const SizedBox(width: 8),
              DemoClusterIndicator(
                isDemo: cluster.isDemo,
                isReadOnly: cluster.isReadOnly,
              ),
            ],
          ],
        ),
        value: (current?.name == cluster.name) ? const Text("current") : null,
        leading: Icon(
          cluster.isDemo ? Icons.play_circle_outline : Icons.computer,
          color: (current?.name == cluster.name) ? Colors.green : 
                 cluster.isDemo ? Colors.orange : Colors.grey,
        ),
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
    if (CurrentCluster.current == null) {
      final lang = S.current;
      return CustomSettingsSection(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.not_interested_rounded,
                color: Colors.grey,
                size: 28,
              ),
              Text(lang.no_current_cluster),
            ],
          ),
          // child: Icon(Icons.access_alarms),
        ),
      );
    }
    return CustomSettingsSection(
      child: OverviewMetric(cluster: CurrentCluster.current!),
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

          // Trigger onboarding guide if demo cluster exists
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _checkAndStartGuide(clusters);
          });

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
              key: GuideKeys.completedTargetKey,
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
