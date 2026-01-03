import 'package:flutter_test/flutter_test.dart';
import 'package:gherkin/gherkin.dart';
import 'package:glob/glob.dart';
import 'package:k8zdev/dao/dao.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

// Import all step definitions
import 'steps/given_app_has_cluster.dart';
import 'steps/given_cluster_has_pvcs.dart';
import 'steps/given_app_has_no_clusters.dart';
import 'steps/given_app_has_crd.dart';
import 'steps/given_cluster_has_node.dart';
import 'steps/given_app_is_running.dart';
import 'steps/then_should_see_cluster_in_list.dart';
import 'steps/then_see_crd_details.dart';
import 'steps/then_see_node_details.dart';
import 'steps/then_guide_should_be_active.dart';
import 'steps/then_guide_should_not_be_active.dart';
import 'steps/then_should_see_welcome_text.dart';
import 'steps/then_current_step_should_be_welcome.dart';
import 'steps/when_click_crd.dart';
import 'steps/when_click_node.dart';
import 'steps/then_should_see_access_modes.dart';
import 'steps/then_should_see_pvc_status.dart';
import 'steps/then_should_see_storage_capacity.dart';
import 'steps/then_should_see_storage_class_name.dart';
import 'steps/then_should_see_volume_mode.dart';
import 'steps/then_should_see_volume_name.dart';
import 'steps/given_cluster_has_pvs.dart';
import 'steps/then_see_pv_detail_page.dart';
import 'steps/when_click_persistent_volume.dart';
import 'steps/when_navigate_to_pvc_details.dart';
import 'steps/when_enter_cluster_list_page.dart';
import 'steps/given_storageclass_exists.dart';
import 'steps/then_see_provisioner.dart';
import 'steps/then_see_reclaim_policy.dart';
import 'steps/then_see_storageclass_name.dart';
import 'steps/then_see_volume_binding_mode.dart';
import 'steps/when_load_kubeconfig.dart';
import 'steps/when_navigate_to_storageclass_details.dart';

// Pro feature lock step definitions
import 'steps/pro_subscription_status_steps.dart';
import 'steps/cluster_limit_steps.dart';
import 'steps/probabilistic_prompt_steps.dart';
import 'steps/emergency_operations_steps.dart';

// Helper step definition for "应用已初始化"
StepDefinitionGeneric<World> givenAppIsInitialized() {
  return given<World>(
    '应用已初始化',
    (context) async {
      // App initialization placeholder
    },
  );
}

Future<void> main() async {
  // Initialize Flutter test environment
  TestWidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPreferences for unit testing
  SharedPreferences.setMockInitialValues({});

  // Initialize sqflite_common_ffi for unit testing
  sqfliteFfiInit();
  // Use in-memory database for fast tests
  databaseFactory = databaseFactoryFfi;

  // Initialize the database
  await initStore();

  final config = TestConfiguration()
    ..features = [Glob(r"test/bdd/features/**.feature")]
    ..stepDefinitions = [
      givenAppIsInitialized(),
      // UI step definitions
      givenAppIsRunning(),
      givenDemoClusterLoaded(),
      whenEnterClusterListPage(),
      whenEnterClusterListPageSecondTime(),
      whenIsGuideIncomplete(),
      thenGuideShouldBeActive(),
      thenCurrentStepShouldBeWelcome(),
      thenShouldSeeWelcomeText(),
      thenGuideShouldNotBeActive(),
      whenSkipTheGuide(),
      givenAppHasNoClusters(),
      givenClusterHasCrd(),
      givenClusterHasNode(),
      whenLoadKubeconfig(),
      whenClickCrd(),
      whenClickNode(),
      thenShouldSeeClusterInList(),
      thenSeeCrdDetails(),
      thenSeeCrdGroupValue(),
      thenSeeCrdVersionValue(),
      thenSeeCrdKindValue(),
      thenSeeCrdScopeValue(),
      thenSeeCrdScopeAsCluster(),
      thenSeeCrdShortNames(),
      thenSeeCrdNamesFields(),
      thenSeeCrdWithStorageVersion(),
      thenSeeCrdStorageVersionField(),
      thenSeeCrdVersionList(),
      thenSeeNodeDetailPage(),
      thenSeeNodeOS(),
      thenSeeNodeArch(),
      thenSeeNodeKernel(),
      thenSeeNodeContainerRuntime(),
      thenSeeNodeIP(),
      thenSeeNodePodCIDR(),
      thenSeeNodeCapacity(),
      thenSeeNodeConditions(),
      givenAppHasCluster(),
      givenClusterHasPVCs(),
      whenNavigateToPVCDetails(),
      thenShouldSeePVCStatus(),
      thenShouldSeeStorageCapacity(),
      thenShouldSeeAccessModes(),
      thenShouldSeeStorageClassName(),
      thenShouldSeeVolumeName(),
      thenShouldSeeVolumeMode(),
      givenClusterHasPersistentVolumes(),
      whenClickPersistentVolume(),
      thenSeePVDetailsPage(),
      thenSeePVStatus(),
      thenSeePVCapacity(),
      thenSeePVAccessModes(),
      thenSeePVReclaimPolicy(),
      givenStorageclassExists(),
      whenNavigateToStorageclassDetails(),
      thenSeeStorageclassName(),
      thenSeeProvisioner(),
      thenSeeReclaimPolicy(),
      thenSeeVolumeBindingMode(),
      // Pro feature lock step definitions
      givenAppInitializedWithRevenueCatSDK(),
      givenUserHasNoSubscription(),
      givenUserHasActiveMonthlySubscription(),
      givenUserHasActiveAnnualSubscription(),
      givenUserHasLifetimeSubscription(),
      givenUserHasExpiredSubscription(),
      givenRevenueCatCustomerInfoUnavailable(),
      thenUserStatusShouldBe(),
      // Cluster limit steps
      givenUserIsNotGrandfathered(),
      givenUserIsGrandfathered(),
      whenCheckIfCanAddCluster(),
      thenShouldReturnFalseWithLimitMessage(),
      thenShouldReturnTrueWithNullMessage(),
      thenShouldAllowAddingCluster(),
      // Probabilistic prompt steps
      givenUserIsFree(),
      givenUserIsPro(),
      givenOpenCountIs(10),
      givenOpenCountCurrentValue(10),
      givenOpenCountIsSimple(10),
      whenAppStartup(),
      whenCheckIfShouldShowPrompt(),
      thenShouldNotShowUpgradedDialog(),
      thenShouldShowUpgradeDialog(),
      thenShouldReturnTrue(),
      thenShouldReturnFalse(),
      thenOpenCountBecomes(1),
      whenAppInitComplete(),
      whenUserClosesUpgradeDialog(),
      whenNextAppOpen(),
      // Emergency operations steps
      givenUserHasClusterWithPod(),
      givenClusterHasPod(),
      whenSelectPodToDelete(),
      whenSelectPodToScale(),
      whenClickPodTerminal(),
      whenClickViewPodLogs(),
      whenClickViewResourceDetails(),
      givenResourceTypeIsFixed(),
      whenClickDeleteResource(),
      whenPerformDeletePodOperation(),
      thenShouldAllowDeletePod(),
      thenPodSuccessfullyDeleted(),
      thenShouldAllowScalePod(),
      thenPodReplicasSuccessfullyUpdated(),
      thenShouldAllowOpenPodTerminal(),
      thenPodTerminalDisplayedCorrectly(),
      thenShouldAllowDisplayRealtimeLogs(),
      thenLogsDisplayedCorrectly(),
      thenShouldAllowViewDetails(),
      thenResourceDetailsDisplayedCorrectly(),
      thenShouldAllowDeleteResource(),
      thenResourceSuccessfullyDeleted(),
    ]
    // Exclude problematic features:
    // - @ios-critical: iOS-specific tests (iOS platform limitations)
    // - @node-shell / @yaml-edit: These require UI integration testing
    ..tagExpression = "not (@ios-critical or @node-shell or @yaml-edit)"
    ..reporters = [
      ProgressReporter(),
      TestRunSummaryReporter(),
    ];

  return GherkinRunner().execute(config);
}
