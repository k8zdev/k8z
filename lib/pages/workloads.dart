import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:k8sapp/generated/l10n.dart';
import 'package:settings_ui/settings_ui.dart';

class WorkloadsPage extends StatefulWidget {
  const WorkloadsPage({super.key});

  @override
  State<WorkloadsPage> createState() => _WorkloadsPageState();
}

class _WorkloadsPageState extends State<WorkloadsPage> {
  @override
  Widget build(BuildContext context) {
    var lang = S.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(lang.workloads)),
      body: SettingsList(
        sections: [
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
            ],
          ),

          //
          SettingsSection(
            title: Text(lang.discovery_and_lb),
            tiles: [
              SettingsTile.navigation(
                title: Text(lang.endpoints),
                onPressed: (context) =>
                    GoRouter.of(context).pushNamed("endpoints"),
              ),
              SettingsTile.navigation(
                title: Text(lang.ingresses),
                onPressed: (context) =>
                    GoRouter.of(context).pushNamed("ingresses"),
              ),
              SettingsTile.navigation(
                title: Text(lang.services),
                onPressed: (context) =>
                    GoRouter.of(context).pushNamed("services"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
