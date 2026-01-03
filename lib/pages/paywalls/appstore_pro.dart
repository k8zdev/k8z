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
import 'package:k8zdev/widgets/pro_comparison_table.dart';
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

  /// Find the index of the annual plan if available
  int _findAnnualPlanIndex() {
    if (_offering == null) return 0;
    for (int i = 0; i < _offering!.availablePackages.length; i++) {
      if (_offering!.availablePackages[i].identifier == "\$rc_annual") {
        return i;
      }
    }
    return 0;
  }

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
        await showDialog(
          // ignore: use_build_context_synchronously
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
        _selectedIndex = _findAnnualPlanIndex();
      });
    } on PlatformException catch (e) {
      talker.error("RC get offerings failed.", e);
      await showDialog(
        // ignore: use_build_context_synchronously
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
        var isAnnual = product?.identifier == "\$rc_annual";

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

        var isSelected = _selectedIndex == index;

        var card = Card(
          elevation: isSelected ? 8 : 2,
          color: currentActive
              ? Colors.pinkAccent
              : isSelected
                  ? Colors.amber.shade700
                  : Colors.tealAccent.shade700,
          shape: isSelected
              ? RoundedRectangleBorder(
                  side: BorderSide(
                    width: 3,
                    color: isAnnual ? Colors.amber.shade300 : Colors.white,
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                )
              : RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
          child: Stack(
            children: [
              ListTile(
                onTap: () async {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                title: Row(
                  children: [
                    Expanded(
                      child: Text(
                        product!.storeProduct.title,
                        style: kTitleTextStyle,
                      ),
                    ),
                    if (isAnnual && !currentActive)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          lang.proBestValue,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber,
                          ),
                        ),
                      ),
                  ],
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
            ],
          ),
        );
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
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
        TextButton(
          onPressed: () async {
            setState(() => _loading = true);
            try {
              logEvent("restorePurchases");
              CustomerInfo info = await Purchases.restorePurchases();

              customer.updateCustomerInfo(info);

              showDialog(
                // ignore: use_build_context_synchronously
                context: context,
                builder: (BuildContext context) => ShowDialogToDismiss(
                  title: lang.success,
                  content: lang.subscriptions_restore_success,
                  buttonText: lang.ok,
                ),
              ).then((value) {
                // ignore: use_build_context_synchronously
                context.pop(2);
              });
            } on PlatformException catch (err) {
              talker.error("restore failed", {"error": err.message});
              showDialog(
                // ignore: use_build_context_synchronously
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

  /// Hero section with "Unlock Pro" title and headline (full width and responsive)
  Widget heroSection(S lang) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.amber.shade400,
            Colors.amber.shade700,
          ],
        ),
        borderRadius: const BorderRadius.all(Radius.circular(16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon and title on same row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.workspace_premium,
                size: 32,
                color: Colors.white,
              ),
              const SizedBox(width: 12),
              Text(
                lang.proUnlockTitle,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Text(
              lang.proHeadline,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Text(
              lang.proDescription,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 12),

          // Hero section
          heroSection(lang),
          const SizedBox(height: 12),

          const ProComparisonTable(),

          // Subscription status
          if (expired.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  expired,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.amber,
                  ),
                ),
              ),
            ),
          const SizedBox(height: 16),

          // Product selection
          Container(
            margin: const EdgeInsets.symmetric(vertical: 16),
            child: _loading ? loading() : products(context, lang, customer),
          ),
          const SizedBox(height: 16),

          // Extra links (restore, eula, privacy)
          Container(
            child: _loading ? Container() : extra(context, lang, customer),
          ),
          const SizedBox(height: 16),

          // Purchase button
          Container(
            alignment: Alignment.center,
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber.shade700,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
              ),
              onPressed: () async {
                setState(() => _loading = true);
                try {
                  logEvent("purchasePackage");
                  CustomerInfo info = await Purchases.purchasePackage(
                      _offering!.availablePackages[_selectedIndex]);
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
                lang.proUnlockNow,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const Divider(height: 32),
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
      ),
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
        title: Text(lang.proUnlockTitle),
      ),
      body: SingleChildScrollView(
        child: body(lang),
      ),
    );
  }
}
