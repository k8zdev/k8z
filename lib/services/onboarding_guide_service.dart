import 'package:flutter/material.dart';
import 'package:k8zdev/dao/kube.dart';
import 'package:k8zdev/dao/onboarding_guide.dart';
import 'package:k8zdev/models/guide_step_definition.dart';
import 'package:k8zdev/services/analytics_service.dart';
import 'package:k8zdev/common/ops.dart';

/// Guide steps for onboarding (legacy enum for backward compatibility)
@Deprecated('Use DemoClusterGuide with guide IDs instead')
enum GuideStep {
  welcome,
  podList,
  podLogs,
  additionalFeatures,
  completed,
}

/// Onboarding state management
class OnboardingState {
  final bool isActive;
  final String? currentStepId;
  final K8zCluster? demoCluster;
  final DateTime? startTime;
  final Map<String, dynamic> analytics;
  final bool guideCompleted;
  final Map<String, String>? podInfo;

  const OnboardingState({
    this.isActive = false,
    this.currentStepId,
    this.demoCluster,
    this.startTime,
    this.analytics = const {},
    this.guideCompleted = false,
    this.podInfo,
  });

  OnboardingState copyWith({
    bool? isActive,
    String? currentStepId,
    K8zCluster? demoCluster,
    DateTime? startTime,
    Map<String, dynamic>? analytics,
    bool? guideCompleted,
    Map<String, String>? podInfo,
  }) {
    return OnboardingState(
      isActive: isActive ?? this.isActive,
      currentStepId: currentStepId ?? this.currentStepId,
      demoCluster: demoCluster ?? this.demoCluster,
      startTime: startTime ?? this.startTime,
      analytics: analytics ?? this.analytics,
      guideCompleted: guideCompleted ?? this.guideCompleted,
      podInfo: podInfo ?? this.podInfo,
    );
  }

  /// Get the current GuideStepDefinition
  GuideStepDefinition? getStepDefinition() {
    if (!isActive || currentStepId == null) return null;
    return DemoClusterGuide.getStepById(currentStepId!);
  }

  /// Get the current GuideStep (legacy)
  @Deprecated('Use getStepDefinition instead')
  GuideStep get currentStep {
    if (guideCompleted) return GuideStep.completed;
    if (currentStepId == null) return GuideStep.welcome;
    switch (currentStepId) {
      case DemoClusterGuide.welcomeStepId:
        return GuideStep.welcome;
      case DemoClusterGuide.podListStepId:
        return GuideStep.podList;
      case DemoClusterGuide.nodesStepId:
        return GuideStep.additionalFeatures;
      default:
        return GuideStep.welcome;
    }
  }
}

/// Onboarding guide service
class OnboardingGuideService extends ChangeNotifier {
  OnboardingState _state = const OnboardingState();

  OnboardingState get state => _state;
  bool get isGuideActive => _state.isActive;
  String? get currentStepId => _state.currentStepId;
  @Deprecated('Use currentStepId instead')
  GuideStep get currentStep => _state.currentStep;

  /// The guide name for persistence
  String get guideName => DemoClusterGuide.guideName;

  /// Start the onboarding guide
  Future<void> startGuide(K8zCluster cluster) async {
    talker.info('Starting onboarding guide for cluster: ${cluster.name}');

    _state = _state.copyWith(
      isActive: true,
      currentStepId: DemoClusterGuide.welcomeStepId,
      demoCluster: cluster,
      startTime: DateTime.now(),
      analytics: {
        'guide_start_time': DateTime.now().millisecondsSinceEpoch,
        'cluster_name': cluster.name,
      },
    );

    // Notify listeners immediately so UI updates right away
    notifyListeners();

    // Update last step in database
    await OnboardingGuideDao.updateLastStep(
      guideName,
      DemoClusterGuide.welcomeStepId,
      clusterId: cluster.server,
    );

    // Log guide start event
    AnalyticsService.logEvent(
      eventName: 'onboarding_guide_start',
      parameters: {
        'cluster_name': cluster.name,
        'cluster_is_demo': cluster.isDemo ? 'true' : 'false',
        'timestamp': _state.startTime!.millisecondsSinceEpoch,
      },
    );
  }

  /// Navigate to specific step
  Future<void> navigateToStep(String stepId) async {
    if (!_state.isActive) return;

    final step = DemoClusterGuide.getStepById(stepId);
    if (step == null) return;

    talker.info('Navigating to guide step: $stepId');

    _state = _state.copyWith(currentStepId: stepId);

    // Update last step in database
    await OnboardingGuideDao.updateLastStep(
      guideName,
      stepId,
      clusterId: _state.demoCluster?.server,
    );

    // Log step navigation
    _logStep(stepId);

    notifyListeners();
  }

  /// Show pod list guide (legacy method)
  Future<void> showPodListGuide() async {
    if (!_state.isActive ||
        _state.currentStepId != DemoClusterGuide.welcomeStepId) {
      return;
    }

    await navigateToStep(DemoClusterGuide.podListWithSwipeStepId);
  }

  /// Show log view guide (legacy method) - removed, no longer applicable
  @Deprecated('This step has been removed from the guide flow')
  Future<void> showLogViewGuide() async {
    // This method is deprecated, do nothing
  }

  /// Show additional features guide (legacy method)
  Future<void> showAdditionalFeaturesGuide() async {
    if (!_state.isActive ||
        _state.currentStepId != DemoClusterGuide.podListWithSwipeStepId) {
      return;
    }

    await navigateToStep(DemoClusterGuide.nodesListWithSwipeStepId);
  }

  /// Complete the guide
  Future<void> completeGuide() async {
    if (!_state.isActive) return;

    talker.info('Completing onboarding guide');

    final totalTime = _state.startTime != null
        ? DateTime.now().difference(_state.startTime!)
        : Duration.zero;

    // Save completion to database
    await OnboardingGuideDao.saveCompletion(
      OnboardingGuideState.completed(
        guideName: guideName,
        clusterId: _state.demoCluster?.server,
        lastStep: _state.currentStepId,
      ),
    );

    // Log guide completion
    AnalyticsService.logEvent(
      eventName: 'onboarding_guide_complete',
      parameters: {
        'total_time_ms': totalTime.inMilliseconds,
        'achieved_30s_goal': totalTime.inSeconds <= 30 ? 'true' : 'false',
        'cluster_name': _state.demoCluster?.name ?? 'unknown',
        'completed_steps': DemoClusterGuide.getSteps().length,
      },
    );

    _state = _state.copyWith(
      isActive: false,
      guideCompleted: true,
    );

    notifyListeners();
  }

  /// Skip the guide
  Future<void> skipGuide() async {
    if (!_state.isActive) return;

    talker.info('Skipping onboarding guide');

    final totalTime = _state.startTime != null
        ? DateTime.now().difference(_state.startTime!)
        : Duration.zero;

    // Save skip as completion to database
    await OnboardingGuideDao.saveCompletion(
      OnboardingGuideState.completed(
        guideName: guideName,
        clusterId: _state.demoCluster?.server,
        lastStep: _state.currentStepId,
      ),
    );

    // Log guide skip with timestamp
    AnalyticsService.logEvent(
      eventName: 'onboarding_guide_skip',
      parameters: {
        'total_time_ms': totalTime.inMilliseconds,
        'skipped_at_step': _state.currentStepId ?? 'unknown',
        'cluster_name': _state.demoCluster?.name ?? 'unknown',
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'skip_step_index': _state.currentStepId != null
            ? DemoClusterGuide.getStepIndex(_state.currentStepId!)
            : -1,
      },
    );

    _state = const OnboardingState();
    notifyListeners();
  }

  /// Move to next step
  Future<void> nextStep() async {
    if (_state.currentStepId == null) return;

    final nextId = DemoClusterGuide.getNextStepId(_state.currentStepId!);
    if (nextId == null) {
      // Last step, complete the guide
      await completeGuide();
    } else {
      await navigateToStep(nextId);
    }
  }

  /// Move to previous step
  Future<void> previousStep() async {
    if (_state.currentStepId == null) return;

    final prevId = DemoClusterGuide.getPreviousStepId(_state.currentStepId!);
    if (prevId != null) {
      await navigateToStep(prevId);
    }
  }

  /// Check completion and start guide if appropriate
  Future<bool> checkCompletionAndStart(K8zCluster cluster) async {
    final isCompleted = await OnboardingGuideDao.isGuideCompleted(
      guideName,
      clusterId: cluster.server,
    );

    if (isCompleted) {
      talker.info(
          'Guide already completed for cluster: ${cluster.name}. Skipping.');
      return false;
    }

    // Auto-start the guide
    await startGuide(cluster);
    return true;
  }

  /// Check if guide is completed
  Future<bool> isGuideCompleted({String? clusterId}) async {
    return await OnboardingGuideDao.isGuideCompleted(guideName,
        clusterId: clusterId);
  }

  /// Restart the guide (reset completion and start)
  Future<void> restartGuide(K8zCluster cluster) async {
    await OnboardingGuideDao.resetGuide(guideName);
    talker.info('Guide reset for restart');

    await startGuide(cluster);
  }

  /// Get step definition for current step
  GuideStepDefinition? getStepDefinition() {
    return _state.getStepDefinition();
  }

  /// Check if current step is the first step
  bool get isFirstStep {
    return _state.currentStepId != null &&
        DemoClusterGuide.isFirstStep(_state.currentStepId!);
  }

  /// Check if current step is the last step
  bool get isLastStep {
    return _state.currentStepId != null &&
        DemoClusterGuide.isLastStep(_state.currentStepId!);
  }

  /// Get current step index
  int get currentStepIndex {
    if (_state.currentStepId == null) return -1;
    return DemoClusterGuide.getStepIndex(_state.currentStepId!);
  }

  /// Get total steps count
  int get totalSteps => DemoClusterGuide.getSteps().length;

  /// Set pod info for the guide (used for pod detail step)
  void setPodInfo(String podName, String podNamespace) {
    talker.info('Setting pod info for guide: $podName in namespace $podNamespace');
    _state = _state.copyWith(
      podInfo: {'name': podName, 'namespace': podNamespace},
    );
    notifyListeners();
  }

  /// Log step navigation
  void _logStep(String stepId) {
    final elapsed = _state.startTime != null
        ? DateTime.now().difference(_state.startTime!)
        : Duration.zero;

    AnalyticsService.logEvent(
      eventName: 'onboarding_guide_step_navigate',
      parameters: {
        'step_id': stepId,
        'elapsed_ms': elapsed.inMilliseconds,
        'cluster_name': _state.demoCluster?.name ?? 'unknown',
      },
    );
  }

  /// Reset the guide state (without resetting database)
  void reset() {
    _state = const OnboardingState();
    notifyListeners();
  }
}