import 'dart:math' as math;

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'utils.g.dart';

@riverpod
int random(RandomRef ref) {
  return math.Random().nextInt(6);
}

@riverpod
TaskTrackerRepo taskTracker(TaskTrackerRef ref) => TaskTrackerRepo();

class TaskTrackerRepo {
  Future<int> fix({required String id, required int fixed}) async => 0;
}

@riverpod
Duration duration(DurationRef ref) => Duration.zero;

@riverpod
int availableWater(AvailableWaterRef ref) => 40;
