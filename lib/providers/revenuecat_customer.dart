import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

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
