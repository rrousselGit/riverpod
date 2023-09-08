import 'dart:math';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../utils.dart';

/* SNIPPET START */
class WellNotifier extends StateNotifier<int> {
  WellNotifier(super._state);

  void drink(int liters) => state = min(state - liters, 0);
}

final wellNotifierProvider = StateNotifierProvider<WellNotifier, int>((ref) {
  final availableWater = ref.watch(availableWaterProvider);
  return WellNotifier(availableWater);
});
