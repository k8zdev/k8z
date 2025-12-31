// test/bdd/app.dart
// Simple test entry point for BDD tests with Flutter Gherkin

import 'package:flutter/material.dart';
import 'package:k8zdev/dao/dao.dart';
import 'package:k8zdev/generated/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize only the database for BDD tests
  await initStore();

  // Run a simple test app
  runApp(const TestApp());
}

class TestApp extends StatelessWidget {
  const TestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: Scaffold(
        appBar: AppBar(title: const Text('K8z BDD Test')),
        body: const Center(
          child: Text('BDD Test App Running'),
        ),
      ),
    );
  }
}

