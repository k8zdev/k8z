import 'package:gherkin/gherkin.dart';
import 'package:k8zdev/services/pro_features.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

// Manual test doubles for RevenueCat classes
class _MockEntitlementInfo implements EntitlementInfo {
  final bool _isActive;

  _MockEntitlementInfo({required bool isActive}) : _isActive = isActive;

  @override
  bool get isActive => _isActive;

  @override
  noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

class _MockEntitlementInfos implements EntitlementInfos {
  final Map<String, EntitlementInfo> _all;

  _MockEntitlementInfos(this._all);

  @override
  Map<String, EntitlementInfo> get all => _all;

  @override
  noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

class _MockCustomerInfo implements CustomerInfo {
  final EntitlementInfos _entitlements;

  _MockCustomerInfo({required Map<String, EntitlementInfo> entitlements})
      : _entitlements = _MockEntitlementInfos(entitlements);

  @override
  EntitlementInfos get entitlements => _entitlements;

  @override
  noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

/// Step definitions for Pro subscription status scenarios
StepDefinitionGeneric<World> givenUserHasNoSubscription() {
  return given<World>(
    '用户没有任何有效的订阅',
    (context) async {
      final customerInfo = _MockCustomerInfo(entitlements: {});
      context.expect(ProFeatures.isPro(customerInfo), false);
    },
  );
}

StepDefinitionGeneric<World> givenUserHasActiveMonthlySubscription() {
  return given<World>(
    '用户有有效的月度订阅',
    (context) async {
      final entitlementInfo = _MockEntitlementInfo(isActive: true);
      final customerInfo = _MockCustomerInfo(
        entitlements: {'\$rc_monthly': entitlementInfo},
      );
      context.expect(ProFeatures.isPro(customerInfo), true);
    },
  );
}

StepDefinitionGeneric<World> givenUserHasActiveAnnualSubscription() {
  return given<World>(
    '用户有有效的年度订阅',
    (context) async {
      final entitlementInfo = _MockEntitlementInfo(isActive: true);
      final customerInfo = _MockCustomerInfo(
        entitlements: {'\$rc_annual': entitlementInfo},
      );
      context.expect(ProFeatures.isPro(customerInfo), true);
    },
  );
}

StepDefinitionGeneric<World> givenUserHasLifetimeSubscription() {
  return given<World>(
    '用户有终身订阅',
    (context) async {
      final entitlementInfo = _MockEntitlementInfo(isActive: true);
      final customerInfo = _MockCustomerInfo(
        entitlements: {'\$rc_lifetime': entitlementInfo},
      );
      context.expect(ProFeatures.isPro(customerInfo), true);
    },
  );
}

StepDefinitionGeneric<World> givenUserHasExpiredSubscription() {
  return given<World>(
    '用户有已过期的订阅',
    (context) async {
      final entitlementInfo = _MockEntitlementInfo(isActive: false);
      final customerInfo = _MockCustomerInfo(
        entitlements: {'\$rc_monthly': entitlementInfo},
      );
      context.expect(ProFeatures.isPro(customerInfo), false);
    },
  );
}

StepDefinitionGeneric<World> givenRevenueCatCustomerInfoUnavailable() {
  return given<World>(
    'RevenueCat客户信息不可用',
    (context) async {
      context.expect(ProFeatures.isPro(null), false);
    },
  );
}

StepDefinitionGeneric<World> givenAppInitializedWithRevenueCatSDK() {
  return given<World>(
    '应用已初始化RevenueCat SDK',
    (context) async {
      // Placeholder - SDK initialization is handled in main.dart
    },
  );
}

StepDefinitionGeneric<World> thenUserStatusShouldBe() {
  return then1<String, World>(
    '用户的状态应该是 {string}',
    (String status, StepContext<World> context) async {
      // This is just a placeholder - the actual verification is done in the given steps
    },
  );
}
