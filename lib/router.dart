import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:k8zdev/common/helpers.dart';
import 'package:k8zdev/common/ops.dart';
import 'package:k8zdev/dao/kube.dart';
import 'package:k8zdev/generated/l10n.dart';
import 'package:k8zdev/pages/k8s_detail/details_page.dart';
import 'package:k8zdev/pages/k8s_list/applications/helm_releases.dart';
import 'package:k8zdev/pages/k8s_list/cluster/select_clusters.dart';
import 'package:k8zdev/pages/k8s_list/cluster/create.dart';
import 'package:k8zdev/pages/k8s_list/cluster/create_load_manual.dart';
import 'package:k8zdev/pages/k8s_list/cluster/home.dart';
import 'package:k8zdev/pages/clusters.dart';
import 'package:k8zdev/pages/k8s_list/networks/endpoints.dart';
import 'package:k8zdev/pages/k8s_list/networks/ingresses.dart';
import 'package:k8zdev/pages/k8s_list/networks/services.dart';
import 'package:k8zdev/pages/not_found.dart';
import 'package:k8zdev/pages/paywalls/appstore_sponsors.dart';
import 'package:k8zdev/pages/resources.dart';
import 'package:k8zdev/pages/k8s_list/resources/config/configmaps.dart';
import 'package:k8zdev/pages/k8s_list/resources/config/secrets.dart';
import 'package:k8zdev/pages/k8s_list/resources/config/service_accounts.dart';
import 'package:k8zdev/pages/k8s_list/resources/crds.dart';
import 'package:k8zdev/pages/k8s_list/resources/events.dart';
import 'package:k8zdev/pages/k8s_list/resources/namespaces.dart';
import 'package:k8zdev/pages/k8s_list/resources/nodes.dart';
import 'package:k8zdev/pages/k8s_list/resources/storage/pvcs.dart';
import 'package:k8zdev/pages/k8s_list/resources/storage/pvs.dart';
import 'package:k8zdev/pages/k8s_list/resources/storage/storage_class.dart';
import 'package:k8zdev/pages/workloads.dart';
import 'package:k8zdev/pages/k8s_list/workloads/daemon_sets.dart';
import 'package:k8zdev/pages/k8s_list/workloads/deployments.dart';
import 'package:k8zdev/pages/k8s_list/workloads/pods.dart';
import 'package:k8zdev/pages/k8s_list/workloads/stateful_sets.dart';
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
            logScreenView(screenName: 'ClusterPage');
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
                logScreenView(screenName: 'ClusterHomePage');
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
                logScreenView(screenName: 'ClusterCreatePage');
                return const ClusterCreatePage();
              },
              routes: [
                GoRoute(
                  name: "manual_load",
                  path: "manual",
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) {
                    logScreenView(screenName: 'ManualLoadSubPage');
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
                logScreenView(screenName: 'ChoiceClustersSubPage');
                var clusters = state.extra as List<K8zCluster>;
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
              logScreenView(
                screenName: 'NotFoundPage',
                parameters: {'vieweScreen': 'WorkloadsPage'},
              );
              return NoTransitionPage(
                child: NotFoundPage(
                  title: lang.workloads,
                  info: lang.no_current_cluster,
                ),
              );
            }
            logScreenView(screenName: 'WorkloadsPage');
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
                logScreenView(screenName: 'HelmReleasesPage');
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
                logScreenView(screenName: 'PodsPage');
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
                logScreenView(screenName: 'DaemonSetsPage');
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
                logScreenView(screenName: 'DeploymentsPage');
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
                logScreenView(screenName: 'StatefulSetsPage');
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
                logScreenView(screenName: 'EndpointsPage');
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
                logScreenView(screenName: 'IngressesPage');
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
                logScreenView(screenName: 'ServicesPage');
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
              logScreenView(
                screenName: 'NotFoundPage',
                parameters: {'vieweScreen': 'WorkloadsPage'},
              );
              return NoTransitionPage(
                child: NotFoundPage(
                  title: lang.resources,
                  info: lang.no_current_cluster,
                ),
              );
            }
            logScreenView(screenName: 'ResourcesPage');
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
                logScreenView(screenName: 'NodesPage');
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
                  logScreenView(screenName: 'NamespacesPage');
                  var cluster = state.extra as K8zCluster;
                  return NoTransitionPage(
                    child: NamespacesPage(cluster: cluster),
                  );
                }),
            GoRoute(
              path: "events",
              name: "events",
              pageBuilder: (context, state) {
                logScreenView(screenName: 'EventsPage');
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
                logScreenView(screenName: 'CrdsPage');
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
                logScreenView(screenName: 'ConfigMapsPage');
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
                logScreenView(screenName: 'SecretsPage');
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
                logScreenView(screenName: 'ServiceAccountsPage');
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
                logScreenView(screenName: 'StorageClassPage');
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
                logScreenView(screenName: 'PvsPage');
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
                logScreenView(screenName: 'PvcsPage');
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
          pageBuilder: (context, state) {
            logScreenView(screenName: 'SettingsPage');
            return const NoTransitionPage(
              child: SettingsPage(),
            );
          },
          routes: [
            GoRoute(
                name: "locale",
                path: "general/locale",
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) {
                  logScreenView(screenName: 'LocaleSettingPage');
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
              builder: (context, state) {
                logScreenView(screenName: 'AppStorePaywallPage');
                return const AppStorePaywall();
              },
            ),
          ],
        ),
        GoRoute(
          path: "/details/:path/:namespace/:resource/:name",
          name: "details",
          pageBuilder: (context, state) {
            logScreenView(screenName: 'DetailsPage');

            talker.info(state.pathParameters);

            // namespace param empty will case route miss
            // if it is empty or null, should set to "_".
            var namespace = state.pathParameters['namespace'];
            if (namespace == "_") {
              namespace = "";
            }

            return NoTransitionPage(
              child: ResourceDetailsPage(
                title: "",
                path: state.pathParameters['path']!,
                namespace: namespace,
                resource: state.pathParameters['resource']!,
                name: state.pathParameters['name']!,
              ),
            );
          },
        ),
      ],
    ),
  ],
);
