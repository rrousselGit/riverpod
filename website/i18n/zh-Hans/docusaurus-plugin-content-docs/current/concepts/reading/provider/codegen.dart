// ignore_for_file: avoid_positional_boolean_parameters
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'codegen.g.dart';

class Repository {
  String get() => '';
}

@riverpod
Repository repository(RepositoryRef ref) => Repository();

/* SNIPPET START */

@riverpod
String value(ValueRef ref) {
  // 使用ref获取其他provider
  final repository = ref.watch(repositoryProvider);
  return repository.get();
}
