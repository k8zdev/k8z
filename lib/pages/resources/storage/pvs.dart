import 'package:flutter/material.dart';
import 'package:k8zdev/generated/l10n.dart';
import 'package:k8zdev/widgets/widgets.dart';

class PvsPage extends StatefulWidget {
  const PvsPage({super.key});

  @override
  State<PvsPage> createState() => _PvsPageState();
}

class _PvsPageState extends State<PvsPage> {
  @override
  Widget build(BuildContext context) {
    var lang = S.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(lang.pvs)),
      body: buildingWidget,
    );
  }
}
