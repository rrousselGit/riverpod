import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod/src/internals.dart';

part 'scoped.g.dart';

@provider
external Future<String> _scopedProvider(_ScopedProviderRef ref);

@provider
class _ScopedClass extends _$ScopedClass {
  @override
  Future<String> build();
}

@provider
external Future<void> _asyncScopedProvider(_AsyncScopedProviderRef ref);

@provider
class _AsyncScopedClass extends _$AsyncScopedClass {
  @override
  Future<String> build();
}
