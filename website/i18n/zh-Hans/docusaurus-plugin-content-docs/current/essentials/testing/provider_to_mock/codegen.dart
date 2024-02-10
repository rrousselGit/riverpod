import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'codegen.g.dart';

/* SNIPPET START */
// 一个急于初始化的提供者程序。
@riverpod
Future<String> example(ExampleRef ref) async => 'Hello world';
/* SNIPPET END */
