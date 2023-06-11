import 'package:flutter_riverpod/flutter_riverpod.dart';

/* SNIPPET START */
// autoDispose provider
final example1Provider = Provider.autoDispose<String>((ref) {
  return 'Hello world';
});

// non autoDispose provider
final example2Provider = Provider<String>((ref) {
  return 'Hello world';
});
