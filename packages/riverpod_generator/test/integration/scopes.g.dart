// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scopes.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

typedef ScopedRef = Ref<int>;

const scopedProvider = ScopedProvider._();

final class ScopedProvider extends $FunctionalProvider<int, int, ScopedRef>
    with $Provider<int, ScopedRef> {
  const ScopedProvider._(
      {int Function(
        ScopedRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          debugGetCreateSourceHash: _$scopedHash,
          name: r'scoped',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final int Function(
    ScopedRef ref,
  )? _createCb;

  @override
  $ProviderElement<int> createElement(ProviderContainer container) =>
      $ProviderElement(this, container);

  @override
  int create(ScopedRef ref) {
    final fn = _createCb ?? scoped;

    return fn(
      ref,
    );
  }

  @override
  ScopedProvider copyWithCreate(
    int Function(
      ScopedRef ref,
    ) create,
  ) {
    return ScopedProvider._(create: create);
  }
}

String _$scopedHash() => r'590f1a203323105e732397a2616fbd7dac65f0cc';

const $kDebugMode = bool.fromEnvironment('dart.vm.product');
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package
