import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:k8zdev/generated/l10n.dart';
import 'package:k8zdev/providers/current_cluster.dart';
import 'package:k8zdev/providers/lang.dart';
import 'package:k8zdev/dao/kube.dart';

/// 创建测试用的 Widget 包装器，包含必要的 Provider 和本地化设置
Widget createTestApp({
  required Widget child,
  String? initialRoute,
  CurrentCluster? currentCluster,
  CurrentLocale? localeProvider,
}) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider<CurrentCluster>(
        create: (_) => currentCluster ?? MockCurrentCluster(),
      ),
      ChangeNotifierProvider<CurrentLocale>(
        create: (_) => localeProvider ?? MockCurrentLocale(),
      ),
    ],
    child: MaterialApp.router(
      routerConfig: GoRouter(
        initialLocation: initialRoute ?? '/',
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => child,
          ),
          GoRoute(
            path: '/clusters',
            builder: (context, state) => child,
          ),
          GoRoute(
            path: '/workloads',
            builder: (context, state) => child,
          ),
          GoRoute(
            path: '/pods',
            builder: (context, state) => child,
          ),
          GoRoute(
            path: '/deployments',
            builder: (context, state) => child,
          ),
          GoRoute(
            path: '/services',
            builder: (context, state) => child,
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => child,
          ),
        ],
      ),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
    ),
  );
}

/// 创建简单的测试 Widget 包装器，不包含路由
Widget createSimpleTestApp({
  required Widget child,
  CurrentCluster? currentCluster,
  CurrentLocale? localeProvider,
}) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider<CurrentCluster>(
        create: (_) => currentCluster ?? MockCurrentCluster(),
      ),
      ChangeNotifierProvider<CurrentLocale>(
        create: (_) => localeProvider ?? MockCurrentLocale(),
      ),
    ],
    child: MaterialApp(
      home: child,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
    ),
  );
}

/// 创建 Mock CurrentCluster 用于测试
class MockCurrentCluster extends CurrentCluster {
  K8zCluster? _mockCluster;
  
  MockCurrentCluster([String? clusterName]) {
    if (clusterName != null) {
      _mockCluster = K8zCluster(
        name: clusterName,
        server: 'https://test-server',
        caData: 'test-ca-data',
        namespace: 'default',
        insecure: false,
        clientKey: 'test-client-key',
        clientCert: 'test-client-cert',
        username: 'test-user',
        password: 'test-password',
        token: 'test-token',
        createdAt: DateTime.now().millisecondsSinceEpoch,
      );
    }
  }
  
  @override
  K8zCluster? get cluster => _mockCluster;
  
  void setMockCluster(K8zCluster? cluster) {
    _mockCluster = cluster;
    notifyListeners();
  }
}

/// 创建 Mock CurrentLocale 用于测试
class MockCurrentLocale extends CurrentLocale {
  String _mockLanguage = 'en';
  
  MockCurrentLocale([this._mockLanguage = 'en']);
  
  @override
  String get languageCode => _mockLanguage;
  
  void setMockLanguage(String language) {
    _mockLanguage = language;
    notifyListeners();
  }
}

/// 等待 Widget 完全构建
Future<void> pumpAndSettle(WidgetTester tester) async {
  await tester.pumpAndSettle();
  // 额外等待以确保所有异步操作完成
  await tester.pump(const Duration(milliseconds: 100));
}