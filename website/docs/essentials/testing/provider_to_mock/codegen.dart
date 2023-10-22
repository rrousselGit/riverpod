import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'codegen.g.dart';

/* SNIPPET START */
// An eagerly initialized provider.
@riverpod
Future<String> example(ExampleRef ref) async => 'Hello world';
/* SNIPPET END */
