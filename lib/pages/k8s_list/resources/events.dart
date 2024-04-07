import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:k8zdev/common/const.dart';
import 'package:k8zdev/common/helpers.dart';
import 'package:k8zdev/common/ops.dart';
import 'package:k8zdev/common/styles.dart';
import 'package:k8zdev/dao/kube.dart';
import 'package:k8zdev/generated/l10n.dart';
import 'package:k8zdev/models/models.dart';
import 'package:k8zdev/providers/current_cluster.dart';
import 'package:k8zdev/services/k8z_service.dart';
import 'package:k8zdev/widgets/namespace.dart';
import 'package:k8zdev/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';

class EventsPage extends StatefulWidget {
  final K8zCluster cluster;
  const EventsPage({super.key, required this.cluster});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  AbstractSettingsSection buildEventsList(S lang) {
    return CustomSettingsSection(
      child: FutureBuilder(
        future: () async {
          final c = Provider.of<CurrentCluster>(context, listen: true).current;
          final namespaced = c?.namespace.isEmpty ?? true
              ? ""
              : "/namespaces/${c?.namespace ?? ""}";

          // await Future.delayed(const Duration(seconds: 1));
          return await K8zService(context, cluster: widget.cluster)
              .get("/api/v1$namespaced/events?limit=500");
        }(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          var list = [];
          String totals = "";
          String duration = "";
          var title = Text(lang.name);
          Widget trailing = Text(lang.status);

          if (snapshot.connectionState == ConnectionState.waiting) {
            trailing = smallProgressIndicator;
          } else if (snapshot.hasError) {
            talker.error(
              "request events faild, error: ${snapshot.error.toString()}",
            );
            trailing = Tooltip(
              message: snapshot.error.toString(),
              child: Text(lang.error),
            );
          } else {
            if (snapshot.data.error.isNotEmpty) {
              trailing = Container();
              title = Text(lang.error);
              list = [
                SettingsTile(
                  title: Text(
                    snapshot.data.error,
                    style: const TextStyle(color: Colors.grey),
                  ),
                )
              ];
            } else {
              final eventslist =
                  IoK8sApiCoreV1EventList.fromJson(snapshot.data.body);
              var eventItems = eventslist?.items;

              totals = lang.items_number(eventItems?.length ?? 0);
              Duration rd = snapshot.data.duration;
              duration = lang.api_request_duration(rd.prettyMs);

              if (eventslist != null) {
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
                      talker.debug("ns: ${event.metadata}\n");

                      var metadata = event.metadata;
                      var now = DateTime.now();
                      var creation = metadata.creationTimestamp ?? now;
                      var age = now.difference(creation).pretty;
                      var warning = (event.type == "Warning");
                      var object = event.involvedObject;
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

                      return SettingsTile(
                        title: Text(text, style: smallTextStyle),
                        trailing: Row(
                          children: [
                            Text(age),
                            const Divider(indent: 12),
                            warning ? errorIcon : runningIcon,
                          ],
                        ),
                      );
                    },
                  ).toList() ??
                  [];
            }
          }
          talker.debug("list ${list.length}");

          return SettingsSection(
            title: Text(lang.events + totals + duration),
            tiles: [
              SettingsTile.navigation(
                title: title,
                trailing: trailing,
              ),
              ...list,
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var lang = S.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(lang.events)),
      body: Container(
        margin: bottomEdge,
        child: SettingsList(
          sections: [
            namespaceFilter(context),
            buildEventsList(lang),
          ],
        ),
      ),
    );
  }
}

class SettingsFilterTile extends AbstractSettingsTile {
  const SettingsFilterTile(
    Key? key,
  ) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
