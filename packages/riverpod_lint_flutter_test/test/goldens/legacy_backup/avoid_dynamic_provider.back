// ignore_for_file: unused_element, unused_local_variable

import 'package:flutter_riverpod/flutter_riverpod.dart';

final global = Provider((ref) => 0);

class Class {
  static final topLevel = Provider((ref) => 0);

  // expect_lint: riverpod_avoid_dynamic_provider
  final local = Provider((ref) => 0);
}

void fn() {
  // expect_lint: riverpod_avoid_dynamic_provider
  final shouldBeTopLevel = Provider((ref) => 0);
  // expect_lint: riverpod_avoid_dynamic_provider
  final shouldBeTopLevelFamily = Provider.family<int, int>((ref, id) => 0);
  // expect_lint: riverpod_avoid_dynamic_provider
  final shouldBeTopLevelAutoDispose = Provider.autoDispose((ref) => 0);
}
