// ignore_for_file: library_private_types_in_public_api, inference_failure_on_function_return_type, always_declare_return_types, type_annotate_public_apis

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod/riverpod.dart' as r;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated.freezed.dart';
part 'generated.g.dart';

@freezed
class Test with _$Test {
  factory Test() = _Test;
}

@riverpod
_Test generated(GeneratedRef ref) => _Test();

@riverpod
_Test generatedFamily(GeneratedFamilyRef ref, _Test test) => _Test();

@riverpod
class GeneratedClass extends _$GeneratedClass {
  @override
  _Test build() => _Test();
}

@riverpod
class GeneratedClassFamily extends _$GeneratedClassFamily {
  @override
  _Test build(_Test test) => _Test();
}

@riverpod
$dynamic($DynamicRef ref) => _Test();

@riverpod
$dynamicFamily($DynamicFamilyRef ref, test) => _Test();

@riverpod
class $DynamicClass extends _$$DynamicClass {
  @override
  build() => _Test();
}

@riverpod
class $DynamicClassFamily extends _$$DynamicClassFamily {
  @override
  build(test) => _Test();
}

const dynamicProvider = _dynamicProvider;

@riverpod
_dynamic(_DynamicRef ref, test) => 0;

@riverpod
r.AsyncValue<int> alias(AliasRef ref) {
  return const r.AsyncData(42);
}

@riverpod
r.AsyncValue<int> aliasFamily(
  AliasFamilyRef ref,
  r.AsyncValue<int> test,
) {
  return const r.AsyncData(42);
}

@riverpod
class AliasClass extends _$AliasClass {
  @override
  r.AsyncValue<int> build() {
    return const r.AsyncData(42);
  }
}

@riverpod
class AliasClassFamily extends _$AliasClassFamily {
  @override
  r.AsyncValue<int> build(
    r.AsyncValue<int> test,
  ) {
    return const r.AsyncData(42);
  }
}
