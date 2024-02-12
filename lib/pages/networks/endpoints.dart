import 'package:flutter/material.dart';
import 'package:k8sapp/generated/l10n.dart';
import 'package:k8sapp/widgets/widgets.dart';

class EndpointsPage extends StatefulWidget {
  const EndpointsPage({super.key});

  @override
  State<EndpointsPage> createState() => _EndpointsPageState();
}

class _EndpointsPageState extends State<EndpointsPage> {
  @override
  Widget build(BuildContext context) {
    var lang = S.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(lang.endpoints)),
      body: buildingWidget,
    );
  }
}
