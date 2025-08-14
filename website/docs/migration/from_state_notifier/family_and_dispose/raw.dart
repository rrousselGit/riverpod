// ignore_for_file: unnecessary_this

import 'dart:math';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../utils.dart';

/* SNIPPET START */
class BugsEncounteredNotifier extends AsyncNotifier<int> {
  BugsEncounteredNotifier(this.arg);
  final String arg;

  @override
  FutureOr<int> build() {
    return 99;
  }

  Future<void> fix(int amount) async {
    final old = await future;
    final result =
        await ref.read(taskTrackerProvider).fix(id: this.arg, fixed: amount);
    state = AsyncData(max(old - result, 0));
  }
}

final bugsEncounteredNotifierProvider = AsyncNotifierProvider.family
    .autoDispose<BugsEncounteredNotifier, int, String>(
  BugsEncounteredNotifier.new,
);
