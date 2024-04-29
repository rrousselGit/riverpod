import 'package:riverpod_annotation/riverpod_annotation.dart';

/* SNIPPET START */
// {@template raw_autoDispose}
// We can specify autoDispose to enable automatic state destruction.
// {@endtemplate}
final provider = Provider.autoDispose<int>((ref) {
  return 0;
});
