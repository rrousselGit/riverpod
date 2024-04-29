import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'codegen.g.dart';

/* SNIPPET START */
// {@template codegen_provider}
// An eagerly initialized provider.
// {@endtemplate}
@riverpod
Future<String> example(ExampleRef ref) async => 'Hello world';
/* SNIPPET END */
