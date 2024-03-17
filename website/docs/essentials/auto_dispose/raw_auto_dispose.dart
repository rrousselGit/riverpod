import 'package:riverpod/riverpod.dart';

/* SNIPPET START */
// We can specify autoDispose to enable automatic state destruction.
final provider = Provider.autoDispose<int>((ref) {
  return 0;
});
