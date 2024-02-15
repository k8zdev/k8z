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
import 'package:k8zdev/widgets/widgets.dart';
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
  SettingsSection overview(S lang, CurrentCluster ccProvider) {
    return SettingsSection(
      title: Text(lang.overview),
      tiles: [
        SettingsTile(
          title: Text(lang.version),
          trailing: FutureBuilder<JsonReturn>(
            future: () async {
              return await K8zService(cluster: widget.cluster).get("/version");
            }(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(color: Colors.blue),
                );
              } else if (snapshot.hasError) {
                return Tooltip(
                  message: snapshot.error.toString(),
                  child: Text(lang.error),
                );
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
              return await K8zService(cluster: widget.cluster).checkHealth();
            }(),
            builder: (context, snapshot) {
              var running = snapshot.data ?? false;
              var style =
                  TextStyle(color: running ? Colors.green : Colors.redAccent);

              return Text(running ? lang.running : lang.error, style: style);
            },
          ),
        ),
        SettingsTile.switchTile(
          initialValue: ccProvider.current?.name == widget.cluster.name,
          onToggle: (value) {
            late K8zCluster cluster;
            talker.info("to $value");
            if (value) {
              cluster = widget.cluster;
            }
            ccProvider.setCurrent(cluster);
          },
          title: Text(lang.current_cluster),
        ),
      ],
    );
  }

  AbstractSettingsSection nodes(S lang) {
    return CustomSettingsSection(
      child: FutureBuilder(
        future: () async {
          // await Future.delayed(const Duration(seconds: 1));
          return await K8zService(cluster: widget.cluster)
              .get("/api/v1/nodes?limit=3");
        }(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          var title = Text(lang.name);
          Widget trailing = Text(lang.all);

          if (snapshot.connectionState == ConnectionState.waiting) {
            trailing = const SizedBox(
              height: 16,
              width: 16,
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            trailing = Tooltip(
              message: snapshot.error.toString(),
              child: Text(lang.error),
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
          return await K8zService(cluster: widget.cluster).get(
              "/api/v1/events?fieldSelector=type=Warning&limit=$eventNumber");
        }(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          var title = Text(lang.last_warning_events(eventNumber));
          Widget trailing = Text(lang.all);
          List<AbstractSettingsTile> list = [];

          if (snapshot.connectionState == ConnectionState.waiting) {
            trailing = const SizedBox(
              height: 16,
              width: 16,
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            trailing = Tooltip(
              message: snapshot.error.toString(),
              child: Text(lang.error),
            );
          } else {
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
                onPressed: (ctx) => GoRouter.of(ctx).goNamed(
                  "events",
                  extra: widget.cluster,
                ),
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
      title: InkWell(
        onLongPress: () {
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
                          if (ccProvider.current?.name == widget.cluster.name) {
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
    );
  }

  @override
  Widget build(BuildContext context) {
    var lang = S.of(context);
    var ccProvider = Provider.of<CurrentCluster>(context, listen: true);

    return Scaffold(
      appBar: appBar(context, lang, ccProvider),
      body: Container(
        margin: bottomEdge,
        child: SettingsList(
          sections: [
            overview(lang, ccProvider),
            nodes(lang),
            events(lang),
          ],
        ),
      ),
    );
  }
}
