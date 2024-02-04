import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:k8sapp/common/styles.dart';
import 'package:k8sapp/generated/l10n.dart';
import 'package:k8sapp/common/helpers.dart';

class Landing extends StatefulWidget {
  const Landing({super.key, required this.child});
  final Widget child;

  @override
  createState() => _LandingState();
}

class _LandingState extends State<Landing> with SingleTickerProviderStateMixin {
  static const _titleOpts = TextStyle(
    fontSize: 16,
    color: Colors.black87,
  );
  static const _titleOptsDark = TextStyle(
    fontSize: 17,
    color: Colors.white,
  );

  titles(int idx, bool isDark) => <Widget>[
        Image.asset(
          "images/icon/k8s-1.29.png",
          width: 46,
        ),
        // Text(S.of(context).square, style: isDark ? _titleOptsDark : _titleOpts),
        Text(S.of(context).settings,
            style: isDark ? _titleOptsDark : _titleOpts),
      ][idx];

  static final tabroute = [
    "clusters",
    "settings",
  ];

  static int _calculateSelectedIndex(BuildContext context) {
    final String subloc = GoRouterState.of(context).matchedLocation;
    var idx = tabroute.indexOf("/${subloc.split("/")[1]}");
    return (idx < 0) ? 0 : idx;
  }

  final tabTextStyle = const TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var lang = S.of(context);

    return Scaffold(
      extendBody: true,
      body: widget.child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: context.isDarkMode ? navDarkColor : navLightColor,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              gap: 8,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: const Duration(milliseconds: 400),
              backgroundColor:
                  context.isDarkMode ? navDarkColor : navLightColor,
              tabs: [
                GButton(
                    iconActiveColor: Colors.purple,
                    iconColor: Colors.grey.shade800,
                    textColor: Colors.purple,
                    backgroundColor: Colors.purple.withOpacity(.2),
                    icon: Icons.home_rounded,
                    text: lang.clusters,
                    textStyle: tabTextStyle),
                GButton(
                    iconActiveColor: Colors.teal,
                    iconColor: Colors.grey.shade800,
                    textColor: Colors.teal,
                    backgroundColor: Colors.teal.withOpacity(.2),
                    icon: Icons.settings_rounded,
                    text: lang.settings,
                    textStyle: tabTextStyle),
              ],
              selectedIndex: _calculateSelectedIndex(context),
              onTabChange: (index) {
                context.goNamed(tabroute[index]);
              },
            ),
          ),
        ),
      ),
    );
  }
}
