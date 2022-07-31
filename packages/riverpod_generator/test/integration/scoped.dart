import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'scoped.g.dart';

@provider
external Future<void> _scopedProvider(Ref<String> ref);

@provider
class _ScopedClass extends _$ScopedClass {
  @override
  Future<void> build(Ref<String> ref);
}

@provider
external Future<void> _asyncScopedProvider(Ref<String> ref);

@provider
class _AsyncScopedClass extends _$AsyncScopedClass {
  @override
  Future<void> build(Ref<String> ref);
}
