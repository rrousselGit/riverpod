// ignore_for_file: avoid_print

import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../utils.dart';

/* SNIPPET START */
class WellNotifier extends Notifier<int> {
  @override
  int build() {
    final availableWater = ref.watch(availableWaterProvider);
    return availableWater;
  }

  void drink(int liters) => state = min(state - liters, 0);
}

final wellNotifierProvider = NotifierProvider<WellNotifier, int>(WellNotifier.new);
