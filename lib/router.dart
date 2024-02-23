import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:k8zdev/common/ops.dart';
import 'package:k8zdev/dao/kube.dart';
import 'package:k8zdev/generated/l10n.dart';
import 'package:k8zdev/pages/applications/helm_releases.dart';
import 'package:k8zdev/pages/cluster/select_clusters.dart';
import 'package:k8zdev/pages/cluster/create.dart';
import 'package:k8zdev/pages/cluster/create_load_manual.dart';
import 'package:k8zdev/pages/cluster/home.dart';
import 'package:k8zdev/pages/clusters.dart';
import 'package:k8zdev/pages/networks/endpoints.dart';
import 'package:k8zdev/pages/networks/ingresses.dart';
import 'package:k8zdev/pages/networks/services.dart';
import 'package:k8zdev/pages/not_found.dart';
import 'package:k8zdev/pages/paywalls/appstore_sponsors.dart';
import 'package:k8zdev/pages/resources.dart';
import 'package:k8zdev/pages/resources/config/configmaps.dart';
import 'package:k8zdev/pages/resources/config/secrets.dart';
import 'package:k8zdev/pages/resources/config/service_accounts.dart';
import 'package:k8zdev/pages/resources/crds.dart';
import 'package:k8zdev/pages/resources/events.dart';
import 'package:k8zdev/pages/resources/namespaces.dart';
import 'package:k8zdev/pages/resources/nodes.dart';
import 'package:k8zdev/pages/resources/storage/pvcs.dart';
import 'package:k8zdev/pages/resources/storage/pvs.dart';
import 'package:k8zdev/pages/resources/storage/storage_class.dart';
import 'package:k8zdev/pages/workloads.dart';
import 'package:k8zdev/pages/workloads/daemon_sets.dart';
import 'package:k8zdev/pages/workloads/deployments.dart';
import 'package:k8zdev/pages/workloads/pods.dart';
import 'package:k8zdev/pages/workloads/stateful_sets.dart';
import 'package:k8zdev/providers/current_cluster.dart';
import 'package:provider/provider.dart';
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
          pageBuilder: (context, state) {
            var lang = S.current;
            var ccProvider = Provider.of<CurrentCluster>(context);
            if (ccProvider.current == null) {
              return NoTransitionPage(
                child: NotFoundPage(
                  title: lang.workloads,
                  info: lang.no_current_cluster,
                ),
              );
            }
            return const NoTransitionPage(
              child: WorkloadsPage(),
            );
          },
          routes: [
            // apps
            GoRoute(
              path: "helm_releases",
              name: "helm_releases",
              pageBuilder: (context, state) {
                var cluster = state.extra as K8zCluster;
                return NoTransitionPage(
                  child: HelmReleasesPage(cluster: cluster),
                );
              },
            ),
            // workload
            GoRoute(
              path: "pods",
              name: "pods",
              pageBuilder: (context, state) {
                var cluster = state.extra as K8zCluster;
                return NoTransitionPage(
                  child: PodsPage(cluster: cluster),
                );
              },
            ),
            GoRoute(
              path: "daemon_sets",
              name: "daemon_sets",
              pageBuilder: (context, state) {
                var cluster = state.extra as K8zCluster;
                return NoTransitionPage(
                  child: DaemonSetsPage(cluster: cluster),
                );
              },
            ),
            GoRoute(
              path: "deployments",
              name: "deployments",
              pageBuilder: (context, state) {
                var cluster = state.extra as K8zCluster;
                return NoTransitionPage(
                  child: DeploymentsPage(cluster: cluster),
                );
              },
            ),
            GoRoute(
              path: "stateful_sets",
              name: "stateful_sets",
              pageBuilder: (context, state) {
                var cluster = state.extra as K8zCluster;
                return NoTransitionPage(
                  child: StatefulSetsPage(cluster: cluster),
                );
              },
            ),
            // networks
            GoRoute(
              path: "endpoints",
              name: "endpoints",
              pageBuilder: (context, state) {
                var cluster = state.extra as K8zCluster;
                return NoTransitionPage(
                  child: EndpointsPage(cluster: cluster),
                );
              },
            ),
            GoRoute(
              path: "ingresses",
              name: "ingresses",
              pageBuilder: (context, state) {
                var cluster = state.extra as K8zCluster;
                return NoTransitionPage(
                  child: IngressesPage(cluster: cluster),
                );
              },
            ),
            GoRoute(
              path: "services",
              name: "services",
              pageBuilder: (context, state) {
                var cluster = state.extra as K8zCluster;
                return NoTransitionPage(
                  child: ServicesPage(cluster: cluster),
                );
              },
            ),
          ],
        ),
        GoRoute(
          path: "/resources",
          name: "resources",
          pageBuilder: (context, state) {
            var lang = S.current;
            var ccProvider = Provider.of<CurrentCluster>(context);
            if (ccProvider.current == null) {
              return NoTransitionPage(
                child: NotFoundPage(
                  title: lang.resources,
                  info: lang.no_current_cluster,
                ),
              );
            }
            return const NoTransitionPage(
              child: ResourcesPage(),
            );
          },
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
                pageBuilder: (context, state) {
                  var cluster = state.extra as K8zCluster;
                  return NoTransitionPage(
                    child: NamespacesPage(cluster: cluster),
                  );
                }),
            GoRoute(
              path: "events",
              name: "events",
              pageBuilder: (context, state) {
                var cluster = state.extra as K8zCluster;
                return NoTransitionPage(
                  child: EventsPage(cluster: cluster),
                );
              },
            ),
            GoRoute(
              path: "crds",
              name: "crds",
              pageBuilder: (context, state) {
                var cluster = state.extra as K8zCluster;
                return NoTransitionPage(
                  child: CrdsPage(cluster: cluster),
                );
              },
            ),
            // config group
            GoRoute(
              path: "config_maps",
              name: "config_maps",
              pageBuilder: (context, state) {
                var cluster = state.extra as K8zCluster;
                return NoTransitionPage(
                  child: ConfigMapsPage(cluster: cluster),
                );
              },
            ),
            GoRoute(
              path: "secrets",
              name: "secrets",
              pageBuilder: (context, state) {
                var cluster = state.extra as K8zCluster;
                return NoTransitionPage(
                  child: SecretsPage(cluster: cluster),
                );
              },
            ),
            GoRoute(
              path: "service_accounts",
              name: "service_accounts",
              pageBuilder: (context, state) {
                var cluster = state.extra as K8zCluster;
                return NoTransitionPage(
                  child: ServiceAccountsPage(cluster: cluster),
                );
              },
            ),
            // storage group
            GoRoute(
              path: "storage_class",
              name: "storage_class",
              pageBuilder: (context, state) {
                var cluster = state.extra as K8zCluster;
                return NoTransitionPage(
                  child: StorageClassPage(cluster: cluster),
                );
              },
            ),
            GoRoute(
              path: "pvs",
              name: "pvs",
              pageBuilder: (context, state) {
                var cluster = state.extra as K8zCluster;
                return NoTransitionPage(
                  child: PvsPage(cluster: cluster),
                );
              },
            ),
            GoRoute(
              path: "pvcs",
              name: "pvcs",
              pageBuilder: (context, state) {
                var cluster = state.extra as K8zCluster;
                return NoTransitionPage(
                  child: PvcsPage(cluster: cluster),
                );
              },
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
            GoRoute(
              name: "appstore",
              path: "paywall/appstore",
              parentNavigatorKey: _rootNavigatorKey,
              builder: (context, state) => const AppStorePaywall(),
            ),
          ],
        ),
      ],
    ),
  ],
);
