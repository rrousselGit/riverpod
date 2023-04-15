// ignore_for_file: avoid_unused_constructor_parameters

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Configuration {
  Configuration.fromJson(Map<String, Object?> json);

  final String host = '';
}

/* SNIPPET START */

final configProvider = FutureProvider<Configuration>((ref) async {
  final content = json.decode(
    await rootBundle.loadString('assets/configurations.json'),
  ) as Map<String, Object?>;

  return Configuration.fromJson(content);
});
