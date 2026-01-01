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
        'Reason',
        event.reason!,
        langCode,
        enLen: 72.0,
        zhLen: 72.0,
      ),
    if (event.message != null && event.message!.isNotEmpty)
      copyTileValue(
        'Message',
        event.message!,
        langCode,
        enLen: 72.0,
        zhLen: 72.0,
      ),
    if (event.count != null)
      copyTileValue(
        'Count',
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
      leading: leadingText('Involved Object', langCode, enLen: 72.0, zhLen: 72.0),
      title: Text('${involved.kind ?? ''}/${involved.name ?? ''}'),
      trailing: involved.namespace != null
          ? Text(involved.namespace!)
          : null,
    ),
  );

  if (involved.uid != null) {
    tiles.add(
      copyTileValue(
        'Object UID',
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
        'First Timestamp',
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
        'Last Timestamp',
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
        'Event Time',
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
          'Series Count',
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
          'Series Last Observed',
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
        'Reporting Component',
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
        'Reporting Instance',
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
          'Source Component',
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
          'Source Host',
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
        'Action',
        event.action!,
        langCode,
        enLen: 72.0,
        zhLen: 72.0,
      ),
    );
  }

  return tiles;
}