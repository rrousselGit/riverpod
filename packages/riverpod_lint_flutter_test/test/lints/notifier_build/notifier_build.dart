@TestFor.notifier_build
library;

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../test_annotation.dart';

part 'notifier_build.g.dart';

@riverpod
class ExampleProvider extends _$ExampleProvider {
  @override
  int build() => 0;
}
