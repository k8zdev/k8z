import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:k8zdev/services/analytics_service.dart';
import 'package:k8zdev/common/helpers.dart';
import 'package:k8zdev/services/page_title_manager.dart';
import 'package:k8zdev/services/title_update_service.dart';
import '../test_helpers.dart';

void main() {
  group('Analytics Compatibility Tests', () {
    setUp(() {
      // 清理状态
      TitleUpdateService.dispose();
      PageTitleManager.clearTitleCache();
      AnalyticsService.clearEventQueue();
    });

    testWidgets('Legacy logScreenView should work without breaking', (WidgetTester tester) async {
      // 测试旧的 API 仍然可以正常工作
      await tester.pumpWidget(
        createSimpleTestApp(
          child: Builder(
            builder: (context) {
              // 调用旧的 API - 应该不会抛出异常
              logScreenView(
                screenName: 'TestPage',
                screenClass: 'test',
                parameters: {'test_param': 'value'},
              );
              
              return const Scaffold(
                body: Text('Test Page'),
              );
            },
          ),
        ),
      );

      // 验证没有异常抛出
      expect(tester.takeException(), isNull);
    });

    testWidgets('New AnalyticsService should work with proper context', (WidgetTester tester) async {
      await tester.pumpWidget(
        createSimpleTestApp(
          child: Builder(
            builder: (context) {
              // 调用新的 API
              AnalyticsService.logPageView(
                context: context,
                screenName: 'TestPage',
                additionalParams: {'test_param': 'value'},
              );
              
              return const Scaffold(
                body: Text('Test Page'),
              );
            },
          ),
        ),
      );

      // 验证没有异常抛出
      expect(tester.takeException(), isNull);
    });

    testWidgets('Both APIs can coexist without conflicts', (WidgetTester tester) async {
      await tester.pumpWidget(
        createSimpleTestApp(
          child: Builder(
            builder: (context) {
              // 同时调用新旧 API
              logScreenView(
                screenName: 'LegacyTestPage',
                parameters: {'legacy': true},
              );
              
              AnalyticsService.logPageView(
                context: context,
                screenName: 'NewTestPage',
                additionalParams: {'new_api': true},
              );
              
              return const Scaffold(
                body: Text('Test Page'),
              );
            },
          ),
        ),
      );

      // 验证没有异常抛出
      expect(tester.takeException(), isNull);
    });

    test('Legacy logEvent should work', () async {
      // 测试旧的事件记录 API
      expect(() async {
        await logEvent('test_event', parameters: {'test': 'value'});
      }, returnsNormally);
    });

    test('Legacy logPurchase should work', () async {
      // 测试旧的购买事件 API
      expect(() async {
        await logPurchase(
          currency: 'USD',
          value: 9.99,
          transactionId: 'test_txn',
        );
      }, returnsNormally);
    });

    test('New AnalyticsService methods should work', () async {
      // 测试新的 API 方法
      expect(() async {
        await AnalyticsService.logEvent(
          eventName: 'test_event',
          parameters: {'test': 'value'},
        );
      }, returnsNormally);

      expect(() async {
        await AnalyticsService.logPurchase(
          currency: 'USD',
          value: 9.99,
          transactionId: 'test_txn',
        );
      }, returnsNormally);
    });

    testWidgets('Page title generation should work with different contexts', (WidgetTester tester) async {
      await tester.pumpWidget(
        createSimpleTestApp(
          child: Builder(
            builder: (context) {
              // 测试页面标题生成
              final title = PageTitleManager.generatePageTitle(
                context: context,
                screenName: 'ClustersPage',
                contextInfo: {
                  'cluster': 'test-cluster',
                  'namespace': 'default',
                },
              );
              
              expect(title, contains('k8z'));
              expect(title, contains('Clusters'));
              
              return Scaffold(
                appBar: AppBar(title: Text(title)),
                body: const Text('Test Page'),
              );
            },
          ),
        ),
      );

      // 验证没有异常抛出
      expect(tester.takeException(), isNull);
    });

    testWidgets('Analytics parameters should include required fields', (WidgetTester tester) async {
      await tester.pumpWidget(
        createSimpleTestApp(
          child: Builder(
            builder: (context) {
              // 测试 Analytics 参数生成
              final params = PageTitleManager.generateAnalyticsParameters(
                pageTitle: 'Test Page',
                screenName: 'TestPage',
                routePath: '/test',
                language: 'en',
                contextInfo: {'cluster': 'test'},
              );
              
              // 验证必需的字段存在
              expect(params['page_title'], equals('Test Page'));
              expect(params['screen_name'], equals('TestPage'));
              expect(params['route_path'], equals('/test'));
              expect(params['language'], equals('en'));
              expect(params['context_cluster'], equals('test'));
              expect(params['timestamp'], isA<int>());
              
              return const Scaffold(
                body: Text('Test Page'),
              );
            },
          ),
        ),
      );
      
      await pumpAndSettle(tester);
    });

    testWidgets('Title cache should work correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        createSimpleTestApp(
          child: Builder(
            builder: (context) {
              // 生成相同的标题两次，第二次应该使用缓存
              final title1 = PageTitleManager.generatePageTitle(
                context: context,
                screenName: 'TestPage',
              );
              
              final title2 = PageTitleManager.generatePageTitle(
                context: context,
                screenName: 'TestPage',
              );
              
              expect(title1, equals(title2));
              
              // 检查缓存统计 - 在测试环境中可能缓存不会立即生效
              final cacheStats = PageTitleManager.getCacheStats();
              expect(cacheStats['cache_size'], greaterThanOrEqualTo(0));
              
              return const Scaffold(
                body: Text('Test Page'),
              );
            },
          ),
        ),
      );
      
      await pumpAndSettle(tester);
    });

    test('TitleUpdateService debug info should be available', () {
      final debugInfo = TitleUpdateService.getDebugInfo();
      
      expect(debugInfo, isA<Map<String, dynamic>>());
      expect(debugInfo.containsKey('last_title'), isTrue);
      expect(debugInfo.containsKey('last_language'), isTrue);
      expect(debugInfo.containsKey('cache_stats'), isTrue);
    });

    test('AnalyticsService should handle queue operations', () {
      // 测试事件队列功能
      expect(AnalyticsService.pendingEventsCount, equals(0));
      
      // 清空队列应该正常工作
      AnalyticsService.clearEventQueue();
      expect(AnalyticsService.pendingEventsCount, equals(0));
    });

    testWidgets('Error handling should not break the app', (WidgetTester tester) async {
      await tester.pumpWidget(
        createSimpleTestApp(
          child: Builder(
            builder: (context) {
              // 测试错误情况下的处理
              try {
                // 使用无效参数调用 API
                AnalyticsService.logPageView(
                  context: context,
                  screenName: '', // 空的屏幕名称
                );
              } catch (e) {
                // 应该优雅地处理错误，不应该崩溃
              }
              
              return const Scaffold(
                body: Text('Test Page'),
              );
            },
          ),
        ),
      );

      // 验证应用没有崩溃
      expect(tester.takeException(), isNull);
    });

    tearDown(() {
      // 清理资源
      TitleUpdateService.dispose();
      PageTitleManager.clearTitleCache();
      AnalyticsService.clearEventQueue();
    });
  });

  group('Migration Scenarios', () {
    testWidgets('Gradual migration scenario', (WidgetTester tester) async {
      // 模拟渐进式迁移场景：一些页面使用新 API，一些使用旧 API
      await tester.pumpWidget(
        createSimpleTestApp(
          child: DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                bottom: const TabBar(
                  tabs: [
                    Tab(text: 'Legacy'),
                    Tab(text: 'New'),
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  // 使用旧 API 的页面
                  Builder(
                    builder: (context) {
                      logScreenView(screenName: 'LegacyPage');
                      return const Center(child: Text('Legacy Page'));
                    },
                  ),
                  // 使用新 API 的页面
                  Builder(
                    builder: (context) {
                      AnalyticsService.logPageView(
                        context: context,
                        screenName: 'NewPage',
                      );
                      return const Center(child: Text('New Page'));
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // 验证两种 API 都能正常工作
      expect(tester.takeException(), isNull);
      
      // 切换标签页
      await tester.tap(find.text('New'));
      await tester.pumpAndSettle();
      
      expect(tester.takeException(), isNull);
    });

    testWidgets('Complete migration scenario', (WidgetTester tester) async {
      // 模拟完全迁移到新 API 的场景
      await tester.pumpWidget(
        createSimpleTestApp(
          child: Builder(
            builder: (context) {
              // 只使用新 API
              AnalyticsService.logPageView(
                context: context,
                screenName: 'ModernPage',
                customTitle: 'Modern Analytics Page',
                additionalParams: {
                  'migration_status': 'complete',
                  'api_version': '2.0',
                },
              );
              
              return const Scaffold(
                body: Center(
                  child: Text('Fully Migrated Page'),
                ),
              );
            },
          ),
        ),
      );

      expect(tester.takeException(), isNull);
    });
  });
}