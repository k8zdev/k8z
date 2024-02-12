import 'package:flutter/material.dart';
import 'package:k8sapp/generated/l10n.dart';
import 'package:k8sapp/widgets/widgets.dart';

class StatefulSetsPage extends StatefulWidget {
  const StatefulSetsPage({super.key});

  @override
  State<StatefulSetsPage> createState() => _StatefulSetsPageState();
}

class _StatefulSetsPageState extends State<StatefulSetsPage> {
  @override
  Widget build(BuildContext context) {
    var lang = S.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(lang.stateful_sets)),
      body: buildingWidget,
    );
  }
}
