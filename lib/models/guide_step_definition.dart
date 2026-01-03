import 'package:flutter/widgets.dart';
import 'package:k8zdev/generated/l10n.dart';

/// Guide step definition model for interactive onboarding guides.
///
/// Each step in an onboarding guide is defined by this model, which includes
/// routing information, target widget keys for highlighting, and content.
///
/// Example:
/// ```dart
/// const step = GuideStepDefinition(
///   id: 'podList',
///   routeName: 'pods',
///   targetKey: 'guide-target-pod-list',
///   title: 'View Pods',
///   description: 'Here you can see all pods in your cluster.',
/// );
/// ```
class GuideStepDefinition {
  /// Unique identifier for this step
  final String id;

  /// GoRouter route name to navigate to when this step is shown
  final String routeName;

  /// Additional route parameters for navigation
  final Map<String, dynamic> routeParams;

  /// GlobalKey of the target widget to highlight with spotlight effect
  /// Uses ValueKey or similar, stored as string identifier
  final String? targetKey;

  /// Title displayed on the guide card
  final String title;

  /// Description/content displayed on the guide card
  final String description;

  /// Label for the next button (defaults to "Next" if null)
  final String? buttonNext;

  /// Label for the skip button (defaults to "Skip" if null)
  final String? buttonSkip;

  /// Label for the previous button (defaults to "Previous" if null)
  final String? buttonPrevious;

  /// i18n key for the title (optional, for future i18n support)
  final String? l10nTitle;

  /// i18n key for the description (optional, for future i18n support)
  final String? l10nDescription;

  /// i18n key for the next button (optional, for future i18n support)
  final String? l10nButtonNext;

  /// i18n key for the skip button (optional, for future i18n support)
  final String? l10nButtonSkip;

  /// i18n key for the previous button (optional, for future i18n support)
  final String? l10nButtonPrevious;

  const GuideStepDefinition({
    required this.id,
    required this.routeName,
    this.routeParams = const {},
    this.targetKey,
    required this.title,
    required this.description,
    this.buttonNext,
    this.buttonSkip,
    this.buttonPrevious,
    this.l10nTitle,
    this.l10nDescription,
    this.l10nButtonNext,
    this.l10nButtonSkip,
    this.l10nButtonPrevious,
  });

  /// Creates a copy of this step with modified fields
  GuideStepDefinition copyWith({
    String? id,
    String? routeName,
    Map<String, dynamic>? routeParams,
    String? targetKey,
    String? title,
    String? description,
    String? buttonNext,
    String? buttonSkip,
    String? buttonPrevious,
    String? l10nTitle,
    String? l10nDescription,
    String? l10nButtonNext,
    String? l10nButtonSkip,
    String? l10nButtonPrevious,
  }) {
    return GuideStepDefinition(
      id: id ?? this.id,
      routeName: routeName ?? this.routeName,
      routeParams: routeParams ?? this.routeParams,
      targetKey: targetKey ?? this.targetKey,
      title: title ?? this.title,
      description: description ?? this.description,
      buttonNext: buttonNext ?? this.buttonNext,
      buttonSkip: buttonSkip ?? this.buttonSkip,
      buttonPrevious: buttonPrevious ?? this.buttonPrevious,
      l10nTitle: l10nTitle ?? this.l10nTitle,
      l10nDescription: l10nDescription ?? this.l10nDescription,
      l10nButtonNext: l10nButtonNext ?? this.l10nButtonNext,
      l10nButtonSkip: l10nButtonSkip ?? this.l10nButtonSkip,
      l10nButtonPrevious: l10nButtonPrevious ?? this.l10nButtonPrevious,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GuideStepDefinition &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'GuideStepDefinition{id: $id, routeName: $routeName, '
        'title: $title, targetKey: $targetKey}';
  }

  /// Import statement needed: import 'package:k8zdev/generated/l10n.dart';
  /// and import 'package:flutter/widgets.dart' for BuildContext.

  /// Get localized title from i18n key or fall back to direct text.
  ///
  /// This method should be called from widgets with access to BuildContext.
  /// Returns the localized string if [l10nTitle] is set, otherwise returns [title].
  ///
  /// Note: Currently returns the direct text as fallback because the S class
  /// uses generated getters that cannot be dynamically accessed by key.
  /// For full i18n support, use S.of(context) directly in widgets.
  String getLocalizedTitle(BuildContext context) {
    // For now, fall back to direct text
    // TODO: Implement full i18n support when dynamic lookup is available
    return title;
  }

  /// Get localized description from i18n key or fall back to direct text.
  ///
  /// This method should be called from widgets with access to BuildContext.
  /// Returns the localized string if [l10nDescription] is set, otherwise returns [description].
  String getLocalizedDescription(BuildContext context) {
    return description;
  }

  /// Get localized next button label from i18n key or fall back to direct text.
  ///
  /// This method should be called from widgets with access to BuildContext.
  /// Returns the localized string if [l10nButtonNext] is set, otherwise returns [buttonNext].
  String? getLocalizedButtonNext(BuildContext context) {
    return buttonNext;
  }

  /// Get localized skip button label from i18n key or fall back to direct text.
  ///
  /// This method should be called from widgets with access to BuildContext.
  /// Returns the localized string if [l10nButtonSkip] is set, otherwise returns [buttonSkip].
  String? getLocalizedButtonSkip(BuildContext context) {
    return buttonSkip;
  }

  /// Get localized previous button label from i18n key or fall back to direct text.
  ///
  /// This method should be called from widgets with access to BuildContext.
  /// Returns the localized string if [l10nButtonPrevious] is set, otherwise returns [buttonPrevious].
  String? getLocalizedButtonPrevious(BuildContext context) {
    return buttonPrevious;
  }

  /// Convert to JSON for storage or serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'routeName': routeName,
      'routeParams': routeParams,
      'targetKey': targetKey,
      'title': title,
      'description': description,
      'buttonNext': buttonNext,
      'buttonSkip': buttonSkip,
      'buttonPrevious': buttonPrevious,
      'l10nTitle': l10nTitle,
      'l10nDescription': l10nDescription,
      'l10nButtonNext': l10nButtonNext,
      'l10nButtonSkip': l10nButtonSkip,
      'l10nButtonPrevious': l10nButtonPrevious,
    };
  }

  /// Create from JSON
  factory GuideStepDefinition.fromJson(Map<String, dynamic> json) {
    final routeParams = json['routeParams'];
    Map<String, dynamic> parsedRouteParams = const {};
    if (routeParams is Map) {
      parsedRouteParams = Map<String, dynamic>.from(
        routeParams.cast<String, dynamic>(),
      );
    }

    return GuideStepDefinition(
      id: json['id'] as String,
      routeName: json['routeName'] as String,
      routeParams: parsedRouteParams,
      targetKey: json['targetKey'] as String?,
      title: json['title'] as String,
      description: json['description'] as String,
      buttonNext: json['buttonNext'] as String?,
      buttonSkip: json['buttonSkip'] as String?,
      buttonPrevious: json['buttonPrevious'] as String?,
      l10nTitle: json['l10nTitle'] as String?,
      l10nDescription: json['l10nDescription'] as String?,
      l10nButtonNext: json['l10nButtonNext'] as String?,
      l10nButtonSkip: json['l10nButtonSkip'] as String?,
      l10nButtonPrevious: json['l10nButtonPrevious'] as String?,
    );
  }
}

/// Demo cluster onboarding guide steps
///
/// This class defines the complete onboarding flow for the demo cluster,
/// including all steps, routes, and target element keys for highlighting.
class DemoClusterGuide {
  // Guide name used for persistence
  static const String guideName = 'demo_cluster_onboarding';

  // Step IDs for 8-step flow
  static const String welcomeStepId = 'welcome';
  static const String workloadsOverviewStepId = 'workloadsOverview';
  static const String podListWithSwipeStepId = 'podListWithSwipe';
  static const String podDetailStepId = 'podDetail';
  static const String resourcesMenuStepId = 'resourcesMenu';
  static const String nodesListWithSwipeStepId = 'nodesListWithSwipe';
  static const String nodeDetailStepId = 'nodeDetail';
  static const String completedStepId = 'completed';

  // Legacy step IDs (for backward compatibility with OnboardingGuideService)
  // These map to their counterparts in the new 8-step flow
  @Deprecated('Use podListWithSwipeStepId instead')
  static const String podListStepId = podListWithSwipeStepId;
  @Deprecated('Use nodesListWithSwipeStepId instead')
  static const String nodesStepId = nodesListWithSwipeStepId;
  @Deprecated('Use workloadsOverviewStepId instead')
  static const String workloadsStepId = workloadsOverviewStepId;
  @Deprecated('Use resourcesMenuStepId instead')
  static const String resourcesStepId = resourcesMenuStepId;

  // Target element key identifiers
  static const String welcomeTargetKey = 'guide-target-welcome';
  static const String workloadsTargetKey = 'guide-target-workloads';
  static const String podListTargetKey = 'guide-target-pod-list';
  static const String podDetailTargetKey = 'guide-target-pod-detail';
  static const String resourcesTargetKey = 'guide-target-resources';
  static const String nodesTargetKey = 'guide-target-nodes';
  static const String nodeDetailTargetKey = 'guide-target-node-detail';
  static const String completedTargetKey = 'guide-target-completed';

  /// Get all guide steps for demo cluster onboarding (8-step flow)
  ///
  /// Route mappings:
  /// - Step 1 (welcome): clusters route (cluster list page)
  /// - Step 2 (workloadsOverview): workloads route
  /// - Step 3 (podListWithSwipe): pods route
  /// - Step 4 (podDetail): details route (workloads namespace, pods resource, web-demo pod)
  /// - Step 5 (resourcesMenu): resources route
  /// - Step 6 (nodesListWithSwipe): nodes route
  /// - Step 7 (nodeDetail): details route (cluster-scoped, nodes resource, dynamic node name)
  /// - Step 8 (completed): clusters route
  static List<GuideStepDefinition> getSteps() {
    return const [
      GuideStepDefinition(
        id: welcomeStepId,
        routeName: 'clusters',
        targetKey: welcomeTargetKey,
        title: 'Welcome to K8zDev!',
        description: 'Let\'s quickly explore the main features. '
            'This is a demo cluster where you can safely explore.',
        buttonNext: 'Let\'s Start',
        buttonSkip: 'Skip Guide',
        l10nTitle: 'guide_step_1_title',
        l10nDescription: 'guide_step_1_desc',
        l10nButtonNext: 'guide_button_next',
        l10nButtonSkip: 'guide_button_skip',
      ),
      GuideStepDefinition(
        id: workloadsOverviewStepId,
        routeName: 'workloads',
        targetKey: workloadsTargetKey,
        title: 'Workloads Overview',
        description: 'Here you can see all workload resources: Pods, Deployments, '
            'DaemonSets, and StatefulSets. Click any type to see resources.',
        buttonNext: 'Next',
        buttonSkip: 'Skip',
        buttonPrevious: 'Back',
        l10nTitle: 'guide_step_2_title',
        l10nDescription: 'guide_step_2_desc',
        l10nButtonNext: 'guide_button_next',
        l10nButtonSkip: 'guide_button_skip',
        l10nButtonPrevious: 'guide_button_back',
      ),
      GuideStepDefinition(
        id: podListWithSwipeStepId,
        routeName: 'pods',
        targetKey: podListTargetKey,
        title: 'Pod List',
        description: 'View all pods in your cluster. Swipe right for more actions '
            '(details, logs, terminal), swipe left to delete.',
        buttonNext: 'Next',
        buttonSkip: 'Skip',
        buttonPrevious: 'Back',
        l10nTitle: 'guide_step_3_title',
        l10nDescription: 'guide_step_3_desc',
        l10nButtonNext: 'guide_button_next',
        l10nButtonSkip: 'guide_button_skip',
        l10nButtonPrevious: 'guide_button_back',
      ),
      GuideStepDefinition(
        id: podDetailStepId,
        routeName: 'details',
        routeParams: {
          'path': 'workloads',
          'namespace': null,
          'resource': 'pods',
          'name': 'web-demo',
        },
        targetKey: podDetailTargetKey,
        title: 'Pod Details',
        description: 'View YAML configuration, real-time logs, and open a terminal. '
            'This page shows the detailed information for the \'web-demo\' pod.',
        buttonNext: 'Next',
        buttonSkip: 'Skip',
        buttonPrevious: 'Back',
        l10nTitle: 'guide_step_4_title',
        l10nDescription: 'guide_step_4_desc',
        l10nButtonNext: 'guide_button_next',
        l10nButtonSkip: 'guide_button_skip',
        l10nButtonPrevious: 'guide_button_back',
      ),
      GuideStepDefinition(
        id: resourcesMenuStepId,
        routeName: 'resources',
        targetKey: resourcesTargetKey,
        title: 'Resources Menu',
        description: 'Access additional Kubernetes resources: Config (ConfigMaps, Secrets), '
            'Storage (PVs, PVCs, StorageClass), and Networking (Services, Ingresses).',
        buttonNext: 'Next',
        buttonSkip: 'Skip',
        buttonPrevious: 'Back',
        l10nTitle: 'guide_step_5_title',
        l10nDescription: 'guide_step_5_desc',
        l10nButtonNext: 'guide_button_next',
        l10nButtonSkip: 'guide_button_skip',
        l10nButtonPrevious: 'guide_button_back',
      ),
      GuideStepDefinition(
        id: nodesListWithSwipeStepId,
        routeName: 'nodes',
        targetKey: nodesTargetKey,
        title: 'Nodes List',
        description: 'View all cluster nodes. Swipe right to see node details, '
            'swipe left to cordon/uncordon the node.',
        buttonNext: 'Next',
        buttonSkip: 'Skip',
        buttonPrevious: 'Back',
        l10nTitle: 'guide_step_6_title',
        l10nDescription: 'guide_step_6_desc',
        l10nButtonNext: 'guide_button_next',
        l10nButtonSkip: 'guide_button_skip',
        l10nButtonPrevious: 'guide_button_back',
      ),
      GuideStepDefinition(
        id: nodeDetailStepId,
        routeName: 'details',
        routeParams: {
          'path': '/api/v1',
          'namespace': '_',
          'resource': 'nodes',
          'name': null, // Will be filled dynamically by LandingPage
        },
        targetKey: nodeDetailTargetKey,
        title: 'Node Details',
        description: 'Monitor node status, resource usage (CPU/memory), and view '
            'pods running on this node.',
        buttonNext: 'Complete',
        buttonSkip: 'Skip',
        buttonPrevious: 'Back',
        l10nTitle: 'guide_step_7_title',
        l10nDescription: 'guide_step_7_desc',
        l10nButtonNext: 'guide_button_complete',
        l10nButtonSkip: 'guide_button_skip',
        l10nButtonPrevious: 'guide_button_back',
      ),
      GuideStepDefinition(
        id: completedStepId,
        routeName: 'clusters',
        targetKey: completedTargetKey,
        title: 'Guide Complete!',
        description: 'You\'ve completed the onboarding guide! Feel free to explore '
            'further. Access help documentation anytime from settings.',
        buttonNext: 'Got it!',
        l10nTitle: 'guide_step_8_title',
        l10nDescription: 'guide_step_8_desc',
        l10nButtonNext: 'guide_button_complete',
      ),
    ];
  }

  /// Get step by ID
  static GuideStepDefinition? getStepById(String id) {
    final steps = getSteps();
    for (final step in steps) {
      if (step.id == id) {
        return step;
      }
    }
    return null;
  }

  /// Get next step ID
  static String? getNextStepId(String currentId) {
    final steps = getSteps();
    for (int i = 0; i < steps.length - 1; i++) {
      if (steps[i].id == currentId) {
        return steps[i + 1].id;
      }
    }
    return null;
  }

  /// Get previous step ID
  static String? getPreviousStepId(String currentId) {
    final steps = getSteps();
    for (int i = 1; i < steps.length; i++) {
      if (steps[i].id == currentId) {
        return steps[i - 1].id;
      }
    }
    return null;
  }

  /// Get step index by ID
  static int getStepIndex(String id) {
    final steps = getSteps();
    for (int i = 0; i < steps.length; i++) {
      if (steps[i].id == id) {
        return i;
      }
    }
    return -1;
  }

  /// Check if step is the first step
  static bool isFirstStep(String id) {
    return getStepIndex(id) == 0;
  }

  /// Check if step is the last step
  static bool isLastStep(String id) {
    final steps = getSteps();
    return getStepIndex(id) == steps.length - 1;
  }
}
