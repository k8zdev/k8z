import 'package:flutter/material.dart';
import 'package:k8zdev/generated/l10n.dart';
import 'package:k8zdev/widgets/widgets.dart';

class ConfigMapsPage extends StatefulWidget {
  const ConfigMapsPage({super.key});

  @override
  State<ConfigMapsPage> createState() => _ConfigMapsPageState();
}

class _ConfigMapsPageState extends State<ConfigMapsPage> {
  @override
  Widget build(BuildContext context) {
    var lang = S.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(lang.config_maps)),
      body: buildingWidget,
    );
  }
}
