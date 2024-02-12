import 'package:flutter/material.dart';
import 'package:k8sapp/generated/l10n.dart';
import 'package:k8sapp/widgets/widgets.dart';

class PodsPage extends StatefulWidget {
  const PodsPage({super.key});

  @override
  State<PodsPage> createState() => _PodsPageState();
}

class _PodsPageState extends State<PodsPage> {
  @override
  Widget build(BuildContext context) {
    var lang = S.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(lang.pods)),
      body: buildingWidget,
    );
  }
}
