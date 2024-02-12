import 'package:flutter/material.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:go_router/go_router.dart';
import 'package:k8sapp/common/ops.dart';
import 'package:k8sapp/common/styles.dart';
import 'package:k8sapp/dao/kube.dart';
import 'package:k8sapp/generated/l10n.dart';
import 'package:k8sapp/providers/current_cluster.dart';
import 'package:provider/provider.dart';

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
      child: ButtonBar(
        alignment: MainAxisAlignment.center,
        children: [const Icon(Icons.computer), Text(config.name)],
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
        onPressed: () async {
          talker.debug("save selectedItems: $_selected");
          try {
            K8zCluster.batchInsert(_selected);
            if (_selected.isNotEmpty) {
              final ccProvider =
                  Provider.of<CurrentCluster>(context, listen: false);
              ccProvider.setCurrent(_selected[0]);
            }
            GoRouter.of(context).go("/clusters");
          } catch (err) {
            talker.error("insert failed: ${err.toString()}");
          }
        },
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
