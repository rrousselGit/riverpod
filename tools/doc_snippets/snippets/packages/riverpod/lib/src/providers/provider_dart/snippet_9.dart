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

final cityProvider = Provider((ref) => 'London');
final countryProvider = Provider((ref) => 'England');

final weatherProvider = Provider((ref) {
  // Pass the `ref` object to our `Location` class.
  // `Location` will then be able to call `ref.read` to read the providers.
  return Location(ref);
});

class Location {
  Location(this._ref);

  final Ref _ref;

  String get label {
    final city = _ref.read(cityProvider);
    final country = _ref.read(countryProvider);
    return '$city ($country)';
  }
}
