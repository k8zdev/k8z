import 'package:flutter/material.dart';
import 'package:k8zdev/common/const.dart';
import 'package:k8zdev/generated/l10n.dart';
import 'package:k8zdev/widgets/widgets.dart';

class DeploymentsPage extends StatefulWidget {
  const DeploymentsPage({super.key});

  @override
  State<DeploymentsPage> createState() => _DeploymentsPageState();
}

class _DeploymentsPageState extends State<DeploymentsPage> {
  @override
  Widget build(BuildContext context) {
    var lang = S.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(lang.deployments)),
      body: Container(
        margin: bottomEdge,
        child: buildingWidget,
      ),
    );
  }
}
