import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auto_dispose.g.dart';

/* SNIPPET START */
// AutoDispose provider (keepAlive is false by default)
@riverpod
String example1(Ref ref) => 'foo';

// Non autoDispose provider
@Riverpod(keepAlive: true)
String example2(Ref ref) => 'foo';
