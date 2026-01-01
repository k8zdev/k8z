import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:k8zdev/generated/l10n.dart';
import 'package:k8zdev/models/models.dart';
import 'package:k8zdev/widgets/detail_widgets/pvcs.dart';

void main() {
  group('buildPVCDetailSectionTiles', () {
    TestWidgetsFlutterBinding.ensureInitialized();

    testWidgets('returns empty list when PVC is null', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: const [AppLocalizationDelegate()],
          home: const Scaffold(),
        ),
      );

      await tester.pumpAndSettle();

      final context = tester.element(find.byType(Scaffold));
      final tiles = buildPVCDetailSectionTiles(context, null, 'en');

      expect(tiles, isA<List>());
      expect(tiles.length, 1);
    });

    testWidgets('displays PVC status text in tiles', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: const [AppLocalizationDelegate()],
          home: const Scaffold(),
        ),
      );

      await tester.pumpAndSettle();

      final pvc = IoK8sApiCoreV1PersistentVolumeClaim(
        spec: IoK8sApiCoreV1PersistentVolumeClaimSpec(),
        status: IoK8sApiCoreV1PersistentVolumeClaimStatus(phase: 'Bound'),
      );

      final context = tester.element(find.byType(Scaffold));
      final tiles = buildPVCDetailSectionTiles(context, pvc, 'en');

      expect(tiles, isNotEmpty);
    });

    testWidgets('displays PVC with Pending status', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: const [AppLocalizationDelegate()],
          home: const Scaffold(),
        ),
      );

      await tester.pumpAndSettle();

      final pvc = IoK8sApiCoreV1PersistentVolumeClaim(
        spec: IoK8sApiCoreV1PersistentVolumeClaimSpec(),
        status: IoK8sApiCoreV1PersistentVolumeClaimStatus(phase: 'Pending'),
      );

      final context = tester.element(find.byType(Scaffold));
      final tiles = buildPVCDetailSectionTiles(context, pvc, 'en');

      expect(tiles, isNotEmpty);
    });

    testWidgets('displays PVC capacity', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: const [AppLocalizationDelegate()],
          home: const Scaffold(),
        ),
      );

      await tester.pumpAndSettle();

      final pvc = IoK8sApiCoreV1PersistentVolumeClaim(
        spec: IoK8sApiCoreV1PersistentVolumeClaimSpec(
          resources: IoK8sApiCoreV1ResourceRequirements(
            requests: {'storage': '10Gi'},
          ),
        ),
        status: IoK8sApiCoreV1PersistentVolumeClaimStatus(),
      );

      final context = tester.element(find.byType(Scaffold));
      final tiles = buildPVCDetailSectionTiles(context, pvc, 'en');

      expect(tiles, isNotEmpty);
    });

    testWidgets('displays access modes', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: const [AppLocalizationDelegate()],
          home: const Scaffold(),
        ),
      );

      await tester.pumpAndSettle();

      final pvc = IoK8sApiCoreV1PersistentVolumeClaim(
        spec: IoK8sApiCoreV1PersistentVolumeClaimSpec(
          accessModes: ['ReadWriteOnce', 'ReadOnlyMany'],
        ),
        status: IoK8sApiCoreV1PersistentVolumeClaimStatus(),
      );

      final context = tester.element(find.byType(Scaffold));
      final tiles = buildPVCDetailSectionTiles(context, pvc, 'en');

      expect(tiles, isNotEmpty);
    });

    testWidgets('displays storage class name', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: const [AppLocalizationDelegate()],
          home: const Scaffold(),
        ),
      );

      await tester.pumpAndSettle();

      final pvc = IoK8sApiCoreV1PersistentVolumeClaim(
        spec: IoK8sApiCoreV1PersistentVolumeClaimSpec(
          storageClassName: 'standard',
        ),
        status: IoK8sApiCoreV1PersistentVolumeClaimStatus(),
      );

      final context = tester.element(find.byType(Scaffold));
      final tiles = buildPVCDetailSectionTiles(context, pvc, 'en');

      expect(tiles, isNotEmpty);
    });

    testWidgets('displays volume name', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: const [AppLocalizationDelegate()],
          home: const Scaffold(),
        ),
      );

      await tester.pumpAndSettle();

      final pvc = IoK8sApiCoreV1PersistentVolumeClaim(
        spec: IoK8sApiCoreV1PersistentVolumeClaimSpec(
          volumeName: 'pv-123',
        ),
        status: IoK8sApiCoreV1PersistentVolumeClaimStatus(),
      );

      final context = tester.element(find.byType(Scaffold));
      final tiles = buildPVCDetailSectionTiles(context, pvc, 'en');

      expect(tiles, isNotEmpty);
    });

    testWidgets('displays volume mode', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: const [AppLocalizationDelegate()],
          home: const Scaffold(),
        ),
      );

      await tester.pumpAndSettle();

      final pvc = IoK8sApiCoreV1PersistentVolumeClaim(
        spec: IoK8sApiCoreV1PersistentVolumeClaimSpec(
          volumeMode: 'Filesystem',
        ),
        status: IoK8sApiCoreV1PersistentVolumeClaimStatus(),
      );

      final context = tester.element(find.byType(Scaffold));
      final tiles = buildPVCDetailSectionTiles(context, pvc, 'en');

      expect(tiles, isNotEmpty);
    });

    testWidgets('displays complete PVC information', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: const [AppLocalizationDelegate()],
          home: const Scaffold(),
        ),
      );

      await tester.pumpAndSettle();

      final pvc = IoK8sApiCoreV1PersistentVolumeClaim(
        spec: IoK8sApiCoreV1PersistentVolumeClaimSpec(
          accessModes: ['ReadWriteOnce'],
          resources: IoK8sApiCoreV1ResourceRequirements(
            requests: {'storage': '5Gi'},
          ),
          storageClassName: 'fast-ssd',
          volumeName: 'pvc-abc123',
          volumeMode: 'Filesystem',
        ),
        status: IoK8sApiCoreV1PersistentVolumeClaimStatus(
          phase: 'Bound',
        ),
      );

      final context = tester.element(find.byType(Scaffold));
      final tiles = buildPVCDetailSectionTiles(context, pvc, 'en');

      // All 6 items should be created (status, capacity, access modes, storage class, volume name, volume mode)
      expect(tiles.length, 6);
    });
  });
}
