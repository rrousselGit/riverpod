// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scoped_providers_should_specify_dependencies.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

typedef ScopedRef = Ref<int>;

@ProviderFor(scoped)
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
          name: r'scopedProvider',
          isAutoDispose: true,
          dependencies: const <ProviderOrFamily>[],
          allTransitiveDependencies: const <ProviderOrFamily>[],
        );

  final int Function(
    ScopedRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$scopedHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }

  @$internal
  @override
  $ProviderElement<int> $createElement(ProviderContainer container) =>
      $ProviderElement(this, container);

  @override
  ScopedProvider $copyWithCreate(
    int Function(
      ScopedRef ref,
    ) create,
  ) {
    return ScopedProvider._(create: create);
  }

  @override
  int create(ScopedRef ref) {
    final _$cb = _createCb ?? scoped;
    return _$cb(ref);
  }
}

String _$scopedHash() => r'bbf25968b1186d2dd63d10545364453712d491cf';

typedef UnimplementedScopedRef = Ref<int>;

@ProviderFor(unimplementedScoped)
const unimplementedScopedProvider = UnimplementedScopedProvider._();

final class UnimplementedScopedProvider
    extends $FunctionalProvider<int, int, UnimplementedScopedRef>
    with $Provider<int, UnimplementedScopedRef> {
  const UnimplementedScopedProvider._(
      {int Function(
        UnimplementedScopedRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'unimplementedScopedProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final int Function(
    UnimplementedScopedRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$unimplementedScopedHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }

  @$internal
  @override
  $ProviderElement<int> $createElement(ProviderContainer container) =>
      $ProviderElement(this, container);

  @override
  UnimplementedScopedProvider $copyWithCreate(
    int Function(
      UnimplementedScopedRef ref,
    ) create,
  ) {
    return UnimplementedScopedProvider._(create: create);
  }

  @override
  int create(UnimplementedScopedRef ref) {
    final _$cb = _createCb ?? unimplementedScoped;
    return _$cb(ref);
  }
}

String _$unimplementedScopedHash() =>
    r'5f32fc56f4157238612d62ef54038fe92b7cdfe8';

typedef RootRef = Ref<int>;

@ProviderFor(root)
const rootProvider = RootProvider._();

final class RootProvider extends $FunctionalProvider<int, int, RootRef>
    with $Provider<int, RootRef> {
  const RootProvider._(
      {int Function(
        RootRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'rootProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final int Function(
    RootRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$rootHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }

  @$internal
  @override
  $ProviderElement<int> $createElement(ProviderContainer container) =>
      $ProviderElement(this, container);

  @override
  RootProvider $copyWithCreate(
    int Function(
      RootRef ref,
    ) create,
  ) {
    return RootProvider._(create: create);
  }

  @override
  int create(RootRef ref) {
    final _$cb = _createCb ?? root;
    return _$cb(ref);
  }
}

String _$rootHash() => r'1cd85d73316aad02169ff0f5e7af5cf1423410ff';

const $kDebugMode = bool.fromEnvironment('dart.vm.product');
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package, unreachable_from_main
