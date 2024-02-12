import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:k8sapp/dao/kube.dart';
import 'package:k8sapp/generated/l10n.dart';
import 'package:k8sapp/providers/current_cluster.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';

class ResourcesPage extends StatefulWidget {
  const ResourcesPage({super.key});

  @override
  State<ResourcesPage> createState() => _ResourcesPageState();
}

class _ResourcesPageState extends State<ResourcesPage> {
  late K8zCluster? cluster;

  @override
  void initState() {
    cluster = Provider.of<CurrentCluster>(context, listen: false).current;
    super.initState();
  }

  AbstractSettingsSection clusterSection(S lang) {
    return SettingsSection(
      title: Text(lang.clusters),
      tiles: [
        SettingsTile.navigation(
          title: Text(lang.nodes),
          onPressed: (context) =>
              GoRouter.of(context).pushNamed("nodes", extra: cluster),
        ),
        SettingsTile.navigation(
          title: Text(lang.events),
          onPressed: (context) => GoRouter.of(context).pushNamed(
            "events",
            extra: cluster,
          ),
        ),
        SettingsTile.navigation(
          title: Text(lang.namespaces),
          onPressed: (context) => GoRouter.of(context).pushNamed(
            "namespaces",
            extra: cluster,
          ),
        ),
        SettingsTile.navigation(
          title: Text(lang.crds),
          onPressed: (context) => GoRouter.of(context).pushNamed(
            "crds",
            extra: cluster,
          ),
        ),
      ],
    );
  }

  AbstractSettingsSection configSection(S lang) {
    return SettingsSection(
      title: Text(lang.config),
      tiles: [
        SettingsTile.navigation(
          title: Text(lang.config_maps),
          onPressed: (context) => GoRouter.of(context).pushNamed("config_maps"),
        ),
        SettingsTile.navigation(
          title: Text(lang.secrets),
          onPressed: (context) => GoRouter.of(context).pushNamed("secrets"),
        ),
        SettingsTile.navigation(
          title: Text(lang.service_accounts),
          onPressed: (context) =>
              GoRouter.of(context).pushNamed("service_accounts"),
        ),
      ],
    );
  }

  AbstractSettingsSection storageSection(S lang) {
    return SettingsSection(
      title: Text(lang.storage),
      tiles: [
        SettingsTile.navigation(
          title: Text(lang.storage_class),
          onPressed: (context) =>
              GoRouter.of(context).pushNamed("storage_class"),
        ),
        SettingsTile.navigation(
          title: Text(lang.pvs),
          onPressed: (context) => GoRouter.of(context).pushNamed("pvs"),
        ),
        SettingsTile.navigation(
          title: Text(lang.pvcs),
          onPressed: (context) => GoRouter.of(context).pushNamed("pvcs"),
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
          configSection(lang),
          storageSection(lang),
        ],
      ),
    );
  }
}
