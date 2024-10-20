import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'family.g.dart';
/* SNIPPET START */

@riverpod
int random(Ref ref, {required int seed, required int max}) {
  return Random(seed).nextInt(max);
}
