// GENERATED from packages/riverpod/lib/src/providers/provider.dart by scripts/snippets.sh.
// Do not modify by hand: edit the snippet instead.

import 'package:riverpod/riverpod.dart';
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart' show ProviderScope;
import 'package:material_ui/material_ui.dart';

class MyValue {}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => const Placeholder();
}

Future<String> fetchWeather({required String city}) async => 'Sunny';

final myProvider = Provider((ref) {
  return MyValue();
});
