import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auto_dispose.g.dart';

/* SNIPPET START */
// autoDispose provider (keepAlive is false by default)
@riverpod
String example1(Example1Ref ref) => 'Hello world';

// non autoDispose provider
@Riverpod(keepAlive: true)
String example2(Example2Ref ref) => 'Hello world';
