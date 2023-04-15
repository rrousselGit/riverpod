// Parse a file without having to deal with errors
// ignore_for_file: avoid_unused_constructor_parameters, use_key_in_widget_constructors

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Configuration {
  Configuration.fromJson(Object? json);

  String get host => throw UnimplementedError();
}

/* SNIPPET START */

final configurationsProvider = FutureProvider<Configuration>((ref) async {
  final uri = Uri.parse('configs.json');
  final rawJson = await File.fromUri(uri).readAsString();

  return Configuration.fromJson(json.decode(rawJson));
});

class Example extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final configs = ref.watch(configurationsProvider);

    // Use Riverpod's built-in support
    // for error/loading states using "when":
    return configs.when(
      loading: () => const CircularProgressIndicator(),
      error: (err, stack) => Text('Error $err'),
      data: (configs) => Text('data: ${configs.host}'),
    );
  }
}
