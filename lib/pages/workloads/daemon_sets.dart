import 'package:flutter/material.dart';
import 'package:k8sapp/generated/l10n.dart';
import 'package:k8sapp/widgets/widgets.dart';

class DaemonSetsPage extends StatefulWidget {
  const DaemonSetsPage({super.key});

  @override
  State<DaemonSetsPage> createState() => _DaemonSetsPageState();
}

class _DaemonSetsPageState extends State<DaemonSetsPage> {
  @override
  Widget build(BuildContext context) {
    var lang = S.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(lang.daemon_sets)),
      body: buildingWidget,
    );
  }
}
