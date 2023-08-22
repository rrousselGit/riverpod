import 'dart:math';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../utils.dart';

/* SNIPPET START */
class BugsEncounteredNotifier extends FamilyAsyncNotifier<int, String> {
  late String _id;
  @override
  FutureOr<int> build(String featureId) {
    _id = featureId;
    return 99;
  }

  Future<void> fix(int amount) async {
    state = await AsyncValue.guard(() async {
      final old = state.requireValue;
      final result = await ref.read(taskTrackerProvider).fix(id: _id, fixed: amount);
      return max(old - result, 0);
    });
  }
}

final bugsEncounteredNotifierProvider =
    AsyncNotifierProviderFamily<BugsEncounteredNotifier, int, String>(BugsEncounteredNotifier.new);
