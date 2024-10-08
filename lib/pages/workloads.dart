import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:k8zdev/common/const.dart';
import 'package:k8zdev/dao/kube.dart';
import 'package:k8zdev/generated/l10n.dart';
import 'package:k8zdev/providers/current_cluster.dart';
import 'package:settings_ui/settings_ui.dart';

class WorkloadsPage extends StatefulWidget {
  const WorkloadsPage({super.key});

  @override
  State<WorkloadsPage> createState() => _WorkloadsPageState();
}

class _WorkloadsPageState extends State<WorkloadsPage> {
  late K8zCluster? cluster = CurrentCluster.current;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var lang = S.of(context);
    var sections = [
      //
      SettingsSection(
        title: Text(lang.applications),
        tiles: [
          SettingsTile.navigation(
            title: Text(lang.helm),
            onPressed: (context) =>
                GoRouter.of(context).pushNamed("helm_releases"),
          ),
        ],
      ),

      //
      SettingsSection(
        title: Text(lang.workloads),
        tiles: [
          SettingsTile.navigation(
            title: Text(lang.pods),
            onPressed: (context) => GoRouter.of(context).pushNamed("pods"),
          ),
          SettingsTile.navigation(
            title: Text(lang.daemon_sets),
            onPressed: (context) =>
                GoRouter.of(context).pushNamed("daemon_sets"),
          ),
          SettingsTile.navigation(
            title: Text(lang.deployments),
            onPressed: (context) =>
                GoRouter.of(context).pushNamed("deployments"),
          ),
          SettingsTile.navigation(
            title: Text(lang.stateful_sets),
            onPressed: (context) =>
                GoRouter.of(context).pushNamed("stateful_sets"),
          ),
          SettingsTile.navigation(
            title: Text(lang.replicasets),
            onPressed: (context) =>
                GoRouter.of(context).pushNamed("replicasets"),
          ),
        ],
      ),

      //
      SettingsSection(
        title: Text(lang.discovery_and_lb),
        tiles: [
          SettingsTile.navigation(
            title: Text(lang.endpoints),
            onPressed: (context) => GoRouter.of(context).pushNamed("endpoints"),
          ),
          SettingsTile.navigation(
            title: Text(lang.ingresses),
            onPressed: (context) => GoRouter.of(context).pushNamed("ingresses"),
          ),
          SettingsTile.navigation(
            title: Text(lang.services),
            onPressed: (context) => GoRouter.of(context).pushNamed("services"),
          ),
        ],
      ),
    ];
    return Scaffold(
      appBar: AppBar(title: Text(lang.workloads)),
      body: Container(
        margin: bottomEdge,
        child: SettingsList(sections: sections),
      ),
    );
  }
}
