import 'dart:math' as math;

import 'package:hooks_riverpod/hooks_riverpod.dart';

final randomProvider = Provider<int>((ref) {
  return math.Random().nextInt(6);
});

final taskTrackerProvider = Provider<TaskTrackerRepo>((ref) {
  return TaskTrackerRepo();
});

class TaskTrackerRepo {
  Future<int> fix({required String id, required int fixed}) async => 0;
}

final durationProvider = Provider<Duration>((ref) {
  return Duration.zero;
});

final availableWaterProvider = Provider<int>((ref) {
  return 40;
});
