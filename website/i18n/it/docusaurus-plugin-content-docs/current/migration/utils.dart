import 'dart:math' as math;

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'utils.g.dart';

@riverpod
int random(Ref ref) {
  return math.Random().nextInt(6);
}

@riverpod
TaskTrackerRepo taskTracker(Ref ref) => TaskTrackerRepo();

class TaskTrackerRepo {
  Future<int> fix({required String id, required int fixed}) async => 0;
}

@riverpod
Duration duration(Ref ref) => Duration.zero;

@riverpod
int availableWater(Ref ref) => 40;
