import 'package:riverpod_annotation/riverpod_annotation.dart';

/* SNIPPET START */
// autoDispose provider (keepAlive is false by default)
@riverpod
String example1() => 'Hello world';

// non autoDispose provider
@Riverpod(keepAlive: true)
String example2() => 'Hello world';
