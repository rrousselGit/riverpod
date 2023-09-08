// ignore_for_file: avoid_print

import 'dart:math';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../utils.dart';

part 'build_init.g.dart';

/* SNIPPET START */
@riverpod
class WellNotifier extends _$WellNotifier {
  @override
  int build() {
    final availableWater = ref.watch(availableWaterProvider);
    return availableWater;
  }

  void drink(int liters) => state = min(state - liters, 0);
}
