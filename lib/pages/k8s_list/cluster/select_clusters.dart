import 'package:flutter/material.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:go_router/go_router.dart';
import 'package:k8zdev/common/ops.dart';
import 'package:k8zdev/common/styles.dart';
import 'package:k8zdev/dao/kube.dart';
import 'package:k8zdev/generated/l10n.dart';
import 'package:k8zdev/providers/current_cluster.dart';
import 'package:k8zdev/providers/revenuecat_customer.dart';
import 'package:k8zdev/services/pro_features.dart';
import 'package:k8zdev/services/grandfathering_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChoiceClustersSubPage extends StatefulWidget {
  final List<K8zCluster> clusters;

  const ChoiceClustersSubPage({super.key, required this.clusters});

  @override
  State<ChoiceClustersSubPage> createState() => _ChoiceClustersSubPageState();
}

class _ChoiceClustersSubPageState extends State<ChoiceClustersSubPage> {
  List<K8zCluster> _selected = [];

  Widget getChild(BuildContext context, K8zCluster config) {
    var screenWith = MediaQuery.of(context).size.width;
    return Container(
      width: screenWith - 36,
      padding: defaultEdge,
      child: OverflowBar(
        alignment: MainAxisAlignment.center,
        children: [const Icon(Icons.computer), Text(config.name)],
      ),
    );
  }

  Future<void> _handleSave(BuildContext context) async {
    // Get providers before async operations
    final customerProvider =
        Provider.of<RevenueCatCustomer>(context, listen: false);
    final ccProvider = Provider.of<CurrentCluster>(context, listen: false);
    // Get router before async operations
    final router = GoRouter.of(context);

    // Get current cluster count for the Pro check
    final existingClusters = await K8zCluster.list();
    final existingCount = existingClusters.length;
    final addedCount = _selected.length;
    final totalCount = existingCount + addedCount;

    // Pro check
    final isPro = ProFeatures.isPro(customerProvider.customerInfo);

    // Grandfathering check
    final prefs = await SharedPreferences.getInstance();
    final isGrandfathered = GrandfatheringService.isGrandfathered(prefs);

    // Check if user can add clusters
    final (canAdd, _) = ProFeatures.canAddCluster(
      totalCount,
      isPro,
      isGrandfathered,
    );

    if (!canAdd) {
      talker.debug("Free user cluster limit reached: $totalCount > ${ProFeatures.maxFreeClusters}");
      // Show upgrade dialog for Free users
      if (!context.mounted) return;
      _showClusterLimitDialog(context);
      return;
    }

    // Proceed with saving clusters
    talker.debug("save selectedItems: $_selected");
    try {
      K8zCluster.batchInsert(_selected);
      if (_selected.isNotEmpty) {
        ccProvider.setCurrent(_selected[0]);
      }
      if (mounted) {
        router.go("/clusters");
      }
    } catch (err) {
      talker.error("insert failed: ${err.toString()}");
    }
  }

  void _showClusterLimitDialog(BuildContext context) {
    final lang = S.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(lang.proDialogTitle),
        content: Text(lang.proDialogFeatureLocked(lang.clusters)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(lang.proDialogCancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.push('/paywall/appstore');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              foregroundColor: Colors.white,
            ),
            child: Text(lang.proDialogViewPlans),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var lang = S.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(lang.save_clusters)),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.save),
        onPressed: () => _handleSave(context),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        padding: defaultEdge,
        child: Column(
          children: [
            const Divider(height: 18, color: Colors.transparent),
            if (widget.clusters.isEmpty)
              Column(
                children: [
                  Center(child: Text(lang.empyt_context)),
                  const Divider(height: 18, color: Colors.transparent),
                ],
              ),
            if (widget.clusters.isNotEmpty)
              Column(
                children: [
                  Center(child: Text(lang.select_clusters)),
                  const Divider(height: 18, color: Colors.transparent),
                ],
              ),
            SingleChildScrollView(
              child: MultiSelectContainer(
                items: widget.clusters.map((config) {
                  return MultiSelectCard<K8zCluster>(
                    value: config,
                    child: getChild(context, config),
                  );
                }).toList(),
                onChange: (selectedItems, selectedItem) {
                  setState(() => _selected = selectedItems);
                  talker.debug("selectedItem: ${selectedItem.name}");
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
