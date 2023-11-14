import 'dart:math';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

@immutable
abstract class Equatable {
  const Equatable();

  List<Object?> get props;
}

/* SNIPPET START */
class ParamsType extends Equatable {
  const ParamsType({required this.seed, required this.max});

  final int seed;
  final int max;

  @override
  List<Object?> get props => [seed, max];
}

final randomProvider =
    Provider.family.autoDispose<int, ParamsType>((ref, params) {
  return Random(params.seed).nextInt(params.max);
});
