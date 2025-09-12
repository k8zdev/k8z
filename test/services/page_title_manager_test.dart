import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:k8zdev/services/page_title_manager.dart';
import 'package:k8zdev/generated/l10n.dart';

void main() {
  group('PageTitleManager', () {
    testWidgets('generatePageTitle should return correct title for known screens', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            S.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          home: Builder(
            builder: (context) {
              // Test basic title generation
              final title = PageTitleManager.generatePageTitle(
                context: context,
                screenName: 'ClustersPage',
              );
              
              expect(title, contains('k8z'));
              expect(title, contains('Clusters'));
              
              return Container();
            },
          ),
        ),
      );
    });

    testWidgets('generatePageTitle should include context info', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            S.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          home: Builder(
            builder: (context) {
              final title = PageTitleManager.generatePageTitle(
                context: context,
                screenName: 'PodsPage',
                contextInfo: {
                  'cluster': 'test-cluster',
                  'namespace': 'default',
                },
              );
              
              expect(title, contains('k8z'));
              expect(title, contains('Pods'));
              expect(title, contains('test-cluster'));
              // default namespace should not be included
              expect(title, isNot(contains('default')));
              
              return Container();
            },
          ),
        ),
      );
    });

    testWidgets('generatePageTitle should use custom title when provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            S.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          home: Builder(
            builder: (context) {
              final title = PageTitleManager.generatePageTitle(
                context: context,
                screenName: 'PodsPage',
                customTitle: 'Custom Page Title',
              );
              
              expect(title, contains('k8z'));
              expect(title, contains('Custom Page Title'));
              expect(title, isNot(contains('Pods')));
              
              return Container();
            },
          ),
        ),
      );
    });

    test('generateAnalyticsParameters should include all provided parameters', () {
      final parameters = PageTitleManager.generateAnalyticsParameters(
        pageTitle: 'k8z - Pods - test-cluster',
        screenName: 'PodsPage',
        routePath: '/workloads/pods',
        language: 'en',
        contextInfo: {
          'cluster': 'test-cluster',
          'namespace': 'kube-system',
        },
      );

      expect(parameters['page_title'], equals('k8z - Pods - test-cluster'));
      expect(parameters['screen_name'], equals('PodsPage'));
      expect(parameters['route_path'], equals('/workloads/pods'));
      expect(parameters['language'], equals('en'));
      expect(parameters['context_cluster'], equals('test-cluster'));
      expect(parameters['context_namespace'], equals('kube-system'));
    });

    test('generateAnalyticsParameters should handle null values gracefully', () {
      final parameters = PageTitleManager.generateAnalyticsParameters(
        pageTitle: 'k8z - Settings',
        screenName: 'SettingsPage',
        routePath: '/settings',
      );

      expect(parameters['page_title'], equals('k8z - Settings'));
      expect(parameters['screen_name'], equals('SettingsPage'));
      expect(parameters['route_path'], equals('/settings'));
      expect(parameters.containsKey('language'), isFalse);
      expect(parameters.containsKey('context_cluster'), isFalse);
    });

    testWidgets('generatePageTitle should handle unknown screen names', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            S.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          home: Builder(
            builder: (context) {
              final title = PageTitleManager.generatePageTitle(
                context: context,
                screenName: 'UnknownPage',
              );
              
              expect(title, contains('k8z'));
              expect(title, contains('Unknown'));
              
              return Container();
            },
          ),
        ),
      );
    });

    testWidgets('generatePageTitle should truncate long titles', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            S.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          home: Builder(
            builder: (context) {
              final title = PageTitleManager.generatePageTitle(
                context: context,
                screenName: 'PodsPage',
                contextInfo: {
                  'cluster': 'very-long-cluster-name-that-exceeds-normal-limits',
                  'namespace': 'very-long-namespace-name-that-also-exceeds-limits',
                  'resource_name': 'very-long-resource-name-that-makes-title-too-long',
                },
              );
              
              expect(title.length, lessThanOrEqualTo(100));
              expect(title, endsWith('...'));
              
              return Container();
            },
          ),
        ),
      );
    });
  });
}