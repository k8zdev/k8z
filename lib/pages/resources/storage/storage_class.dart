import 'package:flutter/material.dart';
import 'package:k8zdev/generated/l10n.dart';
import 'package:k8zdev/widgets/widgets.dart';

class StorageClassPage extends StatefulWidget {
  const StorageClassPage({super.key});

  @override
  State<StorageClassPage> createState() => _StorageClassPageState();
}

class _StorageClassPageState extends State<StorageClassPage> {
  @override
  Widget build(BuildContext context) {
    var lang = S.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(lang.storage_class)),
      body: buildingWidget,
    );
  }
}
