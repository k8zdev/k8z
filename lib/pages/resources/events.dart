import 'package:flutter/material.dart';
import 'package:k8sapp/generated/l10n.dart';

class EventssPage extends StatefulWidget {
  const EventssPage({super.key});

  @override
  State<EventssPage> createState() => _EventssPageState();
}

class _EventssPageState extends State<EventssPage> {
  @override
  Widget build(BuildContext context) {
    var lang = S.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(lang.events)),
    );
  }
}
