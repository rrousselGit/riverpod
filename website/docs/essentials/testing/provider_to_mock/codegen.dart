import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'codegen.g.dart';

/* SNIPPET START */
// {@template provider}
// An eagerly initialized provider.
// {@endtemplate}
@riverpod
Future<String> example(Ref ref) async => 'Hello world';
/* SNIPPET END */
