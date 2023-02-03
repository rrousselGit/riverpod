// ignore_for_file: omit_local_variable_types

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/* SNIPPET START */

final counterProvider = StateProvider((ref) => 0);

Widget build(BuildContext context, WidgetRef ref) {
  // 使用 “read” 忽略provider的更新
  final counter = ref.read(counterProvider.notifier);
  return ElevatedButton(
    onPressed: () => counter.state++,
    child: const Text('button'),
  );
}
