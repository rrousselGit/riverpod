// ignore_for_file: avoid_dynamic_calls, inference_failure_on_function_invocation

import 'package:flutter_riverpod/flutter_riverpod.dart';

class User {
  User();

  factory User.fromJson(_) => User();
}

/* SNIPPET START */
final currentItemIdProvider = Provider<String?>(
  // highlight-next-line
  dependencies: const [],
  (ref) => null,
);
