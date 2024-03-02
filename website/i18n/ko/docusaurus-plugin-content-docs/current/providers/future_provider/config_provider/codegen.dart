// ignore_for_file: avoid_unused_constructor_parameters

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'codegen.g.dart';
class Configuration {
  Configuration.fromJson(Map<String, Object?> json);
  final String host = '';
}

/* SNIPPET START */

@riverpod
Future<Configuration> fetchConfiguration(FetchConfigurationRef ref) async {
  final content = json.decode(
    await rootBundle.loadString('assets/configurations.json'),
  ) as Map<String, Object?>;

  return Configuration.fromJson(content);
}
