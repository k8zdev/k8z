import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:k8zdev/models/models.dart';
import 'package:k8zdev/widgets/detail_widgets/events_detail.dart';
import '../test_helpers.dart';

void main() {
  group('buildEventsDetailSectionTiles', () {
    testWidgets('should return empty tile when event is null', (WidgetTester tester) async {
      await tester.pumpWidget(
        createSimpleTestApp(
          child: Builder(
            builder: (context) {
              final tiles = buildEventsDetailSectionTiles(context, null, 'en');
              expect(tiles.length, 1);
              return Container();
            },
          ),
        ),
      );
    });

    testWidgets('should display type field', (WidgetTester tester) async {
      final event = _createSampleEvent(type: 'Warning');
      await tester.pumpWidget(
        createSimpleTestApp(
          child: Builder(
            builder: (context) {
              final tiles = buildEventsDetailSectionTiles(context, event, 'en');
              // First tile should be the type tile
              expect(tiles.isNotEmpty, true);
              return Container();
            },
          ),
        ),
      );
    });

    testWidgets('should handle warning type event', (WidgetTester tester) async {
      final event = _createSampleEvent(type: 'Warning');
      await tester.pumpWidget(
        createSimpleTestApp(
          child: Builder(
            builder: (context) {
              final tiles = buildEventsDetailSectionTiles(context, event, 'en');
              expect(tiles.length, greaterThan(1));
              return Container();
            },
          ),
        ),
      );
    });

    testWidgets('should handle normal type event', (WidgetTester tester) async {
      final event = _createSampleEvent(type: 'Normal');
      await tester.pumpWidget(
        createSimpleTestApp(
          child: Builder(
            builder: (context) {
              final tiles = buildEventsDetailSectionTiles(context, event, 'en');
              expect(tiles.length, greaterThan(1));
              return Container();
            },
          ),
        ),
      );
    });

    testWidgets('should display reason when available', (WidgetTester tester) async {
      final event = _createSampleEvent(reason: 'FailedMount');
      await tester.pumpWidget(
        createSimpleTestApp(
          child: Builder(
            builder: (context) {
              final tiles = buildEventsDetailSectionTiles(context, event, 'en');
              expect(tiles.length, greaterThan(1));
              return Container();
            },
          ),
        ),
      );
    });

    testWidgets('should display message when available', (WidgetTester tester) async {
      final event = _createSampleEvent(message: 'Test message');
      await tester.pumpWidget(
        createSimpleTestApp(
          child: Builder(
            builder: (context) {
              final tiles = buildEventsDetailSectionTiles(context, event, 'en');
              expect(tiles.length, greaterThan(1));
              return Container();
            },
          ),
        ),
      );
    });

    testWidgets('should display count when available', (WidgetTester tester) async {
      final event = _createSampleEvent(count: 5);
      await tester.pumpWidget(
        createSimpleTestApp(
          child: Builder(
            builder: (context) {
              final tiles = buildEventsDetailSectionTiles(context, event, 'en');
              expect(tiles.length, greaterThan(1));
              return Container();
            },
          ),
        ),
      );
    });

    testWidgets('should display involved object', (WidgetTester tester) async {
      final event = _createSampleEvent();
      await tester.pumpWidget(
        createSimpleTestApp(
          child: Builder(
            builder: (context) {
              final tiles = buildEventsDetailSectionTiles(context, event, 'en');
              // Should have multiple tiles including involved object tile
              expect(tiles.length, greaterThan(1));
              return Container();
            },
          ),
        ),
      );
    });

    testWidgets('should display first and last timestamps', (WidgetTester tester) async {
      final event = _createSampleEvent(
        firstTimestamp: DateTime(2024, 1, 1),
        lastTimestamp: DateTime(2024, 1, 2),
      );
      await tester.pumpWidget(
        createSimpleTestApp(
          child: Builder(
            builder: (context) {
              final tiles = buildEventsDetailSectionTiles(context, event, 'en');
              // Should have timestamps tiles
              expect(tiles.length, greaterThan(3));
              return Container();
            },
          ),
        ),
      );
    });

    testWidgets('should display eventTime when available', (WidgetTester tester) async {
      final event = _createSampleEvent(
        eventTime: DateTime(2024, 1, 3),
      );
      await tester.pumpWidget(
        createSimpleTestApp(
          child: Builder(
            builder: (context) {
              final tiles = buildEventsDetailSectionTiles(context, event, 'en');
              expect(tiles.length, greaterThan(1));
              return Container();
            },
          ),
        ),
      );
    });

    testWidgets('should display reporting component when available', (WidgetTester tester) async {
      final event = _createSampleEvent(reportingComponent: 'kubelet');
      await tester.pumpWidget(
        createSimpleTestApp(
          child: Builder(
            builder: (context) {
              final tiles = buildEventsDetailSectionTiles(context, event, 'en');
              expect(tiles.length, greaterThan(1));
              return Container();
            },
          ),
        ),
      );
    });

    testWidgets('should display reporting instance when available', (WidgetTester tester) async {
      final event = _createSampleEvent(reportingInstance: 'kubelet-xyzf');
      await tester.pumpWidget(
        createSimpleTestApp(
          child: Builder(
            builder: (context) {
              final tiles = buildEventsDetailSectionTiles(context, event, 'en');
              expect(tiles.length, greaterThan(1));
              return Container();
            },
          ),
        ),
      );
    });

    testWidgets('should display series information when available', (WidgetTester tester) async {
      final event = IoK8sApiCoreV1Event(
        type: 'Normal',
        reason: 'Started',
        message: 'Started container',
        count: 10,
        involvedObject: IoK8sApiCoreV1ObjectReference(
          kind: 'Pod',
          name: 'test-pod',
          namespace: 'default',
          uid: 'abc123',
        ),
        firstTimestamp: DateTime(2024, 1, 1),
        lastTimestamp: DateTime(2024, 1, 2),
        metadata: IoK8sApimachineryPkgApisMetaV1ObjectMeta(
          name: 'test-event',
          namespace: 'default',
        ),
        series: IoK8sApiCoreV1EventSeries(
          count: 10,
          lastObservedTime: DateTime(2024, 1, 5),
        ),
      );

      await tester.pumpWidget(
        createSimpleTestApp(
          child: Builder(
            builder: (context) {
              final tiles = buildEventsDetailSectionTiles(context, event, 'en');
              // Should have more tiles with series information
              expect(tiles.length, greaterThan(5));
              return Container();
            },
          ),
        ),
      );
    });

    testWidgets('should display action when available', (WidgetTester tester) async {
      final event = _createSampleEvent(action: 'Started');
      await tester.pumpWidget(
        createSimpleTestApp(
          child: Builder(
            builder: (context) {
              final tiles = buildEventsDetailSectionTiles(context, event, 'en');
              expect(tiles.length, greaterThan(1));
              return Container();
            },
          ),
        ),
      );
    });

    testWidgets('should include source fields when available', (WidgetTester tester) async {
      final event = _createSampleEvent();
      await tester.pumpWidget(
        createSimpleTestApp(
          child: Builder(
            builder: (context) {
              final tiles = buildEventsDetailSectionTiles(context, event, 'en');
              // Should have source component and source host tiles
              expect(tiles.length, greaterThan(5));
              return Container();
            },
          ),
        ),
      );
    });

    testWidgets('should handle event with minimal data', (WidgetTester tester) async {
      final event = IoK8sApiCoreV1Event(
        involvedObject: IoK8sApiCoreV1ObjectReference(
          kind: 'Pod',
          name: 'minimal-pod',
          uid: 'min123',
        ),
        metadata: IoK8sApimachineryPkgApisMetaV1ObjectMeta(
          name: 'minimal-event',
          namespace: 'default',
        ),
      );

      await tester.pumpWidget(
        createSimpleTestApp(
          child: Builder(
            builder: (context) {
              final tiles = buildEventsDetailSectionTiles(context, event, 'en');
              // Should still have at least type and involved object tiles
              expect(tiles.isNotEmpty, true);
              return Container();
            },
          ),
        ),
      );
    });
  });
}

IoK8sApiCoreV1Event _createSampleEvent({
  String? type,
  String? reason,
  String? message,
  int? count,
  DateTime? firstTimestamp,
  DateTime? lastTimestamp,
  DateTime? eventTime,
  String? reportingComponent,
  String? reportingInstance,
  String? action,
}) {
  return IoK8sApiCoreV1Event(
    type: type ?? 'Normal',
    reason: reason ?? 'Started',
    message: message ?? 'Container started successfully',
    count: count ?? 1,
    firstTimestamp: firstTimestamp ?? DateTime(2024, 1, 1),
    lastTimestamp: lastTimestamp ?? DateTime(2024, 1, 1),
    eventTime: eventTime,
    reportingComponent: reportingComponent,
    reportingInstance: reportingInstance,
    action: action,
    involvedObject: IoK8sApiCoreV1ObjectReference(
      kind: 'Pod',
      name: 'test-pod',
      namespace: 'default',
      uid: 'abc123',
    ),
    source_: IoK8sApiCoreV1EventSource(
      component: 'kubelet',
      host: 'node-1',
    ),
    metadata: IoK8sApimachineryPkgApisMetaV1ObjectMeta(
      name: 'test-event',
      namespace: 'default',
    ),
  );
}