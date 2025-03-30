import 'package:riverpod/legacy.dart';

/* SNIPPET START */
final counterProvider = StateProvider<int>((ref) {
  return 0;
});
