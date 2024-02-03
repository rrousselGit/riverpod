import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'codegen.g.dart';

/* SNIPPET START */
// 이른 초기화된 provider.
@riverpod
Future<String> example(ExampleRef ref) async => 'Hello world';
/* SNIPPET END */
