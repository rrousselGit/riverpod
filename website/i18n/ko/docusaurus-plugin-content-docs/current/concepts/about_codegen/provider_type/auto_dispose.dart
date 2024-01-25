import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auto_dispose.g.dart';

/* SNIPPET START */
// 자동폐기(AutoDispose) provider (keepAlive는 기본적으로 false)
@riverpod
String example1(Example1Ref ref) => 'foo';

// 비자동폐기(Non autoDispose) provider
@Riverpod(keepAlive: true)
String example2(Example2Ref ref) => 'foo';
