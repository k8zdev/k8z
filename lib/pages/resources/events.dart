import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:k8sapp/common/const.dart';
import 'package:k8sapp/common/helpers.dart';
import 'package:k8sapp/common/ops.dart';
import 'package:k8sapp/common/styles.dart';
import 'package:k8sapp/dao/kube.dart';
import 'package:k8sapp/generated/l10n.dart';
import 'package:k8sapp/models/models.dart';
import 'package:k8sapp/services/k8z_service.dart';
import 'package:k8sapp/widgets/widgets.dart';
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
          // await Future.delayed(const Duration(seconds: 1));
          return await K8zService(cluster: widget.cluster)
              .get("/api/v1/events?limit=500");
        }(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          var list = [];
          var title = Text(lang.name);
          Widget trailing = Text(lang.status);

          if (snapshot.connectionState == ConnectionState.waiting) {
            trailing = const SizedBox(
              height: 16,
              width: 16,
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            talker.error(
              "request events faild, error: ${snapshot.error.toString()}",
            );
            trailing = Tooltip(
              message: snapshot.error.toString(),
              child: Text(lang.error),
            );
          } else {
            final eventslist =
                IoK8sApiCoreV1EventList.fromJson(snapshot.data.body);
            var eventItems = eventslist?.items;
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

          talker.debug("list ${list.length}");

          return SettingsSection(
            title: Text(lang.events),
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
        child: SettingsList(sections: [buildEventsList(lang)]),
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
