// ignore_for_file: avoid_positional_boolean_parameters

import 'package:flutter_riverpod/flutter_riverpod.dart';

class Repository {
  void get() {}
}

final repositoryProvider = Provider((ref) {
  return Repository();
});

/* SNIPPET START */

final valueProvider = Provider((ref) {
  // use ref to obtain other providers
  final repository = ref.watch(repositoryProvider);
  return repository.get();
});
