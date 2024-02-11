// ignore_for_file: unused_import

import 'package:riverpod/riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ignore_for_file: undefined_function, undefined_identifier

// expect_lint: missing_legacy_import
final p = StateProvider((ref) => 0);

// expect_lint: missing_legacy_import
final p2 = StateProvider.autoDispose((ref) => 0);

// expect_lint: missing_legacy_import
final p3 = ChangeNotifierProvider((ref) => 0);

// expect_lint: missing_legacy_import
final p4 = StateNotifierProvider((ref) => 0);
