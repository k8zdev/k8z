import 'dart:async';
import 'dart:io';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:k8zdev/common/const.dart';
import 'package:k8zdev/common/ops.dart';
import 'package:k8zdev/dao/dao.dart';
import 'package:k8zdev/generated/l10n.dart';
import 'package:k8zdev/providers/current_cluster.dart';
import 'package:k8zdev/providers/lang.dart';
import 'package:k8zdev/providers/revenuecat_customer.dart';
import 'package:k8zdev/providers/talker.dart';
import 'package:k8zdev/providers/terminals.dart';
import 'package:k8zdev/providers/theme.dart';
import 'package:k8zdev/providers/timeout.dart';
import 'package:k8zdev/router.dart';
import 'package:k8zdev/services/k8z_native.dart';
import 'package:k8zdev/services/revenuecat.dart';
import 'package:k8zdev/services/stash.dart';
import 'package:k8zdev/theme/kung.dart';
import 'package:k8zdev/widgets/inherited.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:window_manager/window_manager.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initStash();
  await initStore();
  await initRevenueCatState();
  await K8zNative.startLocalServer();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseAnalytics.instance.setDefaultEventParameters({
    "app.mode": releaseMode,
    "dart.version": Platform.version,
    "locale.name": Platform.localeName,
    "os.name": Platform.operatingSystem,
    "localHostname": Platform.localHostname,
    "os.version": Platform.operatingSystemVersion,
    "environment": Platform.environment.toString(),
  });

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    // Must add this line.
    await windowManager.ensureInitialized();

    WindowOptions windowOptions = const WindowOptions(
      // center: true,
      size: initWinSize,
      skipTaskbar: false,
      minimumSize: minWinSize,
      titleBarStyle: TitleBarStyle.hidden,
      backgroundColor: Colors.transparent,
    );

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  var locale = CurrentLocale()..init();
  var themeMode = ThemeModeProvider()..init();
  var talkerMode = TalkerModeProvider()..init();
  var currentCluster = CurrentCluster()..init();
  var customerInfo = RevenueCatCustomer()..init();

  await customerInfo.fetchCusterInfo();
  Purchases.addCustomerInfoUpdateListener((info) {
    customerInfo.updateCustomerInfo(info);
  });

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<CurrentLocale>.value(value: locale),
        ChangeNotifierProvider<ThemeModeProvider>.value(value: themeMode),
        ChangeNotifierProvider<TalkerModeProvider>.value(value: talkerMode),
        ChangeNotifierProvider<CurrentCluster>.value(value: currentCluster),
        ChangeNotifierProvider<RevenueCatCustomer>.value(value: customerInfo),
        ChangeNotifierProvider(create: (_) => TerminalProvider()),
        ChangeNotifierProvider(create: (_) => TimeoutProvider()..init()),
      ],
      child: TalkerWrapper(
        talker: talker,
        options: const TalkerWrapperOptions(
          enableErrorAlerts: true,
        ),
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var _networkStatus = noneNetwork;
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen(
      (ConnectivityResult networkStatus) {
        updateNetworkStatus(networkStatus);
      },
    );
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    Purchases.removeCustomerInfoUpdateListener((customerInfo) {});

    super.dispose();
  }

  void updateNetworkStatus(ConnectivityResult status) {
    setState(() {
      _networkStatus = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    var current = Provider.of<CurrentLocale>(context, listen: true);

    return AppScope(
      networkStatus: _networkStatus,
      child: MaterialApp.router(
        title: 'K8Z',
        // routerConfig: _router,
        // 设置语言
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        locale: current.locale,
        themeMode: Provider.of<ThemeModeProvider>(context, listen: true).mode,
        darkTheme: ThemeData.dark(),
        supportedLocales: S.delegate.supportedLocales,
        routeInformationProvider: router.routeInformationProvider,
        routeInformationParser: router.routeInformationParser,
        routerDelegate: router.routerDelegate,
        theme: themeData(),
      ),
    );
  }
}
