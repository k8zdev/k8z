import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:k8zdev/common/styles.dart';
import 'package:k8zdev/generated/l10n.dart';
import 'package:k8zdev/common/helpers.dart';
import 'package:k8zdev/common/ops.dart';
import 'package:k8zdev/providers/terminals.dart';
import 'package:k8zdev/widgets/terminals.dart';
import 'package:k8zdev/widgets/interactive_guide_overlay.dart';
import 'package:k8zdev/services/onboarding_guide_service.dart';
import 'package:k8zdev/models/guide_step_definition.dart';
import 'package:provider/provider.dart';

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
    "workloads",
    "resources",
    "settings",
  ];

  static int _calculateSelectedIndex(BuildContext context) {
    final String subloc = GoRouterState.of(context).matchedLocation;
    var idx = tabroute.indexOf(subloc.split("/")[1]);
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

  /// Handle next button click with navigation
  void _handleNextStep(BuildContext context, OnboardingGuideService guideService) async {
    final nextId = DemoClusterGuide.getNextStepId(guideService.currentStepId ?? '');
    final router = GoRouter.of(context);

    if (nextId != null) {
      // Get the next step to navigate to its route
      final nextStep = DemoClusterGuide.getStepById(nextId);
      if (nextStep != null && nextStep.routeName.isNotEmpty) {
        // Update the step before navigation
        await guideService.navigateToStep(nextId);

        // Navigate to the next step's route
        _navigateToRoute(router, nextStep.routeName, nextStep.routeParams);
      }
    } else {
      // Last step, complete the guide
      await guideService.completeGuide();
    }
  }

  /// Navigate to route based on route name and parameters
  void _navigateToRoute(GoRouter router, String routeName, Map<String, dynamic> params) {
    try {
      router.goNamed(routeName);
    } catch (e) {
      // Route not found or navigation failed, stay on current page
      talker.warning('Failed to navigate to $routeName: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    var lang = S.of(context);
    final tp = Provider.of<TerminalProvider>(context, listen: false);

    return Scaffold(
      extendBody: true,
      body: Consumer<OnboardingGuideService>(
        builder: (context, guideService, child) {
          talker.debug('[DEBUG] Landing.Consumer build - isGuideActive: ${guideService.isGuideActive}, currentStepId: ${guideService.currentStepId}');
          // Wrap content with guide overlay if active
          if (guideService.isGuideActive) {
            talker.debug('[DEBUG] Landing: Showing InteractiveGuideOverlay');
            return InteractiveGuideOverlay(
              isActive: guideService.isGuideActive,
              currentStepId: guideService.currentStepId,
              steps: DemoClusterGuide.getSteps(),
              onNext: () => _handleNextStep(context, guideService),
              onSkip: () => guideService.skipGuide(),
              onPrevious: () => guideService.previousStep(),
              child: widget.child,
            );
          }
          talker.debug('[DEBUG] Landing: Not showing overlay, returning child');
          return widget.child;
        },
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: context.isDarkMode ? navDarkColor : navLightColor,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withValues(alpha: 0.1),
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
                    backgroundColor: Colors.purple.withValues(alpha: 0.2),
                    icon: Icons.home_rounded,
                    text: lang.clusters,
                    textStyle: tabTextStyle),
                GButton(
                    iconActiveColor: Colors.amber.shade600,
                    iconColor: Colors.grey.shade800,
                    textColor: Colors.amber.shade600,
                    backgroundColor: Colors.amber.withValues(alpha: 0.2),
                    icon: BoxIcons.bxs_server,
                    text: lang.workloads,
                    textStyle: tabTextStyle),
                GButton(
                    iconActiveColor: Colors.green,
                    iconColor: Colors.grey.shade800,
                    textColor: Colors.green,
                    backgroundColor: Colors.green.withValues(alpha: 0.2),
                    icon: BoxIcons.bxs_notepad,
                    text: lang.resources,
                    textStyle: tabTextStyle),
                GButton(
                    iconActiveColor: Colors.teal,
                    iconColor: Colors.grey.shade800,
                    textColor: Colors.teal,
                    backgroundColor: Colors.teal.withValues(alpha: 0.2),
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
      floatingActionButton:
          tp.terminals.isEmpty ? Container() : floatingActionButton(context),
    );
  }
}
