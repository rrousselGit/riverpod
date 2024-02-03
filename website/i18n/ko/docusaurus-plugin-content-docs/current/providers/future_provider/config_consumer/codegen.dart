import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../config_provider/codegen.dart';

/* SNIPPET START */

Widget build(BuildContext context, WidgetRef ref) {
  final config = ref.watch(fetchConfigurationProvider);

  return switch (config) {
    AsyncError(:final error) => Text('Error: $error'),
    AsyncData(:final value) => Text(value.host),
    _ => const CircularProgressIndicator(),
  };
}
