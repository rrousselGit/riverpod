import 'dart:math' as math;

import 'package:hooks_riverpod/hooks_riverpod.dart';

final randomProvider = Provider<int>((ref) {
  return math.Random().nextInt(6);
});

final myRepositoryProvider = Provider<SomeRepo>((ref) {
  return SomeRepo();
});

class SomeRepo {
  Future<void> post({required String id, required int change}) async {}
}

final durationProvider = Provider<Duration>((ref) {
  return Duration.zero;
});
