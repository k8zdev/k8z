import 'package:flutter/material.dart';
import 'package:k8zdev/generated/l10n.dart';
import 'package:k8zdev/models/models.dart';
import 'package:k8zdev/widgets/tiles.dart';
import 'package:k8zdev/widgets/widgets.dart';
import 'package:settings_ui/settings_ui.dart';

List<AbstractSettingsTile> buildEventsDetailSectionTiles(
  BuildContext context,
  IoK8sApiCoreV1Event? event,
  String langCode,
) {
  final lang = S.of(context);

  List<AbstractSettingsTile> tiles = [];

  if (event == null) {
    return [SettingsTile(title: Text(lang.empty))];
  }

  final type = event.type ?? '';

  tiles.addAll([
    copyTileValue(
      lang.type,
      type,
      langCode,
      enLen: 72.0,
      zhLen: 72.0,
    ),
    if (event.reason != null)
      copyTileValue(
        lang.event_reason,
        event.reason!,
        langCode,
        enLen: 72.0,
        zhLen: 72.0,
      ),
    if (event.message != null && event.message!.isNotEmpty)
      copyTileValue(
        lang.event_message,
        event.message!,
        langCode,
        enLen: 72.0,
        zhLen: 72.0,
      ),
    if (event.count != null)
      copyTileValue(
        lang.event_count,
        '${event.count}',
        langCode,
        enLen: 72.0,
        zhLen: 72.0,
      ),
  ]);

  // Involved Object
  final involved = event.involvedObject;
  tiles.add(
    SettingsTile.navigation(
      leading: leadingText(lang.event_involved_object, langCode, enLen: 72.0, zhLen: 72.0),
      title: Text('${involved.kind ?? ''}/${involved.name ?? ''}'),
      trailing: involved.namespace != null
          ? Text(involved.namespace!)
          : null,
    ),
  );

  if (involved.uid != null) {
    tiles.add(
      copyTileValue(
        lang.event_object_uid,
        involved.uid!,
        langCode,
        enLen: 72.0,
        zhLen: 72.0,
      ),
    );
  }

  // Timestamps
  if (event.firstTimestamp != null) {
    tiles.add(
      copyTileValue(
        lang.event_first_timestamp,
        event.firstTimestamp!.toLocal().toString(),
        langCode,
        enLen: 72.0,
        zhLen: 72.0,
      ),
    );
  }

  if (event.lastTimestamp != null) {
    tiles.add(
      copyTileValue(
        lang.event_last_timestamp,
        event.lastTimestamp!.toLocal().toString(),
        langCode,
        enLen: 72.0,
        zhLen: 72.0,
      ),
    );
  }

  if (event.eventTime != null) {
    tiles.add(
      copyTileValue(
        lang.event_event_time,
        event.eventTime!.toLocal().toString(),
        langCode,
        enLen: 72.0,
        zhLen: 72.0,
      ),
    );
  }

  // Series information
  if (event.series != null) {
    final series = event.series!;
    if (series.count != null) {
      tiles.add(
        copyTileValue(
          lang.event_series_count,
          '${series.count}',
          langCode,
          enLen: 72.0,
          zhLen: 72.0,
        ),
      );
    }
    if (series.lastObservedTime != null) {
      tiles.add(
        copyTileValue(
          lang.event_series_last_observed,
          series.lastObservedTime!.toLocal().toString(),
          langCode,
          enLen: 72.0,
          zhLen: 72.0,
        ),
      );
    }
  }

  // Reporting information
  if (event.reportingComponent != null) {
    tiles.add(
      copyTileValue(
        lang.event_reporting_component,
        event.reportingComponent!,
        langCode,
        enLen: 72.0,
        zhLen: 72.0,
      ),
    );
  }

  if (event.reportingInstance != null) {
    tiles.add(
      copyTileValue(
        lang.event_reporting_instance,
        event.reportingInstance!,
        langCode,
        enLen: 72.0,
        zhLen: 72.0,
      ),
    );
  }

  // Legacy source fields
  if (event.source_ != null) {
    final source = event.source_!;
    if (source.component != null) {
      tiles.add(
        copyTileValue(
          lang.event_source_component,
          source.component!,
          langCode,
          enLen: 72.0,
          zhLen: 72.0,
        ),
      );
    }
    if (source.host != null) {
      tiles.add(
        copyTileValue(
          lang.event_source_host,
          source.host!,
          langCode,
          enLen: 72.0,
          zhLen: 72.0,
        ),
      );
    }
  }

  // Action if available
  if (event.action != null) {
    tiles.add(
      copyTileValue(
        lang.event_action,
        event.action!,
        langCode,
        enLen: 72.0,
        zhLen: 72.0,
      ),
    );
  }

  return tiles;
}