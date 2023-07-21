import 'package:flutter_riverpod/flutter_riverpod.dart';

/* SNIPPET START */
final exampleProvider = Provider.family<String, int>((ref, param) {
  return 'Hello $param';
});
