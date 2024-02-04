import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:k8sapp/common/ops.dart';
import 'package:k8sapp/dao/kube.dart';
import 'package:k8sapp/pages/cluster/select_clusters.dart';
import 'package:k8sapp/pages/cluster/create.dart';
import 'package:k8sapp/pages/cluster/create_load_manual.dart';
import 'package:k8sapp/pages/cluster/home.dart';
import 'package:k8sapp/pages/clusters.dart';
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
