import 'package:flutter/material.dart';
import 'package:k8zdev/generated/l10n.dart';
import 'package:k8zdev/widgets/widgets.dart';

class SecretsPage extends StatefulWidget {
  const SecretsPage({super.key});

  @override
  State<SecretsPage> createState() => _SecretsPageState();
}

class _SecretsPageState extends State<SecretsPage> {
  @override
  Widget build(BuildContext context) {
    var lang = S.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(lang.secrets)),
      body: buildingWidget,
    );
  }
}
