// ignore_for_file: omit_local_variable_types, prefer_final_locals

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config_provider/raw.dart';

/* SNIPPET START */

Widget build(BuildContext context, WidgetRef ref) {
  AsyncValue<Configuration> config = ref.watch(configProvider);

  return switch (config) {
    AsyncData(:final value) => Text(value.host),
    AsyncError(:final error) => Text('Error: $error'),
    _ => const CircularProgressIndicator(),
  };
}
