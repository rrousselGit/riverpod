import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../config_provider/cgen_provider.dart';

/* SNIPPET START */

Widget build(BuildContext context, WidgetRef ref) {
  final config = ref.watch(fetchConfigrationProvider);

  return config.when(
    loading: () => const CircularProgressIndicator(),
    error: (err, stack) => Text('Error: $err'),
    data: (config) {
      return Text(config.host);
    },
  );
}
