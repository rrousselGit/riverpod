import 'package:riverpod/riverpod.dart';

/* SNIPPET START */
// {@template autoDispose}
// We can specify autoDispose to enable automatic state destruction.
// {@endtemplate}
final provider = Provider.autoDispose<int>((ref) {
  return 0;
});
