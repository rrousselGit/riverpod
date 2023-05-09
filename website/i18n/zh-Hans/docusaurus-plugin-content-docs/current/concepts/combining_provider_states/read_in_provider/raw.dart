import 'package:flutter_riverpod/flutter_riverpod.dart';

final anotherProvider = Provider((ref) => MyValue());

class MyValue {}

/* SNIPPET START */

final myProvider = Provider((ref) {
  // Bad practice to call `read` here
  final value = ref.read(anotherProvider);
  return value;
});
