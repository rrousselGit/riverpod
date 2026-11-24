// GENERATED from packages/riverpod/dartdoc/providers.md by scripts/snippets.sh.
// Do not modify by hand: edit the snippet instead.

import 'package:riverpod/riverpod.dart';
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyValue {}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => const Placeholder();
}

Future<String> fetchWeather({required String city}) async => 'Sunny';

final cityProvider = Provider((ref) => 'London');

final weatherProvider = FutureProvider((ref) async {
  // We use `ref.watch` to watch another provider, and we pass it the provider
  // that we want to consume. Here: cityProvider
  final city = ref.watch(cityProvider);

  // We can then use the result to do something based on the value of `cityProvider`.
  return fetchWeather(city: city);
});
