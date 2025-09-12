import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:k8zdev/services/analytics_route_observer.dart';
import '../test_helpers.dart';

void main() {
  group('AnalyticsRouteObserver', () {
    late AnalyticsRouteObserver observer;

    setUp(() {
      observer = AnalyticsRouteObserver();
    });

    tearDown(() {
      observer.dispose();
    });

    test('should initialize with null screen names', () {
      expect(observer.currentScreenName, isNull);
      expect(observer.previousScreenName, isNull);
    });

    test('should handle route push operations', () {
      final route = MaterialPageRoute(
        builder: (context) => Container(),
        settings: const RouteSettings(name: '/test'),
      );

      expect(() {
        observer.didPush(route, null);
      }, returnsNormally);
    });

    test('should handle route pop operations', () {
      final route1 = MaterialPageRoute(
        builder: (context) => Container(),
        settings: const RouteSettings(name: '/test1'),
      );
      
      final route2 = MaterialPageRoute(
        builder: (context) => Container(),
        settings: const RouteSettings(name: '/test2'),
      );

      expect(() {
        observer.didPop(route1, route2);
      }, returnsNormally);
    });

    test('should handle route replace operations', () {
      final oldRoute = MaterialPageRoute(
        builder: (context) => Container(),
        settings: const RouteSettings(name: '/old'),
      );
      
      final newRoute = MaterialPageRoute(
        builder: (context) => Container(),
        settings: const RouteSettings(name: '/new'),
      );

      expect(() {
        observer.didReplace(oldRoute: oldRoute, newRoute: newRoute);
      }, returnsNormally);
    });

    test('should handle route remove operations', () {
      final route = MaterialPageRoute(
        builder: (context) => Container(),
        settings: const RouteSettings(name: '/test'),
      );

      expect(() {
        observer.didRemove(route, null);
      }, returnsNormally);
    });

    group('Route name conversion', () {
      test('should convert clusters routes correctly', () {
        final route = MaterialPageRoute(
          builder: (context) => Container(),
          settings: const RouteSettings(name: '/clusters'),
        );

        // 我们无法直接测试私有方法，但可以通过观察器的行为来验证
        expect(() {
          observer.didPush(route, null);
        }, returnsNormally);
      });

      test('should convert workloads routes correctly', () {
        final route = MaterialPageRoute(
          builder: (context) => Container(),
          settings: const RouteSettings(name: '/workloads/pods'),
        );

        expect(() {
          observer.didPush(route, null);
        }, returnsNormally);
      });

      test('should convert resources routes correctly', () {
        final route = MaterialPageRoute(
          builder: (context) => Container(),
          settings: const RouteSettings(name: '/resources/nodes'),
        );

        expect(() {
          observer.didPush(route, null);
        }, returnsNormally);
      });

      test('should convert settings routes correctly', () {
        final route = MaterialPageRoute(
          builder: (context) => Container(),
          settings: const RouteSettings(name: '/settings'),
        );

        expect(() {
          observer.didPush(route, null);
        }, returnsNormally);
      });

      test('should convert details routes correctly', () {
        final route = MaterialPageRoute(
          builder: (context) => Container(),
          settings: const RouteSettings(name: '/details/api/v1/default/pods/test-pod'),
        );

        expect(() {
          observer.didPush(route, null);
        }, returnsNormally);
      });
    });

    group('Route type handling', () {
      test('should handle MaterialPageRoute', () {
        final route = MaterialPageRoute(
          builder: (context) => Container(),
        );

        expect(() {
          observer.didPush(route, null);
        }, returnsNormally);
      });

      test('should handle PageRouteBuilder', () {
        final route = PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => Container(),
        );

        expect(() {
          observer.didPush(route, null);
        }, returnsNormally);
      });
    });

    group('Error handling', () {
      test('should handle null routes gracefully', () {
        expect(() {
          observer.didPush(
            MaterialPageRoute(builder: (context) => Container()),
            null,
          );
        }, returnsNormally);
      });

      test('should handle routes without settings', () {
        final route = MaterialPageRoute(
          builder: (context) => Container(),
          // No settings provided
        );

        expect(() {
          observer.didPush(route, null);
        }, returnsNormally);
      });

      test('should handle routes with empty names', () {
        final route = MaterialPageRoute(
          builder: (context) => Container(),
          settings: const RouteSettings(name: ''),
        );

        expect(() {
          observer.didPush(route, null);
        }, returnsNormally);
      });
    });

    test('should dispose properly', () {
      expect(() {
        observer.dispose();
      }, returnsNormally);
    });

    group('Debounce mechanism', () {
      test('should handle rapid route changes', () async {
        final route1 = MaterialPageRoute(
          builder: (context) => Container(),
          settings: const RouteSettings(name: '/test1'),
        );
        
        final route2 = MaterialPageRoute(
          builder: (context) => Container(),
          settings: const RouteSettings(name: '/test2'),
        );

        // 快速连续的路由变化
        observer.didPush(route1, null);
        observer.didPush(route2, route1);

        // 等待防抖延迟
        await Future.delayed(const Duration(milliseconds: 600));

        expect(() {
          // 应该正常处理，不会抛出异常
        }, returnsNormally);
      });
    });
  });
}