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
final countryProvider = Provider((ref) => 'England');

final weatherProvider = Provider((ref) {
  final city = ref.watch(cityProvider);
  final country = ref.watch(countryProvider);

  return Location(city: city, country: country);
});

class Location {
  Location({required this.city, required this.country});

  final String city;
  final String country;

  String get label => '$city ($country)';
}
