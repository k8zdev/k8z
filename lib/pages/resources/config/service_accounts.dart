import 'package:flutter/material.dart';
import 'package:k8zdev/generated/l10n.dart';
import 'package:k8zdev/widgets/widgets.dart';

class ServiceAccountsPage extends StatefulWidget {
  const ServiceAccountsPage({super.key});

  @override
  State<ServiceAccountsPage> createState() => _ServiceAccountsPageState();
}

class _ServiceAccountsPageState extends State<ServiceAccountsPage> {
  @override
  Widget build(BuildContext context) {
    var lang = S.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(lang.service_accounts)),
      body: buildingWidget,
    );
  }
}
