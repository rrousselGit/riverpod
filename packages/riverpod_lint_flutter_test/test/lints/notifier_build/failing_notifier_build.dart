@TestFor.notifier_build
library;

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../test_annotation.dart';

/// Fake Provider
typedef _$ExampleProvider1 = Object;

@riverpod
// ignore: riverpod_lint/notifier_build
class ExampleProvider1 extends _$ExampleProvider1 {}
