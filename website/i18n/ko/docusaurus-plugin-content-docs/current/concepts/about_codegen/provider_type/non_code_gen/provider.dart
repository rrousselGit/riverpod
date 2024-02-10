import 'package:flutter_riverpod/flutter_riverpod.dart';

/* SNIPPET START */
final exampleProvider = Provider.autoDispose<String>(
  (ref) {
    return 'foo';
  },
);
