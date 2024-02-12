import 'package:flutter/material.dart';
import 'package:k8sapp/generated/l10n.dart';

class CrdsPage extends StatefulWidget {
  const CrdsPage({super.key});

  @override
  State<CrdsPage> createState() => _CrdsPageState();
}

class _CrdsPageState extends State<CrdsPage> {
  @override
  Widget build(BuildContext context) {
    var lang = S.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(lang.crds)),
    );
  }
}
