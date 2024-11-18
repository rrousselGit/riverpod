import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'async_fn_stream.g.dart';

/* SNIPPET START */
@riverpod
Stream<String> example(Ref ref) async* {
  yield 'foo';
}
