// ignore_for_file: avoid_positional_boolean_parameters
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'codegen.g.dart';

class Repository {
  String get() => '';
}

@riverpod
Repository repository(Ref ref) => Repository();

/* SNIPPET START */

@riverpod
String value(Ref ref) {
  // use ref to obtain other providers
  final repository = ref.watch(repositoryProvider);
  return repository.get();
}
