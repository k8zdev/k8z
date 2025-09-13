import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:k8zdev/services/readonly_restriction_service.dart';
import 'package:k8zdev/dao/kube.dart';
import 'package:k8zdev/generated/l10n.dart';

void main() {
  group('ReadOnlyRestrictionService', () {
    late K8zCluster demoCluster;
    late K8zCluster regularCluster;

    setUp(() {
      demoCluster = K8zCluster.createDemo(
        name: 'Demo Cluster',
        server: 'https://demo.k8s.io',
        caData: 'demo-ca-data',
      );

      regularCluster = K8zCluster(
        name: 'Regular Cluster',
        server: 'https://prod.k8s.io',
        caData: 'prod-ca-data',
        namespace: 'default',
        insecure: false,
        clientKey: '',
        clientCert: '',
        username: '',
        password: '',
        token: '',
        createdAt: DateTime.now().millisecondsSinceEpoch,
      );
    });

    test('should identify read-only clusters correctly', () {
      expect(ReadOnlyRestrictionService.isReadOnlyCluster(demoCluster), isTrue);
      expect(ReadOnlyRestrictionService.isReadOnlyCluster(regularCluster), isFalse);
      expect(ReadOnlyRestrictionService.isReadOnlyCluster(null), isFalse);
    });

    test('should identify explicitly read-only clusters', () {
      final readOnlyCluster = K8zCluster(
        name: 'Read-Only Cluster',
        server: 'https://readonly.k8s.io',
        caData: 'readonly-ca-data',
        namespace: 'default',
        insecure: false,
        clientKey: '',
        clientCert: '',
        username: '',
        password: '',
        token: '',
        createdAt: DateTime.now().millisecondsSinceEpoch,
        isReadOnly: true,
      );

      expect(ReadOnlyRestrictionService.isReadOnlyCluster(readOnlyCluster), isTrue);
    });

    test('should return read-only indicator for demo clusters', () {
      final indicator = ReadOnlyRestrictionService.getReadOnlyIndicator(demoCluster);
      expect(indicator, isNotNull);

      final noIndicator = ReadOnlyRestrictionService.getReadOnlyIndicator(regularCluster);
      expect(noIndicator, isNull);
    });
  });

  group('ReadOnlyRestrictionService Widget Tests', () {
    late K8zCluster demoCluster;
    late K8zCluster regularCluster;

    setUp(() {
      demoCluster = K8zCluster.createDemo(
        name: 'Demo Cluster',
        server: 'https://demo.k8s.io',
        caData: 'demo-ca-data',
      );

      regularCluster = K8zCluster(
        name: 'Regular Cluster',
        server: 'https://prod.k8s.io',
        caData: 'prod-ca-data',
        namespace: 'default',
        insecure: false,
        clientKey: '',
        clientCert: '',
        username: '',
        password: '',
        token: '',
        createdAt: DateTime.now().millisecondsSinceEpoch,
      );
    });

    testWidgets('should wrap callbacks with read-only check', (WidgetTester tester) async {
      bool callbackExecuted = false;
      
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          home: Scaffold(
            body: Builder(
              builder: (context) {
                // For regular cluster, callback should be returned as-is
                final regularCallback = ReadOnlyRestrictionService.wrapWithReadOnlyCheck(
                  context: context,
                  cluster: regularCluster,
                  callback: () => callbackExecuted = true,
                  operationName: 'test',
                );
                
                // For demo cluster, callback should be wrapped
                final demoCallback = ReadOnlyRestrictionService.wrapWithReadOnlyCheck(
                  context: context,
                  cluster: demoCluster,
                  callback: () => callbackExecuted = true,
                  operationName: 'test',
                );
                
                return Column(
                  children: [
                    ElevatedButton(
                      onPressed: regularCallback,
                      child: const Text('Regular'),
                    ),
                    ElevatedButton(
                      onPressed: demoCallback,
                      child: const Text('Demo'),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );

      // Test regular cluster callback
      await tester.tap(find.text('Regular'));
      await tester.pump();
      expect(callbackExecuted, isTrue);

      // Reset and test demo cluster callback (should show message instead)
      callbackExecuted = false;
      await tester.tap(find.text('Demo'));
      await tester.pump();
      expect(callbackExecuted, isFalse); // Should not execute original callback
    });

    testWidgets('should create read-only actions correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          home: Scaffold(
            body: Builder(
              builder: (context) {
                final enabledAction = ElevatedButton(
                  onPressed: () {},
                  child: const Text('Action'),
                );

                final regularAction = ReadOnlyRestrictionService.createReadOnlyAction(
                  context: context,
                  cluster: regularCluster,
                  enabledAction: enabledAction,
                  operationName: 'test',
                );

                final demoAction = ReadOnlyRestrictionService.createReadOnlyAction(
                  context: context,
                  cluster: demoCluster,
                  enabledAction: enabledAction,
                  operationName: 'test',
                );

                return Column(
                  children: [
                    regularAction,
                    demoAction,
                  ],
                );
              },
            ),
          ),
        ),
      );

      await tester.pump();
      
      // Both actions should be present
      expect(find.text('Action'), findsNWidgets(2));
      
      // Demo action should be wrapped in Opacity and AbsorbPointer
      final demoActionWidget = tester.widget<Column>(find.byType(Column));
      expect(demoActionWidget.children.length, equals(2));
    });
  });
}