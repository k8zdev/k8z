import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:k8zdev/common/styles.dart';
import 'package:k8zdev/generated/l10n.dart';
import 'package:k8zdev/common/helpers.dart';
import 'package:k8zdev/common/ops.dart';
import 'package:k8zdev/models/models.dart';
import 'package:k8zdev/providers/terminals.dart';
import 'package:k8zdev/services/k8z_service.dart';
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
        // Build route parameters - filter out null values
        final routeParams = Map<String, String>.from(
          nextStep.routeParams.map((key, value) => MapEntry(key, value ?? '')),
        );

        // Special handling for pod detail step (dynamic first pod name)
        if (nextId == DemoClusterGuide.podDetailStepId) {
          final podInfo = await _getFirstPodName(context, guideService);
          if (podInfo != null) {
            routeParams['path'] = '/api/v1';
            routeParams['namespace'] = podInfo['namespace']!;
            routeParams['resource'] = 'pods';
            routeParams['name'] = podInfo['name']!;
            // Set pod info for the guide step description
            guideService.setPodInfo(podInfo['name']!, podInfo['namespace']!);
          } else {
            talker.warning('No pods available for guide pod detail step, skipping');
            final skipNextId = DemoClusterGuide.getNextStepId(nextId);
            if (skipNextId != null) {
              await guideService.navigateToStep(skipNextId);
            } else {
              await guideService.completeGuide();
            }
            return;
          }
        }

        // Special handling for node detail step (dynamic node name - Scheme B)
        if (nextId == DemoClusterGuide.nodeDetailStepId) {
          // ignore: use_build_context_synchronously
          final nodeName = await _getFirstNodeName(context, guideService);
          if (!mounted) return;
          if (nodeName != null) {
            routeParams['path'] = '/api/v1';
            routeParams['namespace'] = '_';
            routeParams['resource'] = 'nodes';
            routeParams['name'] = nodeName;
          } else {
            talker.warning('No nodes available for guide node detail step, skipping');
            // Skip to next step or complete
            final skipNextId = DemoClusterGuide.getNextStepId(nextId);
            if (skipNextId != null) {
              await guideService.navigateToStep(skipNextId);
              return;
            } else {
              await guideService.completeGuide();
              return;
            }
          }
        }

        // Update the step before navigation
        await guideService.navigateToStep(nextId);

        // Navigate to the next step's route
        _navigateToRoute(router, nextStep.routeName, routeParams);
      }
    } else {
      // Last step, complete the guide
      await guideService.completeGuide();
    }
  }

  /// Handle previous button click with navigation
  void _handlePreviousStep(BuildContext context, OnboardingGuideService guideService) async {
    final prevId = DemoClusterGuide.getPreviousStepId(guideService.currentStepId ?? '');
    final router = GoRouter.of(context);

    if (prevId != null) {
      // Get the previous step to navigate to its route
      final prevStep = DemoClusterGuide.getStepById(prevId);
      if (prevStep != null && prevStep.routeName.isNotEmpty) {
        // Build route parameters - filter out null values
        final routeParams = Map<String, String>.from(
          prevStep.routeParams.map((key, value) => MapEntry(key, value ?? '')),
        );

        // Special handling for pod detail step (dynamic first pod name)
        if (prevId == DemoClusterGuide.podDetailStepId) {
          final podInfo = await _getFirstPodName(context, guideService);
          if (podInfo != null) {
            routeParams['path'] = '/api/v1';
            routeParams['namespace'] = podInfo['namespace']!;
            routeParams['resource'] = 'pods';
            routeParams['name'] = podInfo['name']!;
            // Set pod info for the guide step description
            guideService.setPodInfo(podInfo['name']!, podInfo['namespace']!);
          } else {
            talker.warning('No pods available for guide pod detail step, skipping');
            final skipPrevId = DemoClusterGuide.getPreviousStepId(prevId);
            if (skipPrevId != null) {
              await guideService.navigateToStep(skipPrevId);
              final skipPrevStep = DemoClusterGuide.getStepById(skipPrevId);
              if (skipPrevStep != null) {
                final stringParams = Map<String, String>.from(
                  skipPrevStep.routeParams.map((key, value) => MapEntry(key, value ?? '')),
                );
                _navigateToRoute(router, skipPrevStep.routeName, stringParams);
              }
            }
            return;
          }
        }

        // Special handling for node detail step (dynamic node name - Scheme B)
        if (prevId == DemoClusterGuide.nodeDetailStepId) {
          // ignore: use_build_context_synchronously
          final nodeName = await _getFirstNodeName(context, guideService);
          if (!mounted) return;
          if (nodeName != null) {
            routeParams['path'] = '/api/v1';
            routeParams['namespace'] = '_';
            routeParams['resource'] = 'nodes';
            routeParams['name'] = nodeName;
          } else {
            talker.warning('No nodes available for guide node detail step, skipping');
            // Go further back
            final skipPrevId = DemoClusterGuide.getPreviousStepId(prevId);
            if (skipPrevId != null) {
              await guideService.navigateToStep(skipPrevId);
              final skipPrevStep = DemoClusterGuide.getStepById(skipPrevId);
              if (skipPrevStep != null) {
                final stringParams = Map<String, String>.from(
                  skipPrevStep.routeParams.map((key, value) => MapEntry(key, value ?? '')),
                );
                _navigateToRoute(router, skipPrevStep.routeName, stringParams);
              }
            }
            return;
          }
        }

        // Update the step before navigation
        await guideService.navigateToStep(prevId);

        // Navigate to the previous step's route
        _navigateToRoute(router, prevStep.routeName, routeParams);
      }
    }
  }

  /// Get the first available pod name and namespace from the cluster
  ///
  /// Returns a Map with 'name' and 'namespace' keys, or null if no pods found.
  Future<Map<String, String>?> _getFirstPodName(BuildContext context, OnboardingGuideService guideService) async {
    try {
      final cluster = guideService.state.demoCluster;
      if (cluster == null) {
        talker.warning('No cluster available for fetching pods');
        return null;
      }

      // Use correct Kubernetes API path: /api/v1
      final path = '/api/v1';
      final resource = 'pods';

      final response = await K8zService(
        context,
        cluster: cluster,
      ).get('$path/$resource');

      if (response.error.isNotEmpty) {
        talker.error('Failed to fetch pods: ${response.error}');
        return null;
      }

      final podsList = IoK8sApiCoreV1PodList.fromJson(response.body);
      if (podsList != null && podsList.items.isNotEmpty) {
        final firstPod = podsList.items.first;
        final podName = firstPod.metadata?.name ?? '';
        final podNamespace = firstPod.metadata?.namespace ?? '';
        talker.info('Selected first pod for guide: $podName in namespace $podNamespace');
        return {'name': podName, 'namespace': podNamespace};
      }

      talker.warning('No pods found in cluster');
      return null;
    } catch (e) {
      talker.error('Error fetching first pod name: $e');
      return null;
    }
  }

  /// Get the first available node name from the cluster (Scheme B: LandingPage implementation)
  Future<String?> _getFirstNodeName(BuildContext context, OnboardingGuideService guideService) async {
    try {
      // Use K8zService to fetch nodes list from the demo cluster
      final cluster = guideService.state.demoCluster;
      if (cluster == null) {
        talker.warning('No demo cluster available for fetching nodes');
        return null;
      }

      // Use context-based K8zService - requires BuildContext
      // We need to create K8zService with context and cluster
      final path = '/api/v1';
      final resource = 'nodes';

      // Fetch nodes using the cluster - create K8zService with context
      final response = await K8zService(
        context,
        cluster: cluster,
      ).get('$path/$resource');

      if (response.error.isNotEmpty) {
        talker.error('Failed to fetch nodes: ${response.error}');
        return null;
      }

      final nodesList = IoK8sApiCoreV1NodeList.fromJson(response.body);
      if (nodesList != null && nodesList.items.isNotEmpty) {
        final firstName = nodesList.items.first.metadata?.name;
        talker.info('Selected first node for guide: $firstName');
        return firstName;
      }

      talker.warning('No nodes found in cluster');
      return null;
    } catch (e) {
      talker.error('Error fetching first node name: $e');
      return null;
    }
  }

  /// Navigate to route based on route name and parameters
  void _navigateToRoute(GoRouter router, String routeName, Map<String, String> params) {
    try {
      router.goNamed(routeName, pathParameters: params);
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
              onPrevious: () => _handlePreviousStep(context, guideService),
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
