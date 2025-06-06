import 'dart:math';

import 'package:riverpod/riverpod.dart';

/* SNIPPET START */

final numberProvider = Provider.autoDispose((ref) {
  return Random().nextInt(10);
});

final doubledProvider = Provider.autoDispose((ref) {
  final number = ref.watch(numberProvider);

  return number * 2;
});
