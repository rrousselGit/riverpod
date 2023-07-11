import 'dart:math';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'combine.g.dart';

/* SNIPPET START */

@riverpod
int number(NumberRef ref) {
  return Random().nextInt(10);
}

@riverpod
int doubled(DoubledRef ref) {
  final number = ref.watch(numberProvider);

  return number * 2;
}
