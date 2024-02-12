import 'package:flutter/material.dart';

class NotFoundPage extends StatefulWidget {
  final String title;
  final String info;
  const NotFoundPage({super.key, required this.title, required this.info});

  @override
  State<NotFoundPage> createState() => _NotFoundPageState();
}

class _NotFoundPageState extends State<NotFoundPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: TextButton.icon(
          onPressed: null,
          icon: const Icon(Icons.not_interested_rounded),
          label: Text(widget.info),
        ),
      ),
    );
  }
}
