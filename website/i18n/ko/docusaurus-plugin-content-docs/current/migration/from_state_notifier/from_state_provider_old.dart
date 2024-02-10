import 'package:flutter_riverpod/legacy.dart';
import 'package:riverpod/riverpod.dart';

/* SNIPPET START */
final counterProvider = StateProvider<int>((ref) {
  return 0;
});
