import 'package:riverpod_annotation/riverpod_annotation.dart';

/* SNIPPET START */
@riverpod
Stream<String> example() async* {
  yield 'Hello World';
}