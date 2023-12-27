import 'dart:math';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'family.g.dart';
/* SNIPPET START */

@riverpod
int random(RandomRef ref, {required int seed, required int max}) {
  return Random(seed).nextInt(max);
}
