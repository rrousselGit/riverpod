import 'package:flutter_riverpod/flutter_riverpod.dart';

/* SNIPPET START */
final exampleProvider =
    StreamProvider.autoDispose<String>((ref) async* {
  yield 'foo';
});
