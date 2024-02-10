// ignore_for_file: omit_local_variable_types, prefer_final_locals

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'codegen.g.dart';

/* SNIPPET START */

@riverpod
class Counter extends _$Counter {
  @override
  int build() => 0;
  void increment() => state = state + 1;
}

Widget build(BuildContext context, WidgetRef ref) {
  Counter counter = ref.read(counterProvider.notifier);
  return ElevatedButton(
    onPressed: () => counter.increment(),
    child: const Text('button'),
  );
}
