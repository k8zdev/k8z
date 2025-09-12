import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:k8zdev/services/title_update_service.dart';
import 'package:k8zdev/services/page_title_manager.dart';
import '../test_helpers.dart';

void main() {
  group('TitleUpdateService', () {
    setUp(() {
      // 清理状态
      TitleUpdateService.dispose();
      PageTitleManager.clearTitleCache();
    });

    testWidgets('should handle language change', (WidgetTester tester) async {
      await tester.pumpWidget(
        createSimpleTestApp(
          child: Builder(
            builder: (context) {
              // 模拟语言切换
              TitleUpdateService.handleLanguageChange(
                context: context,
                newLanguage: 'zh',
                oldLanguage: 'en',
              );
              
              return const Scaffold(
                body: Text('Test'),
              );
            },
          ),
        ),
      );

      // 等待定时器完成
      await tester.pump(const Duration(milliseconds: 600));

      // 验证没有异常抛出
      expect(tester.takeException(), isNull);
    });

    testWidgets('should handle cluster change', (WidgetTester tester) async {
      await tester.pumpWidget(
        createSimpleTestApp(
          child: Builder(
            builder: (context) {
              // 模拟集群切换
              TitleUpdateService.handleClusterChange(
                context: context,
                newCluster: 'test-cluster',
                oldCluster: null,
              );
              
              return const Scaffold(
                body: Text('Test'),
              );
            },
          ),
        ),
      );

      // 等待定时器完成
      await tester.pump(const Duration(milliseconds: 600));

      // 验证没有异常抛出
      expect(tester.takeException(), isNull);
    });

    testWidgets('should handle namespace change', (WidgetTester tester) async {
      await tester.pumpWidget(
        createSimpleTestApp(
          child: Builder(
            builder: (context) {
              // 模拟命名空间切换
              TitleUpdateService.handleNamespaceChange(
                context: context,
                newNamespace: 'test-namespace',
                oldNamespace: 'default',
              );
              
              return const Scaffold(
                body: Text('Test'),
              );
            },
          ),
        ),
      );

      // 等待定时器完成
      await tester.pump(const Duration(milliseconds: 600));

      // 验证没有异常抛出
      expect(tester.takeException(), isNull);
    });

    testWidgets('should handle route change', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestApp(
          initialRoute: '/clusters',
          child: Builder(
            builder: (context) {
              // 模拟路由切换
              TitleUpdateService.handleRouteChange(
                context: context,
                newRoutePath: '/clusters',
                screenName: 'ClustersPage',
              );
              
              return const Scaffold(
                body: Text('Test'),
              );
            },
          ),
        ),
      );

      // 等待定时器完成
      await tester.pump(const Duration(milliseconds: 600));

      // 验证没有异常抛出
      expect(tester.takeException(), isNull);
    });

    test('should provide debug info', () {
      final debugInfo = TitleUpdateService.getDebugInfo();
      
      expect(debugInfo, isA<Map<String, dynamic>>());
      expect(debugInfo.containsKey('last_title'), isTrue);
      expect(debugInfo.containsKey('last_language'), isTrue);
      expect(debugInfo.containsKey('last_cluster'), isTrue);
      expect(debugInfo.containsKey('last_namespace'), isTrue);
      expect(debugInfo.containsKey('last_route_path'), isTrue);
      expect(debugInfo.containsKey('has_pending_timer'), isTrue);
      expect(debugInfo.containsKey('cache_stats'), isTrue);
    });

    testWidgets('should check if title update is needed', (WidgetTester tester) async {
      await tester.pumpWidget(
        createSimpleTestApp(
          child: Builder(
            builder: (context) {
              // 检查是否需要更新标题
              final shouldUpdate = TitleUpdateService.shouldUpdateTitle(
                context: context,
                screenName: 'ClustersPage',
              );
              
              // 第一次调用应该返回 true（因为没有之前的状态）
              expect(shouldUpdate, isTrue);
              
              return const Scaffold(
                body: Text('Test'),
              );
            },
          ),
        ),
      );
      
      await pumpAndSettle(tester);
    });

    testWidgets('should force refresh title', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestApp(
          initialRoute: '/clusters',
          child: Builder(
            builder: (context) {
              // 强制刷新标题
              TitleUpdateService.forceRefreshTitle(
                context: context,
                screenName: 'ClustersPage',
                reason: 'test_refresh',
              );
              
              return const Scaffold(
                body: Text('Test'),
              );
            },
          ),
        ),
      );

      // 验证没有异常抛出
      expect(tester.takeException(), isNull);
    });

    tearDown(() {
      // 清理资源
      TitleUpdateService.dispose();
    });
  });
}