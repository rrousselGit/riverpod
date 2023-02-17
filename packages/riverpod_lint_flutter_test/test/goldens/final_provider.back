import 'package:flutter_riverpod/flutter_riverpod.dart';

class Class {
  static final ok = Provider((ref) => 0);
  // expect_lint: prefer_final_provider
  static var staticShouldBeFinal = Provider((ref) => 0);
  // expect_lint: prefer_final_provider
  static Provider<int> get shouldBeFinalGetter => Provider((ref) => 0);
}

final ok = StateProvider((ref) => 0);

// expect_lint: prefer_final_provider
var shouldBeFinal = StateProvider.autoDispose((ref) => 0);

// expect_lint: prefer_final_provider
var shouldBeFinalFamily = StateProvider.autoDispose.family((ref, value) => 0);

// expect_lint: prefer_final_provider
Provider<int> get shouldBeFinalGetter => Provider((ref) => 0);
