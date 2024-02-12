import 'package:flutter/material.dart';
import 'package:k8sapp/generated/l10n.dart';
import 'package:k8sapp/widgets/widgets.dart';

class PvcsPage extends StatefulWidget {
  const PvcsPage({super.key});

  @override
  State<PvcsPage> createState() => _PvcsPageState();
}

class _PvcsPageState extends State<PvcsPage> {
  @override
  Widget build(BuildContext context) {
    var lang = S.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(lang.pvcs)),
      body: buildingWidget,
    );
  }
}
