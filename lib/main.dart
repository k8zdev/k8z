import 'dart:async';
import 'dart:io';
import 'package:collection/collection.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:k8zdev/common/const.dart';
import 'package:k8zdev/common/ops.dart';
import 'package:k8zdev/dao/dao.dart';
import 'package:k8zdev/dao/kube.dart';
import 'package:k8zdev/generated/l10n.dart';
import 'package:k8zdev/providers/current_cluster.dart';
import 'package:k8zdev/providers/lang.dart';
import 'package:k8zdev/providers/revenuecat_customer.dart';
import 'package:k8zdev/providers/talker.dart';
import 'package:k8zdev/providers/terminals.dart';
import 'package:k8zdev/providers/theme.dart';
import 'package:k8zdev/providers/timeout.dart';
import 'package:k8zdev/services/onboarding_guide_service.dart';
import 'package:k8zdev/router.dart';
import 'package:k8zdev/services/app_usage_tracker.dart';
import 'package:k8zdev/services/grandfathering_service.dart';
import 'package:k8zdev/services/k8z_native.dart';
import 'package:k8zdev/services/revenuecat.dart';
import 'package:k8zdev/services/stash.dart';
import 'package:k8zdev/theme/kung.dart';
import 'package:k8zdev/widgets/inherited.dart';
import 'package:k8zdev/widgets/pro_upgrade_dialog.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:auto_hyphenating_text/auto_hyphenating_text.dart';
import 'package:in_app_review/in_app_review.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initStash();
  await initStore();
  await initHyphenation();
  await initRevenueCatState();
  await K8zNative.startLocalServer();

  // Initialize Pro features
  final prefs = await SharedPreferences.getInstance();

  // Increment app open counter
  await AppUsageTracker.incrementOpenCount(prefs);

  // Check and set grandfathering for existing users (those with 2+ clusters)
  await _checkAndInitializeGrandfathering();

  // Check for probabilistic upgrade prompt (will be shown after app starts)
  _scheduleUpgradePromptCheck(prefs);

  final inAppReview = InAppReview.instance;
  if (await inAppReview.isAvailable() && !kDebugMode) {
    talker.info("request review");
    inAppReview.requestReview();
  }

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
        ChangeNotifierProvider(create: (_) => OnboardingGuideService()),
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
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  bool _hasCheckedUpgradePrompt = false;

  @override
  void initState() {
    super.initState();
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen(
      (List<ConnectivityResult> status) {
        status.forEachIndexed((idx, sts) {
          talker.debug("[$idx] $sts");
          bool hasWifi = status.contains(ConnectivityResult.wifi);
          bool hasEth = status.contains(ConnectivityResult.ethernet);
          bool hasMobile = status.contains(ConnectivityResult.mobile);
          if (hasWifi || hasEth || hasMobile) {
            updateNetworkStatus(status[idx]);
          }
        });
      },
    );

    // Check for probabilistic upgrade prompt after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndShowUpgradePrompt();
    });
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

  /// Check if probabilistic upgrade prompt should be shown and show it
  Future<void> _checkAndShowUpgradePrompt() async {
    if (_hasCheckedUpgradePrompt || !mounted) return;

    try {
      // Get provider before async operations
      final customerProvider = Provider.of<RevenueCatCustomer>(context, listen: false);

      final prefs = await SharedPreferences.getInstance();
      final openCount = AppUsageTracker.getOpenCount(prefs);
      final isPro = customerProvider.isPro;

      if (AppUsageTracker.shouldShowUpgradePrompt(openCount, isPro)) {
        if (mounted) {
          final lang = S.of(context);
          await ProUpgradeDialog.show(
            context,
            featureName: lang.proDialogBenefitsTitle,
          );
        }
      }

      _hasCheckedUpgradePrompt = true;
    } catch (e) {
      talker.error("Failed to check upgrade prompt: $e");
    }
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

/// Check and initialize grandfathering for users with existing clusters.
///
/// This is called during app initialization to ensure users who already
/// have 2 or more clusters before the Pro lock are grandfathered.
Future<void> _checkAndInitializeGrandfathering() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final clusters = await K8zCluster.list();
    final clusterCount = clusters.length;

    await GrandfatheringService.checkAndSetGrandfathering(prefs, clusterCount);

    if (clusterCount >= 2) {
      final isGrandfathered = GrandfatheringService.isGrandfathered(prefs);
      talker.info(
        "Cluster count: $clusterCount, Grandfathered: $isGrandfathered",
      );
    }
  } catch (e) {
    talker.error("Failed to check grandfathering: $e");
  }
}

/// Schedule upgrade prompt check to be executed after app starts.
///
/// This is a non-blocking call that stores the reference to prefs
/// so the UI can check for upgrade prompts after the app is running.
void _scheduleUpgradePromptCheck(SharedPreferences prefs) {
  // The actual check is done in _MyAppState.initState via addPostFrameCallback
  // This function is kept for potential future use with different timing strategies
  talker.debug("Upgrade prompt check scheduled");
}
