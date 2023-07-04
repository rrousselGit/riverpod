import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'convert_function_based_provider_to_class_based.g.dart';

/// Some comment
@riverpod
int functionBased(FunctionBasedRef ref) => 0;

/// Some comment
@riverpod
int functionBasedFamily(FunctionBasedFamilyRef ref, {required int a, String b = '42'}) {
  // Hello world
  return 0;
}
