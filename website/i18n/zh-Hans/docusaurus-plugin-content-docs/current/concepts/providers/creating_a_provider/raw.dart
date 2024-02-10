import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyValue {}

/* SNIPPET START */

final myProvider = Provider((ref) {
  return MyValue();
});
