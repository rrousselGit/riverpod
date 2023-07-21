import 'package:flutter_riverpod/flutter_riverpod.dart';

/* SNIPPET START */
final exampleProvider =
    FutureProvider.autoDispose<String>((ref) async {
  return Future.value('foo');
});
