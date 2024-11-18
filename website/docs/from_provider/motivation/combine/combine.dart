import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'combine.g.dart';

/* SNIPPET START */

@riverpod
int number(Ref ref) {
  return Random().nextInt(10);
}

@riverpod
int doubled(Ref ref) {
  final number = ref.watch(numberProvider);

  return number * 2;
}
