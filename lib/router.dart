import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:k8sapp/common/ops.dart';
import 'package:k8sapp/dao/kube.dart';
import 'package:k8sapp/pages/cluster/select_clusters.dart';
import 'package:k8sapp/pages/cluster/create.dart';
import 'package:k8sapp/pages/cluster/create_load_manual.dart';
import 'package:k8sapp/pages/cluster/home.dart';
import 'package:k8sapp/pages/clusters.dart';
import 'package:k8sapp/pages/networks/endpoints.dart';
import 'package:k8sapp/pages/networks/ingresses.dart';
import 'package:k8sapp/pages/networks/services.dart';
import 'package:k8sapp/pages/resources.dart';
import 'package:k8sapp/pages/resources/config/configmaps.dart';
import 'package:k8sapp/pages/resources/config/secrets.dart';
import 'package:k8sapp/pages/resources/config/service_accounts.dart';
import 'package:k8sapp/pages/resources/crds.dart';
import 'package:k8sapp/pages/resources/events.dart';
import 'package:k8sapp/pages/resources/namespaces.dart';
import 'package:k8sapp/pages/resources/nodes.dart';
import 'package:k8sapp/pages/resources/storage/pvcs.dart';
import 'package:k8sapp/pages/resources/storage/pvs.dart';
import 'package:k8sapp/pages/resources/storage/storage_class.dart';
import 'package:k8sapp/pages/workloads.dart';
import 'package:k8sapp/pages/workloads/daemon_sets.dart';
import 'package:k8sapp/pages/workloads/deployments.dart';
import 'package:k8sapp/pages/workloads/pods.dart';
import 'package:k8sapp/pages/workloads/stateful_sets.dart';
import 'package:sqlite_viewer/sqlite_viewer.dart';
import 'package:talker_flutter/talker_flutter.dart';

// pages
import 'pages/landing.dart';
import 'pages/settings.dart';
import 'pages/settings/locale.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'shell');
// GoRouter configuration
final router = GoRouter(
  initialLocation: "/clusters",
  navigatorKey: _rootNavigatorKey,
  debugLogDiagnostics: true,
  observers: [TalkerRouteObserver(talker)],
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return Landing(child: child);
      },
      routes: [
        GoRoute(
          path: "/clusters",
          name: "clusters",
          pageBuilder: (context, state) {
            final key = context.hashCode;
            return NoTransitionPage(
              child: ClustersPage(refreshKey: key),
            );
          },
          routes: [
            GoRoute(
              name: "cluster_home",
              path: "home",
              parentNavigatorKey: _rootNavigatorKey,
              builder: (context, state) {
                var cluster = state.extra as K8zCluster;
                talker.info("goto cluster home, server: ${cluster.server}");
                return ClusterHomePage(cluster: cluster);
              },
            ),
            // add cluster
            GoRoute(
              name: "create_cluster",
              path: "create",
              parentNavigatorKey: _rootNavigatorKey,
              builder: (context, state) {
                return const ClusterCreatePage();
              },
              routes: [
                GoRoute(
                  name: "manual_load",
                  path: "manual",
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) {
                    return const ManualLoadSubPage();
                  },
                ),
              ],
            ),
            GoRoute(
              name: "choice_clusters",
              path: "choice",
              parentNavigatorKey: _rootNavigatorKey,
              builder: (context, state) {
                var clusters = state.extra as List<K8zCluster>;
                talker.debug("clusters: $clusters");
                return ChoiceClustersSubPage(clusters: clusters);
              },
            ),
          ],
        ),
        GoRoute(
          path: "/workloads",
          name: "workloads",
          pageBuilder: (context, state) => const NoTransitionPage(
            child: WorkloadsPage(),
          ),
          routes: [
            // workload
            GoRoute(
              path: "pods",
              name: "pods",
              pageBuilder: (context, state) => const NoTransitionPage(
                child: PodsPage(),
              ),
            ),
            GoRoute(
              path: "daemon_sets",
              name: "daemon_sets",
              pageBuilder: (context, state) => const NoTransitionPage(
                child: DaemonSetsPage(),
              ),
            ),
            GoRoute(
              path: "deployments",
              name: "deployments",
              pageBuilder: (context, state) => const NoTransitionPage(
                child: DeploymentsPage(),
              ),
            ),
            GoRoute(
              path: "stateful_sets",
              name: "stateful_sets",
              pageBuilder: (context, state) => const NoTransitionPage(
                child: StatefulSetsPage(),
              ),
            ),
            // networks
            GoRoute(
              path: "endpoints",
              name: "endpoints",
              pageBuilder: (context, state) => const NoTransitionPage(
                child: EndpointsPage(),
              ),
            ),
            GoRoute(
              path: "ingresses",
              name: "ingresses",
              pageBuilder: (context, state) => const NoTransitionPage(
                child: IngressesPage(),
              ),
            ),
            GoRoute(
              path: "services",
              name: "services",
              pageBuilder: (context, state) => const NoTransitionPage(
                child: ServicesPage(),
              ),
            ),
          ],
        ),
        GoRoute(
          path: "/resources",
          name: "resources",
          pageBuilder: (context, state) => const NoTransitionPage(
            child: ResourcesPage(),
          ),
          routes: [
            // cluster group
            GoRoute(
              path: "nodes",
              name: "nodes",
              pageBuilder: (context, state) {
                var cluster = state.extra as K8zCluster;
                return NoTransitionPage(
                  child: NodesPage(cluster: cluster),
                );
              },
            ),
            GoRoute(
              path: "namespaces",
              name: "namespaces",
              pageBuilder: (context, state) => const NoTransitionPage(
                child: NamespacesPage(),
              ),
            ),
            GoRoute(
              path: "events",
              name: "events",
              pageBuilder: (context, state) => const NoTransitionPage(
                child: EventsPage(),
              ),
            ),
            GoRoute(
              path: "crds",
              name: "crds",
              pageBuilder: (context, state) => const NoTransitionPage(
                child: CrdsPage(),
              ),
            ),
            // config group
            GoRoute(
              path: "config_maps",
              name: "config_maps",
              pageBuilder: (context, state) => const NoTransitionPage(
                child: ConfigMapsPage(),
              ),
            ),
            GoRoute(
              path: "secrets",
              name: "secrets",
              pageBuilder: (context, state) => const NoTransitionPage(
                child: SecretsPage(),
              ),
            ),
            GoRoute(
              path: "service_accounts",
              name: "service_accounts",
              pageBuilder: (context, state) => const NoTransitionPage(
                child: ServiceAccountsPage(),
              ),
            ),
            // storage group
            GoRoute(
              path: "storage_class",
              name: "storage_class",
              pageBuilder: (context, state) => const NoTransitionPage(
                child: StorageClassPage(),
              ),
            ),
            GoRoute(
              path: "pvs",
              name: "pvs",
              pageBuilder: (context, state) => const NoTransitionPage(
                child: PvsPage(),
              ),
            ),
            GoRoute(
              path: "pvcs",
              name: "pvcs",
              pageBuilder: (context, state) => const NoTransitionPage(
                child: PvcsPage(),
              ),
            ),
          ],
        ),
        GoRoute(
          path: "/settings",
          name: "settings",
          pageBuilder: (context, state) => const NoTransitionPage(
            child: SettingsPage(),
          ),
          routes: [
            GoRoute(
                name: "locale",
                path: "general/locale",
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) {
                  return const LocaleSettingPage();
                }),
            GoRoute(
              name: "sqlview",
              path: "debug/sqlview",
              parentNavigatorKey: _rootNavigatorKey,
              builder: (context, state) => const DatabaseList(),
            ),
            GoRoute(
              name: "talker",
              path: "debug/talker",
              parentNavigatorKey: _rootNavigatorKey,
              builder: (context, state) => TalkerScreen(
                talker: talker,
              ),
            ),
          ],
        ),
      ],
    ),
  ],
);
