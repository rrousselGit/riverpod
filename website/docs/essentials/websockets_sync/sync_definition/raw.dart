import 'package:riverpod/riverpod.dart';

/* SNIPPET START */
final synchronousExampleProvider = Provider.autoDispose<int>((ref) {
  return 0;
});
/* SNIPPET END */