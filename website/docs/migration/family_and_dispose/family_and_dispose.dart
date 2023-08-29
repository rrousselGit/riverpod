import 'dart:math';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../utils.dart';

part 'family_and_dispose.g.dart';

/* SNIPPET START */
@riverpod
class BugsEncounteredNotifier extends _$BugsEncounteredNotifier {
  @override
  FutureOr<int> build(String featureId) {
    return 99;
  }

  Future<void> fix(int amount) async {
    state = await AsyncValue.guard(() async {
      final old = state.requireValue;
      final result = await ref.read(taskTrackerProvider).fix(id: featureId, fixed: amount);
      return max(old - result, 0);
    });
  }
}
