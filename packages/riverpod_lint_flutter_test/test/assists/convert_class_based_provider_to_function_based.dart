import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'convert_class_based_provider_to_function_based.g.dart';

/// Some comment
@riverpod
class ClassBased extends _$ClassBased {
  @override
  int build() => 0;
}

/// Some comment
@riverpod
class ClassBasedFamily extends _$ClassBasedFamily {
  @override
  int build({required int a, String b = '42'}) {
    // Hello world
    return 0;
  }
}
