import 'package:flutter_riverpod/flutter_riverpod.dart';

/* SNIPPET START */
// Provider autoDispose
final example1Provider = Provider.autoDispose<String>((ref) {
  return 'foo';
});

// Provider non autoDispose
final example2Provider = Provider<String>((ref) {
  return 'foo';
});
