import 'dart:math';

import 'package:riverpod_annotation/riverpod_annotation.dart';

/* SNIPPET START */
typedef ParamsType = ({int seed, int max});

final randomProvider = Provider.family.autoDispose<int, ParamsType>((ref, params) {
  return Random(params.seed).nextInt(params.max);
});
