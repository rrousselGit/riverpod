// ignore_for_file: unused_local_variable

import 'package:riverpod_annotation/riverpod_annotation.dart';

final otherProvider = Provider<int>((ref) => 0);

/* SNIPPET START */
final provider = Provider<int>((ref) {
  // "Ref" can be used here to read other providers
  final otherValue = ref.watch(otherProvider);

  return 0;
});
/* SNIPPET END */
