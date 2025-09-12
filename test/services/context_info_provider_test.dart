import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:k8zdev/services/context_info_provider.dart';
import '../test_helpers.dart';

void main() {
  group('ContextInfoProvider', () {
    testWidgets('should get current language', (WidgetTester tester) async {
      final localeProvider = MockCurrentLocale('zh');
      
      await tester.pumpWidget(
        createSimpleTestApp(
          localeProvider: localeProvider,
          child: Builder(
            builder: (context) {
              final language = ContextInfoProvider.getCurrentLanguage(context);
              expect(language, equals('zh'));
              
              return const Scaffold(body: Text('Test'));
            },
          ),
        ),
      );
      
      await pumpAndSettle(tester);
    });

    testWidgets('should return default language on error', (WidgetTester tester) async {
      // 测试在没有 Provider 的情况下的行为
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final language = ContextInfoProvider.getCurrentLanguage(context);
              expect(language, equals('en')); // 默认语言
              
              return const Text('Test');
            },
          ),
        ),
      );
      
      await pumpAndSettle(tester);
    });

    testWidgets('should get current context information', (WidgetTester tester) async {
      final mockCluster = MockCurrentCluster('test-cluster');
      final mockLocale = MockCurrentLocale('en');
      
      await tester.pumpWidget(
        createTestApp(
          initialRoute: '/clusters',
          currentCluster: mockCluster,
          localeProvider: mockLocale,
          child: Builder(
            builder: (context) {
              final contextInfo = ContextInfoProvider.getCurrentContext(context);
              
              // 应该包含语言信息
              expect(contextInfo['language'], equals('en'));
              
              // 应该包含集群信息
              expect(contextInfo['cluster'], equals('test-cluster'));
              
              // 在测试环境中，其他信息可能不可用，但不应该抛出异常
              expect(contextInfo, isA<Map<String, String>>());
              
              return const Scaffold(body: Text('Test'));
            },
          ),
        ),
      );
      
      await pumpAndSettle(tester);
    });

    test('should get current cluster name when available', () {
      // 测试静态方法
      final clusterName = ContextInfoProvider.getCurrentClusterName();
      // 在测试环境中，应该返回 null 而不是抛出异常
      expect(clusterName, isNull);
    });

    testWidgets('should handle missing providers gracefully', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              // 这些方法应该优雅地处理缺失的 Provider
              final clusterName = ContextInfoProvider.getCurrentClusterName(context);
              expect(clusterName, isNull);
              
              return const Scaffold(body: Text('Test'));
            },
          ),
        ),
      );
      
      await pumpAndSettle(tester);
    });

    testWidgets('should generate context description', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final description = ContextInfoProvider.generateContextDescription(context);
              
              // 应该返回一个字符串，即使在测试环境中信息有限
              expect(description, isA<String>());
              expect(description.isNotEmpty, isTrue);
              
              return Scaffold(body: Text(description));
            },
          ),
        ),
      );
      
      await pumpAndSettle(tester);
    });

    testWidgets('should check cluster context availability', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final hasClusterContext = ContextInfoProvider.hasClusterContext(context);
              
              // 在测试环境中应该返回 false
              expect(hasClusterContext, isFalse);
              
              return const Scaffold(body: Text('Test'));
            },
          ),
        ),
      );
      
      await pumpAndSettle(tester);
    });

    testWidgets('should check namespace context availability', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final hasNamespaceContext = ContextInfoProvider.hasNamespaceContext(context);
              
              // 在测试环境中应该返回 false
              expect(hasNamespaceContext, isFalse);
              
              return const Scaffold(body: Text('Test'));
            },
          ),
        ),
      );
      
      await pumpAndSettle(tester);
    });

    testWidgets('should check if on resource detail page', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final isResourceDetail = ContextInfoProvider.isResourceDetailPage(context);
              
              // 在测试环境中应该返回 false
              expect(isResourceDetail, isFalse);
              
              return const Scaffold(body: Text('Test'));
            },
          ),
        ),
      );
      
      await pumpAndSettle(tester);
    });

    group('Error handling', () {
      testWidgets('should handle context errors gracefully', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                // 这些调用不应该抛出异常，即使在不完整的测试环境中
                expect(() {
                  ContextInfoProvider.getCurrentContext(context);
                }, returnsNormally);
                
                expect(() {
                  ContextInfoProvider.getCurrentClusterName(context);
                }, returnsNormally);
                
                expect(() {
                  ContextInfoProvider.getCurrentNamespace(context);
                }, returnsNormally);
                
                expect(() {
                  ContextInfoProvider.getCurrentRoutePath(context);
                }, returnsNormally);
                
                expect(() {
                  ContextInfoProvider.getResourceInfoFromRoute(context);
                }, returnsNormally);
                
                return const Scaffold(body: Text('Test'));
              },
            ),
          ),
        );
        
        await pumpAndSettle(tester);
      });

      test('should handle static method calls without context', () {
        // 测试静态方法在没有上下文时的行为
        expect(() {
          ContextInfoProvider.getCurrentClusterName();
        }, returnsNormally);
        
        expect(() {
          ContextInfoProvider.hasClusterContext();
        }, returnsNormally);
      });
    });

    group('Resource info extraction', () {
      testWidgets('should extract resource info from route', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                final resourceInfo = ContextInfoProvider.getResourceInfoFromRoute(context);
                
                // 应该返回一个 Map，即使在测试环境中可能为空
                expect(resourceInfo, isA<Map<String, String>>());
                
                return const Scaffold(body: Text('Test'));
              },
            ),
          ),
        );
        
        await pumpAndSettle(tester);
      });
    });

    group('Language detection', () {
      testWidgets('should detect en language', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            locale: const Locale('en', 'US'),
            home: Builder(
              builder: (context) {
                final language = ContextInfoProvider.getCurrentLanguage(context);
                expect(language, equals('en'));
                
                return const Scaffold(body: Text('Test'));
              },
            ),
          ),
        );
        
        await pumpAndSettle(tester);
      });

      testWidgets('should handle language detection gracefully', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            locale: const Locale('zh', 'CN'),
            home: Builder(
              builder: (context) {
                final language = ContextInfoProvider.getCurrentLanguage(context);
                // 在测试环境中，可能会回退到默认语言
                expect(language, isA<String>());
                expect(language.isNotEmpty, isTrue);
                
                return const Scaffold(body: Text('Test'));
              },
            ),
          ),
        );
        
        await pumpAndSettle(tester);
      });
    });
  });
}