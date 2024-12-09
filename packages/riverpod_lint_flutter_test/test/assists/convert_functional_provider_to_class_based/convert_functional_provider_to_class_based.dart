import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'convert_functional_provider_to_class_based.g.dart';

/// Some comment
@riverpod
int example(Ref ref) => 0;

/// Some comment
@riverpod
int exampleFamily(Ref ref, {required int a, String b = '42'}) {
  // Hello world
  return 0;
}
