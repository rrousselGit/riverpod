// ignore_for_file: unnecessary_this

import 'dart:math';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../utils.dart';

/* SNIPPET START */
class BugsEncounteredNotifier extends StateNotifier<AsyncValue<int>> {
  BugsEncounteredNotifier({
    required this.ref,
    required this.featureId,
  }) : super(const AsyncData(99));
  final String featureId;
  final Ref ref;

  Future<void> fix(int amount) async {
    state = await AsyncValue.guard(() async {
      final old = state.requireValue;
      final result = await ref.read(taskTrackerProvider).fix(id: featureId, fixed: amount);
      return max(old - result, 0);
    });
  }
}

final bugsEncounteredNotifierProvider =
    StateNotifierProvider.family.autoDispose<BugsEncounteredNotifier, int, String>((ref, id) {
  return BugsEncounteredNotifier(ref: ref, featureId: id);
});
