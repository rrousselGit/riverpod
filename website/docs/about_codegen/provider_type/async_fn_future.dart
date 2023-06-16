import 'package:riverpod_annotation/riverpod_annotation.dart';

/* SNIPPET START */
@riverpod
Future<String> example() async {
  return Future.value('Hello world');
}
