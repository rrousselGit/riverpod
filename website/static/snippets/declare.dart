// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'declare.g.dart';

/* SNIPPET START */

// A shared state that can be accessed by multiple widgets at the same time.
@riverpod
class Count extends _$Count {
  @override
  int build() => 0;

  void increment() => state++;
}

// Consumes the shared state and rebuild when it changes
class Title extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(countProvider);
    return Text('$count');
  }
}
