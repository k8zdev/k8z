import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:k8sapp/generated/l10n.dart';
import 'package:settings_ui/settings_ui.dart';

class ResourcesPage extends StatefulWidget {
  const ResourcesPage({super.key});

  @override
  State<ResourcesPage> createState() => _ResourcesPageState();
}

class _ResourcesPageState extends State<ResourcesPage> {
  AbstractSettingsSection clusterSection(S lang) {
    return SettingsSection(
      title: Text(lang.clusters),
      tiles: [
        SettingsTile.navigation(
          title: Text(lang.nodes),
          onPressed: (context) => GoRouter.of(context).pushNamed("nodes"),
        ),
        SettingsTile.navigation(
          title: Text(lang.events),
          onPressed: (context) => GoRouter.of(context).pushNamed("events"),
        ),
        SettingsTile.navigation(
          title: Text(lang.namespaces),
          onPressed: (context) => GoRouter.of(context).pushNamed("namespaces"),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var lang = S.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(lang.resources)),
      body: SettingsList(
        sections: <AbstractSettingsSection>[
          clusterSection(lang),
        ],
      ),
    );
  }
}
