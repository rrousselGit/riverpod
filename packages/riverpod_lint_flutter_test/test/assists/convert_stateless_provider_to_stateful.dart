import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'convert_stateless_provider_to_stateful.g.dart';

/// Some comment
@riverpod
int stateless(StatelessRef ref) => 0;

/// Some comment
@riverpod
int statelessFamily(StatelessFamilyRef ref, {required int a, String b = '42'}) {
  // Hello world
  return 0;
}
