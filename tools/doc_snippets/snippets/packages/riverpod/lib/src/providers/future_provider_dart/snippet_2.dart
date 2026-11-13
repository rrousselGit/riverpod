// GENERATED from packages/riverpod/lib/src/providers/future_provider.dart by scripts/snippets.sh.
// Do not modify by hand: edit the snippet instead.

import 'package:riverpod/riverpod.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show WidgetRef;
import 'package:material_ui/material_ui.dart';

class Configuration {
  Configuration.fromJson(Map<String, Object?> json)
    : host = json['host']! as String;

  final String host;
}

final configProvider = FutureProvider<Configuration>((ref) async {
  final content =
      json.decode(await rootBundle.loadString('assets/configurations.json'))
          as Map<String, Object?>;

  return Configuration.fromJson(content);
});

Widget build(BuildContext context, WidgetRef ref) {
  AsyncValue<Configuration> config = ref.watch(configProvider);

  return config.when(
    loading: () => const CircularProgressIndicator(),
    error: (err, stack) => Text('Error: $err'),
    data: (config) {
      return Text(config.host);
    },
  );
}
