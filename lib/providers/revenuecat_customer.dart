import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:k8zdev/services/pro_features.dart';

class RevenueCatCustomer with ChangeNotifier {
  CustomerInfo? _customerInfo;

  CustomerInfo? get customerInfo => _customerInfo;

  bool get isPurchased => () {
        bool result = false;
        var activeEntitlements = customerInfo?.entitlements.active ?? {};

        for (var element in activeEntitlements.entries) {
          result = element.value.isActive;
          if (result) {
            break;
          }
        }
        return result;
      }();

  /// Check if the user has an active Pro subscription.
  ///
  /// Delegates to [ProFeatures.isPro] for consistent Pro status checking.
  /// Returns true if the user has any active entitlement.
  bool get isPro => ProFeatures.isPro(customerInfo);

  init() async {
    try {
      _customerInfo = await Purchases.getCustomerInfo();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchCusterInfo() async {
    try {
      _customerInfo = await Purchases.getCustomerInfo();
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  void updateCustomerInfo(CustomerInfo? info) {
    _customerInfo = info;
    notifyListeners();
  }
}
