import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:k8zdev/common/secrets.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

Future<void> initRevenueCatState() async {
  var level = kDebugMode || kProfileMode ? LogLevel.info : LogLevel.verbose;
  await Purchases.setLogLevel(level);

  late PurchasesConfiguration config;
  if (Platform.isIOS || Platform.isMacOS) {
    config = PurchasesConfiguration(revenueCatApplePublicKey);
  }

  await Purchases.configure(config);
}
