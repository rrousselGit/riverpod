// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
// [missing_provider_scope?offset=241,247]
// ```
//   // ignore: riverpod_lint/missing_provider_scope
//   runApp(
// -     MyApp(),
// +     ProviderScope(child: MyApp()),
//   );
//   runApp(ProviderScope(child: MyApp()));
// ```
@TestFor.missing_provider_scope
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../test_annotation.dart';

void main() {
  // ignore: riverpod_lint/missing_provider_scope
  runApp(ProviderScope(child: MyApp()));
  runApp(ProviderScope(child: MyApp()));
  runApp(
    UncontrolledProviderScope(container: ProviderContainer(), child: MyApp()),
  );
}

void definitelyNotAMain() {
  // ignore: riverpod_lint/missing_provider_scope
  runApp(MyApp());
  runApp(ProviderScope(child: MyApp()));
  runApp(
    UncontrolledProviderScope(container: ProviderContainer(), child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
