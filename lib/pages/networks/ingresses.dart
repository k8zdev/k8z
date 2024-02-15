import 'package:flutter/material.dart';
import 'package:k8zdev/generated/l10n.dart';
import 'package:k8zdev/widgets/widgets.dart';

class IngressesPage extends StatefulWidget {
  const IngressesPage({super.key});

  @override
  State<IngressesPage> createState() => _IngressesPageState();
}

class _IngressesPageState extends State<IngressesPage> {
  @override
  Widget build(BuildContext context) {
    var lang = S.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(lang.ingresses)),
      body: buildingWidget,
    );
  }
}
