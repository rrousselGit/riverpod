import 'package:riverpod/riverpod.dart';

/* SNIPPET START */
final counterProvider = StateProvider<int>((ref) {
  return 0;
});
