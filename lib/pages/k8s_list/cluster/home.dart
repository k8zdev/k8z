import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:k8zdev/common/const.dart';
import 'package:k8zdev/common/ops.dart';
import 'package:k8zdev/common/styles.dart';
import 'package:k8zdev/dao/kube.dart';
import 'package:k8zdev/generated/l10n.dart';
import 'package:k8zdev/models/models.dart';
import 'package:k8zdev/providers/current_cluster.dart';
import 'package:k8zdev/services/k8z_native.dart';
import 'package:k8zdev/services/k8z_service.dart';
import 'package:k8zdev/widgets/namespace.dart';
import 'package:k8zdev/widgets/widgets.dart';
import 'package:k8zdev/widgets/interactive_guide_overlay.dart';
import 'package:k8zdev/services/onboarding_guide_service.dart';
import 'package:k8zdev/services/demo_cluster_service.dart';
import 'package:k8zdev/services/readonly_restriction_service.dart';
import 'package:k8zdev/models/guide_keys.dart';
import 'package:k8zdev/models/guide_step_definition.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';

class ClusterHomePage extends StatefulWidget {
  final K8zCluster cluster;
  const ClusterHomePage({super.key, required this.cluster});

  @override
  State<ClusterHomePage> createState() => _ClusterHomePageState();
}

class _ClusterHomePageState extends State<ClusterHomePage> {
  final eventNumber = 5;

  @override
  void initState() {
    super.initState();
    
    // Start onboarding guide for demo clusters
    if (DemoClusterService.isDemoCluster(widget.cluster)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _startOnboardingGuide();
      });
    }
  }

  void _startOnboardingGuide() {
    final guideService = Provider.of<OnboardingGuideService>(context, listen: false);
    guideService.startGuide(widget.cluster);
  }
  SettingsSection overview(S lang, CurrentCluster ccProvider) {
    final ns = CurrentCluster.current?.namespace ?? "";
    return SettingsSection(
      key: GuideKeys.welcomeTargetKey,
      title: Text(lang.overview),
      tiles: [
        SettingsTile(
          title: Text(lang.version),
          trailing: FutureBuilder<JsonReturn>(
            future: () async {
              return await K8zService(context, cluster: widget.cluster)
                  .get("/version");
            }(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return smallProgressIndicator;
              } else if (snapshot.hasError) {
                return Tooltip(
                  message: snapshot.error.toString(),
                  child: Text(lang.error),
                );
              }
              if (snapshot.data!.error.isNotEmpty) {
                return Text(lang.error);
              }
              var data = snapshot.data;
              var body = data?.body ?? "";
              var message = data?.error ?? "";
              var ok = data?.error.isEmpty ?? false;

              talker.info("ok: $ok, body: $body,error: $message");

              var childText = message;
              if (ok) {
                childText = data?.body["gitVersion"];
              }

              return Tooltip(
                message: message,
                child: Text(childText),
              );
            },
          ),
        ),
        SettingsTile(
          title: Text(lang.status),
          trailing: FutureBuilder(
            future: () async {
              return await K8zService(context, cluster: widget.cluster)
                  .checkHealth();
            }(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return smallProgressIndicator;
              }
              var running = snapshot.data ?? false;
              var style =
                  TextStyle(color: running ? Colors.green : Colors.redAccent);

              return Text(running ? lang.running : lang.error, style: style);
            },
          ),
        ),
        SettingsTile.switchTile(
          initialValue: CurrentCluster.current?.name == widget.cluster.name,
          onToggle: (value) {
            K8zCluster? cluster;
            talker.info("to $value");
            if (value) {
              cluster = widget.cluster;
            }
            ccProvider.setCurrent(cluster);
          },
          title: Text(lang.current_cluster),
        ),
        SettingsTile.navigation(
            title: Text(lang.namespaces),
            value: Text(ns.isEmpty ? lang.all : ns),
            onPressed: (context) {
              showCurrentNamespace(context, CurrentCluster.current);
            }),
      ],
    );
  }

  AbstractSettingsSection nodes(S lang) {
    return CustomSettingsSection(
      child: FutureBuilder(
        future: () async {
          // await Future.delayed(const Duration(seconds: 1));
          return await K8zService(context, cluster: widget.cluster)
              .get("/api/v1/nodes?limit=3");
        }(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          var title = Text(lang.name);
          Widget trailing = Text(lang.all);

          if (snapshot.connectionState == ConnectionState.waiting) {
            trailing = smallProgressIndicator;
          } else if (snapshot.hasError) {
            trailing = Tooltip(
              message: snapshot.error.toString(),
              child: Text(lang.error),
            );
          }

          if (snapshot.data != null && snapshot.data?.error.isNotEmpty) {
            return SettingsSection(
              title: Text(lang.nodes),
              tiles: [
                SettingsTile(
                  title: Text(
                    snapshot.data.error.toString(),
                    style: const TextStyle(color: Colors.grey),
                  ),
                )
              ],
            );
          }

          var data = snapshot.data;
          var body = data?.body;

          final nodesList = IoK8sApiCoreV1NodeList.fromJson(body);
          final list = nodesList?.items.mapIndexed(
                (index, node) {
                  var metadata = node.metadata;
                  var status = node.status?.conditions
                      .where((condition) => condition.status == 'True')
                      .map((condition) => condition.type);
                  var running = status != null &&
                      status.where((e) => e == 'Ready').isNotEmpty;

                  return SettingsTile.navigation(
                    title: Text(metadata?.name ?? ""),
                    trailing: running ? runningIcon : errorIcon,
                  );
                },
              ).toList() ??
              [];

          return SettingsSection(
            title: Text(lang.nodes),
            tiles: [
              SettingsTile.navigation(
                title: title,
                trailing: trailing,
                onPressed: (ctx) =>
                    GoRouter.of(ctx).goNamed("nodes", extra: widget.cluster),
              ),
              ...list,
            ],
          );
        },
      ),
    );
  }

  AbstractSettingsSection events(S lang) {
    return CustomSettingsSection(
      child: FutureBuilder(
        future: () async {
          // await Future.delayed(const Duration(seconds: 1));
          return await K8zService(context, cluster: widget.cluster).get(
              "/api/v1/events?fieldSelector=type=Warning&limit=$eventNumber");
        }(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          var title = Text(lang.last_warning_events(eventNumber));
          Widget trailing = Text(lang.all);
          List<AbstractSettingsTile> list = [];

          if (snapshot.connectionState == ConnectionState.waiting) {
            trailing = smallProgressIndicator;
          } else if (snapshot.hasError) {
            trailing = Tooltip(
              message: snapshot.error.toString(),
              child: Text(lang.error),
            );
          } else {
            if (snapshot.data.error.isNotEmpty) {
              return SettingsSection(
                title: Text(lang.nodes),
                tiles: [
                  SettingsTile(
                    title: Text(
                      snapshot.data.error.toString(),
                      style: const TextStyle(color: Colors.grey),
                    ),
                  )
                ],
              );
            }

            var data = snapshot.data;
            var body = data?.body;
            var message = data?.error ?? "";
            var ok = message.isEmpty ?? false;

            talker.debug(
                "ok: $ok, body: $body,error: ${jsonEncode(message.toString())}");
            final eventsList = (body == null)
                ? IoK8sApiCoreV1EventList()
                : IoK8sApiCoreV1EventList.fromJson(body);
            var eventItems = eventsList?.items;
            if (eventsList != null) {
              eventItems?.sort(
                (a, b) {
                  return a.lastTimestamp != null && b.lastTimestamp != null
                      ? b.lastTimestamp!.compareTo(a.lastTimestamp!)
                      : 0;
                },
              );
            }
            list = eventItems?.mapIndexed(
                  (index, event) {
                    talker.debug("$index");
                    var metadata = event.metadata;
                    var object = event.involvedObject;
                    var warning = (event.type == "Warning");
                    var text = lang.event_text(
                      metadata.namespace!,
                      metadata.name!,
                      event.type!,
                      event.reason!,
                      object.kind!,
                      object.name!,
                      event.lastTimestamp?.toString() ?? "null",
                      event.message!,
                    );

                    talker.debug(text);
                    return SettingsTile.navigation(
                      title: Text(text, style: smallTextStyle),
                      trailing: warning ? errorIcon : errorIcon,
                    );
                  },
                ).toList() ??
                [];
          }

          return SettingsSection(
            title: Text(lang.events),
            tiles: [
              SettingsTile.navigation(
                title: title,
                trailing: trailing,
                onPressed: (ctx) =>
                    GoRouter.of(ctx).goNamed("events", extra: widget.cluster),
              ),
              ...list,
            ],
          );
        },
      ),
    );
  }

  AppBar appBar(BuildContext context, S lang, CurrentCluster ccProvider) {
    return AppBar(
      title: Row(
        children: [
          Expanded(
            child: InkWell(
              onLongPress: ReadOnlyRestrictionService.isReadOnlyCluster(widget.cluster)
                  ? null
                  : () {
          showDialog(
              context: context,
              builder: (context) {
                return CupertinoAlertDialog(
                  title: Text(lang.arsure),
                  content: Text(
                    lang.will_delete(lang.clusters, widget.cluster.name),
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
                          if (CurrentCluster.current?.name ==
                              widget.cluster.name) {
                            ccProvider.setCurrent(null);
                          }
                          await K8zCluster.delete(widget.cluster);
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              showCloseIcon: true,
                              closeIconColor: Colors.white,
                              backgroundColor: Colors.green,
                              content: Text(
                                lang.deleted(widget.cluster.name),
                              ),
                            ),
                          );
                          // ignore: use_build_context_synchronously
                          GoRouter.of(context).goNamed("clusters");
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
                      },
                    )
                  ],
                );
              });
        },
              child: Text(widget.cluster.name),
            ),
          ),
          if (ReadOnlyRestrictionService.isReadOnlyCluster(widget.cluster)) ...[
            const SizedBox(width: 8),
            ReadOnlyRestrictionService.getReadOnlyIndicator(widget.cluster) ?? Container(),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var lang = S.of(context);
    var ccProvider = Provider.of<CurrentCluster>(context, listen: true);

    // Wrap with interactive guide overlay if onboarding is active
    Widget body = Consumer<OnboardingGuideService>(
      builder: (context, guideService, child) {
        final mainContent = Container(
          margin: bottomEdge,
          child: SettingsList(
            sections: [
              overview(lang, ccProvider),
              nodes(lang),
              events(lang),
            ],
          ),
        );

        if (guideService.isGuideActive) {
          final stepDef = guideService.getStepDefinition();
          return InteractiveGuideOverlay(
            isActive: guideService.isGuideActive,
            currentStepId: guideService.currentStepId,
            steps: DemoClusterGuide.getSteps(),
            onNext: () => guideService.nextStep(),
            onSkip: () => guideService.skipGuide(),
            onPrevious: () => guideService.previousStep(),
            child: mainContent,
          );
        }
        return mainContent;
      },
    );

    return Scaffold(
      appBar: appBar(context, lang, ccProvider),
      body: body,
    );
  }
}
