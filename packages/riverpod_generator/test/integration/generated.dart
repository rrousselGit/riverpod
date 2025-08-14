// ignore_for_file: library_private_types_in_public_api, inference_failure_on_function_return_type, always_declare_return_types, type_annotate_public_apis //

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated.g.dart';

@riverpod
$dynamic(Ref ref) => Object();

@riverpod
$dynamicFamily(Ref ref, test) => Object();

@riverpod
class $DynamicClass extends _$$DynamicClass {
  @override
  build() => Object();
}

@riverpod
class $DynamicClassFamily extends _$$DynamicClassFamily {
  @override
  build(test) => Object();
}

const dynamicProvider = _dynamicProvider;

@riverpod
_dynamic(Ref ref, test) => 0;

@riverpod
AsyncValue<int> alias(Ref ref) {
  return const AsyncData(42);
}

@riverpod
AsyncValue<int> aliasFamily(
  Ref ref,
  AsyncValue<int> test,
) {
  return const AsyncData(42);
}

@riverpod
class AliasClass extends _$AliasClass {
  @override
  AsyncValue<int> build() {
    return const AsyncData(42);
  }
}

@riverpod
class AliasClassFamily extends _$AliasClassFamily {
  @override
  AsyncValue<int> build(
    AsyncValue<int> test,
  ) {
    return const AsyncData(42);
  }
}
