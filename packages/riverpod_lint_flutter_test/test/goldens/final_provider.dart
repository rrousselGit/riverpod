import 'package:flutter_riverpod/flutter_riverpod.dart';

class Class {
  static final ok = Provider((ref) => 0);
  static var staticShouldBeFinal = Provider((ref) => 0);
  static Provider<int> get shouldBeFinalGetter => Provider((ref) => 0);
}

final ok = StateProvider((ref) => 0);

var shouldBeFinal = StateProvider.autoDispose((ref) => 0);

var shouldBeFinalFamily = StateProvider.autoDispose.family((ref, value) => 0);

Provider<int> get shouldBeFinalGetter => Provider((ref) => 0);
