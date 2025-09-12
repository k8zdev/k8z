import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:k8zdev/services/page_title_manager.dart';
import '../test_helpers.dart';

void main() {
  group('PageTitleManager', () {
    setUp(() {
      // 清理缓存
      PageTitleManager.clearTitleCache();
    });

    testWidgets('should generate basic page title', (WidgetTester tester) async {
      await tester.pumpWidget(
        createSimpleTestApp(
          child: Builder(
            builder: (context) {
              final title = PageTitleManager.generatePageTitle(
                context: context,
                screenName: 'ClustersPage',
              );
              
              expect(title, contains('k8z'));
              expect(title, contains('Clusters'));
              
              return Scaffold(body: Text(title));
            },
          ),
        ),
      );
      
      await pumpAndSettle(tester);
    });

    testWidgets('should use custom title when provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        createSimpleTestApp(
          child: Builder(
            builder: (context) {
              final title = PageTitleManager.generatePageTitle(
                context: context,
                screenName: 'TestPage',
                customTitle: 'My Custom Title',
              );
              
              expect(title, contains('My Custom Title'));
              expect(title, contains('k8z'));
              
              return Scaffold(body: Text(title));
            },
          ),
        ),
      );
      
      await pumpAndSettle(tester);
    });

    testWidgets('should include context information in title', (WidgetTester tester) async {
      await tester.pumpWidget(
        createSimpleTestApp(
          child: Builder(
            builder: (context) {
              final title = PageTitleManager.generatePageTitle(
                context: context,
                screenName: 'PodsPage',
                contextInfo: {
                  'cluster': 'test-cluster',
                  'namespace': 'kube-system',
                },
              );
              
              expect(title, contains('k8z'));
              expect(title, contains('test-cluster'));
              expect(title, contains('kube-system'));
              
              return Scaffold(body: Text(title));
            },
          ),
        ),
      );
      
      await pumpAndSettle(tester);
    });

    testWidgets('should handle resource details in title', (WidgetTester tester) async {
      await tester.pumpWidget(
        createSimpleTestApp(
          child: Builder(
            builder: (context) {
              final title = PageTitleManager.generatePageTitle(
                context: context,
                screenName: 'DetailsPage',
                contextInfo: {
                  'cluster': 'prod-cluster',
                  'namespace': 'default',
                  'resource_name': 'nginx-deployment',
                },
              );
              
              expect(title, contains('k8z'));
              expect(title, contains('prod-cluster'));
              expect(title, contains('nginx-deployment'));
              
              return Scaffold(body: Text(title));
            },
          ),
        ),
      );
      
      await pumpAndSettle(tester);
    });

    testWidgets('should truncate long titles', (WidgetTester tester) async {
      await tester.pumpWidget(
        createSimpleTestApp(
          child: Builder(
            builder: (context) {
              final longTitle = 'This is a very long custom title that should be truncated because it exceeds the maximum length limit and continues for even more text to ensure truncation';
              final title = PageTitleManager.generatePageTitle(
                context: context,
                screenName: 'TestPage',
                customTitle: longTitle,
              );
              
              expect(title.length, lessThanOrEqualTo(100));
              if (title.length == 100) {
                expect(title, endsWith('...'));
              }
              
              return Scaffold(body: Text(title));
            },
          ),
        ),
      );
      
      await pumpAndSettle(tester);
    });

    test('should generate correct Analytics parameters', () {
      final params = PageTitleManager.generateAnalyticsParameters(
        pageTitle: 'Test Page Title',
        screenName: 'TestPage',
        routePath: '/test',
        language: 'en',
        contextInfo: {
          'cluster': 'test-cluster',
          'namespace': 'default',
        },
      );

      expect(params['page_title'], equals('Test Page Title'));
      expect(params['screen_name'], equals('TestPage'));
      expect(params['route_path'], equals('/test'));
      expect(params['language'], equals('en'));
      expect(params['context_cluster'], equals('test-cluster'));
      expect(params['context_namespace'], equals('default'));
      expect(params['timestamp'], isA<int>());
      expect(params['language_fallback'], isFalse);
    });

    test('should handle missing language in Analytics parameters', () {
      final params = PageTitleManager.generateAnalyticsParameters(
        pageTitle: 'Test Page Title',
        screenName: 'TestPage',
        routePath: '/test',
        language: null,
      );

      expect(params['language'], equals('en')); // 默认语言
      expect(params['language_fallback'], isTrue);
    });

    test('should filter empty context values', () {
      final params = PageTitleManager.generateAnalyticsParameters(
        pageTitle: 'Test Page Title',
        screenName: 'TestPage',
        routePath: '/test',
        language: 'en',
        contextInfo: {
          'cluster': 'test-cluster',
          'namespace': '', // 空值应该被过滤
          'resource_name': 'test-resource',
        },
      );

      expect(params['context_cluster'], equals('test-cluster'));
      expect(params['context_resource_name'], equals('test-resource'));
      expect(params.containsKey('context_namespace'), isFalse);
    });

    test('should handle cache operations correctly', () {
      // 初始状态
      var stats = PageTitleManager.getCacheStats();
      expect(stats['cache_size'], equals(0));

      // 清空缓存
      PageTitleManager.clearTitleCache();
      stats = PageTitleManager.getCacheStats();
      expect(stats['cache_size'], equals(0));
      expect(stats['max_cache_size'], equals(50));
      expect(stats['cached_keys'], isA<List>());
    });

    group('Screen name mapping', () {
      final testCases = [
        {'screenName': 'ClustersPage', 'expectedContains': 'Clusters'},
        {'screenName': 'WorkloadsPage', 'expectedContains': 'Workloads'},
        {'screenName': 'PodsPage', 'expectedContains': 'Pods'},
        {'screenName': 'DeploymentsPage', 'expectedContains': 'Deployments'},
        {'screenName': 'ServicesPage', 'expectedContains': 'Services'},
        {'screenName': 'SettingsPage', 'expectedContains': 'Settings'},
        {'screenName': 'NotFoundPage', 'expectedContains': 'Not Found'},
      ];

      for (final testCase in testCases) {
        testWidgets('should map ${testCase['screenName']} correctly', (WidgetTester tester) async {
          await tester.pumpWidget(
            createSimpleTestApp(
              child: Builder(
                builder: (context) {
                  final title = PageTitleManager.generatePageTitle(
                    context: context,
                    screenName: testCase['screenName'] as String,
                  );
                  
                  expect(title, contains(testCase['expectedContains'] as String));
                  
                  return Scaffold(body: Text(title));
                },
              ),
            ),
          );
          
          await pumpAndSettle(tester);
        });
      }
    });

    group('Context information handling', () {
      testWidgets('should skip default namespace', (WidgetTester tester) async {
        await tester.pumpWidget(
          createSimpleTestApp(
            child: Builder(
              builder: (context) {
                final title = PageTitleManager.generatePageTitle(
                  context: context,
                  screenName: 'PodsPage',
                  contextInfo: {
                    'cluster': 'test-cluster',
                    'namespace': 'default', // 默认命名空间应该被跳过
                  },
                );
                
                expect(title, contains('test-cluster'));
                expect(title, isNot(contains('default')));
                
                return Scaffold(body: Text(title));
              },
            ),
          ),
        );
        
        await pumpAndSettle(tester);
      });

      testWidgets('should include non-default namespace', (WidgetTester tester) async {
        await tester.pumpWidget(
          createSimpleTestApp(
            child: Builder(
              builder: (context) {
                final title = PageTitleManager.generatePageTitle(
                  context: context,
                  screenName: 'PodsPage',
                  contextInfo: {
                    'cluster': 'test-cluster',
                    'namespace': 'kube-system',
                  },
                );
                
                expect(title, contains('test-cluster'));
                expect(title, contains('kube-system'));
                
                return Scaffold(body: Text(title));
              },
            ),
          ),
        );
        
        await pumpAndSettle(tester);
      });

      testWidgets('should handle missing context gracefully', (WidgetTester tester) async {
        await tester.pumpWidget(
          createSimpleTestApp(
            child: Builder(
              builder: (context) {
                final title = PageTitleManager.generatePageTitle(
                  context: context,
                  screenName: 'PodsPage',
                  contextInfo: null,
                );
                
                expect(title, contains('k8z'));
                expect(title, contains('Pods'));
                
                return Scaffold(body: Text(title));
              },
            ),
          ),
        );
        
        await pumpAndSettle(tester);
      });
    });

    group('Error handling', () {
      testWidgets('should handle unknown screen names', (WidgetTester tester) async {
        await tester.pumpWidget(
          createSimpleTestApp(
            child: Builder(
              builder: (context) {
                final title = PageTitleManager.generatePageTitle(
                  context: context,
                  screenName: 'UnknownPage',
                );
                
                expect(title, contains('k8z'));
                expect(title, contains('Unknown'));
                
                return Scaffold(body: Text(title));
              },
            ),
          ),
        );
        
        await pumpAndSettle(tester);
      });

      testWidgets('should handle empty screen names', (WidgetTester tester) async {
        await tester.pumpWidget(
          createSimpleTestApp(
            child: Builder(
              builder: (context) {
                final title = PageTitleManager.generatePageTitle(
                  context: context,
                  screenName: '',
                );
                
                expect(title, contains('k8z'));
                
                return Scaffold(body: Text(title));
              },
            ),
          ),
        );
        
        await pumpAndSettle(tester);
      });
    });

    tearDown(() {
      // 清理缓存
      PageTitleManager.clearTitleCache();
    });
  });
}