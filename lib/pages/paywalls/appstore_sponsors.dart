import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:k8zdev/common/const.dart';
import 'package:k8zdev/common/helpers.dart';
import 'package:k8zdev/common/ops.dart';
import 'package:k8zdev/common/secrets.dart';
import 'package:k8zdev/common/styles.dart';
import 'package:k8zdev/generated/l10n.dart';
import 'package:k8zdev/providers/revenuecat_customer.dart';
import 'package:k8zdev/widgets/native_dialog.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AppStorePaywall extends StatefulWidget {
  const AppStorePaywall({super.key});

  @override
  State<AppStorePaywall> createState() => _AppStorePaywallState();
}

class _AppStorePaywallState extends State<AppStorePaywall> {
  Offering? _offering;
  bool _loading = false;
  int _selectedIndex = 0;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await fetchOfferings();
    });

    super.initState();
  }

  fetchOfferings() async {
    var lang = S.of(context);

    try {
      var offerings = await Purchases.getOfferings();
      if (offerings.all.isEmpty) {
        // ignore: use_build_context_synchronously
        await showDialog(
          context: context,
          builder: (BuildContext context) => ShowDialogToDismiss(
            title: "Error",
            content: lang.delete_failed("error"),
            buttonText: 'OK',
          ),
        );
        return;
      }
      setState(() {
        _offering = offerings.current;
      });
    } on PlatformException catch (e) {
      talker.error("RC get offerings failed.", e);
      // ignore: use_build_context_synchronously
      await showDialog(
        context: context,
        builder: (BuildContext context) => ShowDialogToDismiss(
            title: "Error",
            content: e.message ?? "Unknown error",
            buttonText: 'OK'),
      );
    }
  }

  Widget products(BuildContext context, S lang, RevenueCatCustomer customer) {
    if (_offering == null) {
      return loading();
    }
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: _offering?.availablePackages.length,
      itemBuilder: (BuildContext context, int index) {
        var product = _offering?.availablePackages[index];

        var entitlement = customer
            .customerInfo?.entitlements.all[revenueCatEntitlementIdentifier];

        var currentActive = entitlement?.productIdentifier ==
                product?.storeProduct.identifier &&
            entitlement!.isActive;

        var suffix = "";
        switch (product?.identifier) {
          case "\$rc_lifetime":
            suffix = lang.subscriptions_lifetime;
          case "\$rc_monthly":
            suffix = lang.subscriptions_monthly;

          case "\$rc_annual":
            suffix = lang.subscriptions_yearly;
        }

        var card = Card(
          elevation: (_selectedIndex == index) ? 20 : 6,
          color: currentActive ? Colors.pinkAccent : Colors.tealAccent.shade700,
          shape: (_selectedIndex == index)
              ? RoundedRectangleBorder(
                  side: const BorderSide(
                    width: 5,
                    color: Colors.white70,
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                )
              : null,
          child: ListTile(
            onTap: () async {
              setState(() {
                _selectedIndex = index;
              });
            },
            title: Text(
              product!.storeProduct.title,
              style: kTitleTextStyle,
            ),
            subtitle: Text(
              product.storeProduct.description,
              style: kDescriptionTextStyle.copyWith(
                fontSize: kFontSizeSuperSmall,
                color: Colors.white,
              ),
            ),
            trailing: Text(
              currentActive
                  ? lang.subscriptions_purchased
                  : "${product.storeProduct.priceString} $suffix",
              style: kTitleTextStyle,
            ),
          ),
        );
        return Container(
          margin: const EdgeInsets.only(bottom: 20),
          child: Center(child: card),
        );
      },
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
    );
  }

  Widget extra(BuildContext context, S lang, RevenueCatCustomer customer) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () {
            launchUrl(stdeulaUrl);
          },
          child: Text(
            lang.eula,
            style: purchaseExtraStyle,
          ),
        ),
        //
        TextButton(
          onPressed: () async {
            setState(() => _loading = true);
            try {
              logEvent("restorePurchases");
              CustomerInfo info = await Purchases.restorePurchases();

              customer.updateCustomerInfo(info);

              // ignore: use_build_context_synchronously
              showDialog(
                context: context,
                builder: (BuildContext context) => ShowDialogToDismiss(
                  title: lang.success,
                  content: lang.subscriptions_restore_success,
                  buttonText: lang.ok,
                ),
              ).then((value) {
                context.pop(2);
              });
            } on PlatformException catch (err) {
              // Error restoring purchases
              talker.error("restore failed", {"error": err.message});
              // ignore: use_build_context_synchronously
              showDialog(
                context: context,
                builder: (BuildContext context) => ShowDialogToDismiss(
                  title: lang.error,
                  content:
                      lang.subscriptions_restorePurchases_failed(err.message!),
                  buttonText: lang.ok,
                ),
              );
              setState(() => _loading = false);
              // ignore: use_build_context_synchronously
              context.pop();
            }
          },
          child: Text(
            lang.subscriptions_restore_purchases,
            style: purchaseExtraStyle,
          ),
        ),
        TextButton(
          onPressed: () {
            launchUrl(privacyUrl);
          },
          child: Text(
            lang.privacy_policy,
            style: purchaseExtraStyle,
          ),
        ),
      ],
    );
  }

  Widget loading() {
    return const Center(
      heightFactor: 6,
      child: CircularProgressIndicator(),
    );
  }

  Widget title(S lang) {
    return Text(
      lang.appName,
      style: const TextStyle(
        fontSize: 24,
        color: Colors.amber,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget body(S lang) {
    var customer = Provider.of<RevenueCatCustomer>(context);

    var expiredAt = DateTime.parse(
        customer.customerInfo?.latestExpirationDate?.toString() ??
            DateTime.now().toString());
    var expired = DateTime.now().isAfter(expiredAt)
        ? ""
        : lang.subscriptions_expired_at(expiredAt.toLocal().toString());

    return Wrap(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(left: 16, right: 16),
          alignment: Alignment.topCenter,
          child: Text(
            lang.sponsor_desc,
            textAlign: TextAlign.center,
          ),
        ),
        //
        Container(
          padding: const EdgeInsets.only(
            top: 20,
            bottom: 20,
          ),
          alignment: Alignment.topRight,
          child: Center(
            child: Image.asset(
              'images/icon/k8s-1.29.png',
              width: 88,
            ),
          ),
        ),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: SizedBox(
            width: double.infinity,
            child: Text(expired
                // style: kDescriptionTextStyle,
                ),
          ),
        ),

        Container(
          margin: iapTosEdge.copyWith(top: 0, bottom: 0),
          child: _loading ? loading() : products(context, lang, customer),
        ),
        Container(
          child: _loading ? Container() : extra(context, lang, customer),
        ),
        Container(
          alignment: Alignment.center,
          padding: iapTosEdge..copyWith(top: 0),
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              minimumSize: const Size(double.infinity, 42),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () async {
              setState(() => _loading = true);
              try {
                logEvent("purchasePackage");
                CustomerInfo info = await Purchases.purchasePackage(
                    _offering!.availablePackages[_selectedIndex]);
                // update
                customer.updateCustomerInfo(info);
              } catch (e) {
                talker.error("purchasePackage failed: ${e.toString()}");
              }
              await customer.fetchCusterInfo();

              if (mounted) {
                setState(() => _loading = false);
              }
            },
            child: Text(
              lang.sponsorme,
              style: kTitleTextStyle.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ),
        const Divider(height: 1),
        Container(
          padding: iapTosEdge,
          child: SizedBox(
            width: double.infinity,
            child: Text(
              lang.subscriptions_iap_desc,
              style: const TextStyle(fontSize: kFontSizeSuperSmall),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var lang = S.of(context);
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        shadowColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        title: title(lang),
      ),
      body: SingleChildScrollView(
        child: body(lang),
      ),
    );
  }
}
