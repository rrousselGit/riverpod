// ignore_for_file: unnecessary_this

import 'dart:math';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../utils.dart';

part 'family_and_dispose.g.dart';

/* SNIPPET START */
@riverpod
class BugsEncounteredNotifier extends _$BugsEncounteredNotifier {
  @override
  FutureOr<int> build(String featureId) {
    return 99;
  }

  Future<void> fix(int amount) async {
    final old = await future;
    final result = await ref.read(taskTrackerProvider).fix(id: this.featureId, fixed: amount);
    state = AsyncData(max(old - result, 0));
  }
}
