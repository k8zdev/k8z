import 'package:flutter/material.dart';
import 'package:k8zdev/common/const.dart';
import 'package:k8zdev/generated/l10n.dart';
import 'package:k8zdev/widgets/widgets.dart';

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
      body: Container(
        margin: bottomEdge,
        child: buildingWidget,
      ),
    );
  }
}
