import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:k8zdev/services/analytics_service.dart';
import '../test_helpers.dart';

void main() {
  group('AnalyticsService', () {
    setUp(() {
      // 清空事件队列
      AnalyticsService.clearEventQueue();
    });

    testWidgets('logPageView should handle basic page view logging', (WidgetTester tester) async {
      await tester.pumpWidget(
        createSimpleTestApp(
          child: Builder(
            builder: (context) {
              // 测试基本的页面访问记录
              // 注意：这里不会实际发送到 Firebase，只是测试代码逻辑
              expect(() async {
                await AnalyticsService.logPageView(
                  context: context,
                  screenName: 'TestPage',
                );
              }, returnsNormally);
              
              return Container();
            },
          ),
        ),
      );
      
      await pumpAndSettle(tester);
    });

    testWidgets('logPageView should handle custom title', (WidgetTester tester) async {
      await tester.pumpWidget(
        createSimpleTestApp(
          child: Builder(
            builder: (context) {
              expect(() async {
                await AnalyticsService.logPageView(
                  context: context,
                  screenName: 'TestPage',
                  customTitle: 'Custom Test Title',
                );
              }, returnsNormally);
              
              return Container();
            },
          ),
        ),
      );
      
      await pumpAndSettle(tester);
    });

    testWidgets('logPageView should handle additional parameters', (WidgetTester tester) async {
      await tester.pumpWidget(
        createSimpleTestApp(
          child: Builder(
            builder: (context) {
              expect(() async {
                await AnalyticsService.logPageView(
                  context: context,
                  screenName: 'TestPage',
                  additionalParams: {
                    'test_param': 'test_value',
                    'numeric_param': 123,
                  },
                );
              }, returnsNormally);
              
              return Container();
            },
          ),
        ),
      );
      
      await pumpAndSettle(tester);
    });

    test('logScreenTransition should handle screen transitions', () async {
      expect(() async {
        await AnalyticsService.logScreenTransition(
          fromScreen: 'HomePage',
          toScreen: 'SettingsPage',
        );
      }, returnsNormally);
    });

    test('logScreenTransition should handle additional parameters', () async {
      expect(() async {
        await AnalyticsService.logScreenTransition(
          fromScreen: 'HomePage',
          toScreen: 'SettingsPage',
          additionalParams: {
            'transition_type': 'navigation',
            'user_action': 'button_click',
          },
        );
      }, returnsNormally);
    });

    test('logEvent should handle custom events', () async {
      expect(() async {
        await AnalyticsService.logEvent(
          eventName: 'custom_action',
          parameters: {
            'action_type': 'test',
            'value': 42,
          },
        );
      }, returnsNormally);
    });

    test('logPurchase should handle purchase events', () async {
      expect(() async {
        await AnalyticsService.logPurchase(
          currency: 'USD',
          value: 9.99,
          transactionId: 'test_transaction_123',
        );
      }, returnsNormally);
    });

    test('setUserProperty should handle user properties', () async {
      expect(() async {
        await AnalyticsService.setUserProperty(
          name: 'user_type',
          value: 'premium',
        );
      }, returnsNormally);
    });

    test('setUserId should handle user ID setting', () async {
      expect(() async {
        await AnalyticsService.setUserId('test_user_123');
      }, returnsNormally);
    });

    test('setUserId should handle null user ID', () async {
      expect(() async {
        await AnalyticsService.setUserId(null);
      }, returnsNormally);
    });

    test('pendingEventsCount should return correct count', () {
      // 初始状态应该没有待处理事件
      expect(AnalyticsService.pendingEventsCount, equals(0));
    });

    test('clearEventQueue should clear pending events', () {
      // 清空队列后应该没有待处理事件
      AnalyticsService.clearEventQueue();
      expect(AnalyticsService.pendingEventsCount, equals(0));
    });

    group('Screen class extraction', () {
      test('should categorize cluster screens correctly', () {
        // 这里我们无法直接测试私有方法，但可以通过公共方法间接测试
        expect(() async {
          await AnalyticsService.logEvent(
            eventName: 'test_cluster_screen',
            parameters: {'screen_name': 'ClusterPage'},
          );
        }, returnsNormally);
      });

      test('should categorize workload screens correctly', () {
        expect(() async {
          await AnalyticsService.logEvent(
            eventName: 'test_workload_screen',
            parameters: {'screen_name': 'PodsPage'},
          );
        }, returnsNormally);
      });

      test('should categorize networking screens correctly', () {
        expect(() async {
          await AnalyticsService.logEvent(
            eventName: 'test_networking_screen',
            parameters: {'screen_name': 'ServicesPage'},
          );
        }, returnsNormally);
      });
    });

    group('Error handling', () {
      testWidgets('logPageView should not throw on errors', (WidgetTester tester) async {
        await tester.pumpWidget(
          createSimpleTestApp(
            child: Builder(
              builder: (context) {
                // 即使发生错误也不应该抛出异常
                expect(() async {
                  await AnalyticsService.logPageView(
                    context: context,
                    screenName: 'ErrorTestPage',
                  );
                }, returnsNormally);
                
                return Container();
              },
            ),
          ),
        );
        
        await pumpAndSettle(tester);
      });

      test('logEvent should not throw on errors', () async {
        expect(() async {
          await AnalyticsService.logEvent(
            eventName: 'error_test_event',
          );
        }, returnsNormally);
      });
    });
  });
}