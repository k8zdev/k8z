import 'package:flutter_test/flutter_test.dart';
import 'package:gherkin/gherkin.dart';
import 'package:glob/glob.dart';
import 'package:k8zdev/dao/dao.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

// Import all step definitions
import 'steps/given_app_has_cluster.dart';
import 'steps/given_cluster_has_pvcs.dart';
import 'steps/given_app_has_no_clusters.dart';
import 'steps/given_app_has_crd.dart';
import 'steps/given_cluster_has_node.dart';
import 'steps/then_should_see_cluster_in_list.dart';
import 'steps/then_see_crd_details.dart';
import 'steps/then_see_node_details.dart';
import 'steps/when_click_crd.dart';
import 'steps/when_click_node.dart';
import 'steps/then_should_see_access_modes.dart';
import 'steps/then_should_see_cluster_in_list.dart';
import 'steps/then_should_see_pvc_status.dart';
import 'steps/then_should_see_storage_capacity.dart';
import 'steps/then_should_see_storage_class_name.dart';
import 'steps/then_should_see_volume_mode.dart';
import 'steps/then_should_see_volume_name.dart';
import 'steps/when_load_kubeconfig.dart';
import 'steps/when_navigate_to_pvc_details.dart';

Future<void> main() async {
  // Initialize Flutter test environment
  TestWidgetsFlutterBinding.ensureInitialized();

  // Initialize sqflite_common_ffi for unit testing
  sqfliteFfiInit();
  // Use in-memory database for fast tests
  databaseFactory = databaseFactoryFfi;

  // Initialize the database
  await initStore();

  final config = TestConfiguration()
    ..features = [Glob(r"test/bdd/features/**.feature")]
    ..stepDefinitions = [
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
      whenLoadKubeconfig(),
      whenNavigateToPVCDetails(),
      thenShouldSeeClusterInList(),
      thenShouldSeePVCStatus(),
      thenShouldSeeStorageCapacity(),
      thenShouldSeeAccessModes(),
      thenShouldSeeStorageClassName(),
      thenShouldSeeVolumeName(),
      thenShouldSeeVolumeMode(),
    ]
    // Run all scenarios except those marked as ios-critical
    ..tagExpression = "not @ios-critical"
    ..reporters = [
      ProgressReporter(),
      TestRunSummaryReporter(),
    ];

  return GherkinRunner().execute(config);
}
