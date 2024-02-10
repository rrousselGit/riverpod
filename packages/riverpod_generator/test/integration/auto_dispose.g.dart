// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auto_dispose.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

typedef KeepAliveRef = Ref<int>;

@ProviderFor(keepAlive)
const keepAliveProvider = KeepAliveProvider._();

final class KeepAliveProvider
    extends $FunctionalProvider<int, int, KeepAliveRef>
    with $Provider<int, KeepAliveRef> {
  const KeepAliveProvider._(
      {int Function(
        KeepAliveRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'keepAliveProvider',
          isAutoDispose: false,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final int Function(
    KeepAliveRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$keepAliveHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }

  @override
  $ProviderElement<int> createElement(ProviderContainer container) =>
      $ProviderElement(this, container);

  @override
  KeepAliveProvider $copyWithCreate(
    int Function(
      KeepAliveRef ref,
    ) create,
  ) {
    return KeepAliveProvider._(create: create);
  }

  @override
  int create(KeepAliveRef ref) {
    final fn = _createCb ?? keepAlive;
    return fn(ref);
  }
}

String _$keepAliveHash() => r'72dd192676126d487c24c7695a91d59410c62696';

typedef NotKeepAliveRef = Ref<int>;

@ProviderFor(notKeepAlive)
const notKeepAliveProvider = NotKeepAliveProvider._();

final class NotKeepAliveProvider
    extends $FunctionalProvider<int, int, NotKeepAliveRef>
    with $Provider<int, NotKeepAliveRef> {
  const NotKeepAliveProvider._(
      {int Function(
        NotKeepAliveRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'notKeepAliveProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final int Function(
    NotKeepAliveRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$notKeepAliveHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }

  @override
  $ProviderElement<int> createElement(ProviderContainer container) =>
      $ProviderElement(this, container);

  @override
  NotKeepAliveProvider $copyWithCreate(
    int Function(
      NotKeepAliveRef ref,
    ) create,
  ) {
    return NotKeepAliveProvider._(create: create);
  }

  @override
  int create(NotKeepAliveRef ref) {
    final fn = _createCb ?? notKeepAlive;
    return fn(ref);
  }
}

String _$notKeepAliveHash() => r'1ccc497d7c651f8e730ec1bcecf271ffe9615d83';

typedef DefaultKeepAliveRef = Ref<int>;

@ProviderFor(defaultKeepAlive)
const defaultKeepAliveProvider = DefaultKeepAliveProvider._();

final class DefaultKeepAliveProvider
    extends $FunctionalProvider<int, int, DefaultKeepAliveRef>
    with $Provider<int, DefaultKeepAliveRef> {
  const DefaultKeepAliveProvider._(
      {int Function(
        DefaultKeepAliveRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'defaultKeepAliveProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final int Function(
    DefaultKeepAliveRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$defaultKeepAliveHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }

  @override
  $ProviderElement<int> createElement(ProviderContainer container) =>
      $ProviderElement(this, container);

  @override
  DefaultKeepAliveProvider $copyWithCreate(
    int Function(
      DefaultKeepAliveRef ref,
    ) create,
  ) {
    return DefaultKeepAliveProvider._(create: create);
  }

  @override
  int create(DefaultKeepAliveRef ref) {
    final fn = _createCb ?? defaultKeepAlive;
    return fn(ref);
  }
}

String _$defaultKeepAliveHash() => r'1c236764d83a62ca442c5d5b4a83bd0d6e4548cf';

const $kDebugMode = bool.fromEnvironment('dart.vm.product');
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package, unreachable_from_main
