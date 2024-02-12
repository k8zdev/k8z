import 'package:flutter/material.dart';
import 'package:k8sapp/generated/l10n.dart';

class NamespacesPage extends StatefulWidget {
  const NamespacesPage({super.key});

  @override
  State<NamespacesPage> createState() => _NamespacesPageState();
}

class _NamespacesPageState extends State<NamespacesPage> {
  @override
  Widget build(BuildContext context) {
    var lang = S.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(lang.namespaces)),
    );
  }
}
