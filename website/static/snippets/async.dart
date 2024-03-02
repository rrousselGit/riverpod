// Parse a file without having to deal with errors
// ignore_for_file: avoid_unused_constructor_parameters, use_key_in_widget_constructors

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'async.g.dart';

class Configuration {
  Configuration.fromJson(Object? json);

  String get host => throw UnimplementedError();
}

/* SNIPPET START */

@riverpod
Future<Configuration> configurations(ConfigurationsRef ref) async {
  final uri = Uri.parse('configs.json');
  final rawJson = await File.fromUri(uri).readAsString();

  return Configuration.fromJson(json.decode(rawJson));
}

class Example extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final configs = ref.watch(configurationsProvider);

    // Use pattern matching to safely handle loading/error states
    return switch (configs) {
      AsyncData(:final value) => Text('data: ${value.host}'),
      AsyncError(:final error) => Text('error: $error'),
      _ => const CircularProgressIndicator(),
    };
  }
}
