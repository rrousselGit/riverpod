// ignore_for_file: unnecessary_async

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'async_fn_future.g.dart';

/* SNIPPET START */
@riverpod
Future<String> example(Ref ref) async {
  return Future.value('foo');
}
