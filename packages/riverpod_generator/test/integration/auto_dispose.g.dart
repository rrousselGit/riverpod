// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auto_dispose.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

typedef KeepAliveRef = Ref<int>;

const keepAliveProvider = KeepAliveProvider._();

final class KeepAliveProvider
    extends $FunctionalProvider<int, int, KeepAliveRef> {
  const KeepAliveProvider._(
      {int Function(
        KeepAliveRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          debugGetCreateSourceHash: _$keepAliveHash,
          name: r'keepAlive',
          isAutoDispose: false,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final int Function(
    KeepAliveRef ref,
  )? _createCb;

  @override
  $ProviderElement<int> createElement(ProviderContainer container) =>
      $ProviderElement(this, container);

  @override
  int create(KeepAliveRef ref) {
    final fn = _createCb ?? keepAlive;

    return fn(
      ref,
    );
  }

  @override
  KeepAliveProvider copyWithCreate(
    int Function(
      KeepAliveRef ref,
    ) create,
  ) {
    return KeepAliveProvider._(create: create);
  }
}

String _$keepAliveHash() => r'72dd192676126d487c24c7695a91d59410c62696';

typedef NotKeepAliveRef = Ref<int>;

const notKeepAliveProvider = NotKeepAliveProvider._();

final class NotKeepAliveProvider
    extends $FunctionalProvider<int, int, NotKeepAliveRef> {
  const NotKeepAliveProvider._(
      {int Function(
        NotKeepAliveRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          debugGetCreateSourceHash: _$notKeepAliveHash,
          name: r'notKeepAlive',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final int Function(
    NotKeepAliveRef ref,
  )? _createCb;

  @override
  $ProviderElement<int> createElement(ProviderContainer container) =>
      $ProviderElement(this, container);

  @override
  int create(NotKeepAliveRef ref) {
    final fn = _createCb ?? notKeepAlive;

    return fn(
      ref,
    );
  }

  @override
  NotKeepAliveProvider copyWithCreate(
    int Function(
      NotKeepAliveRef ref,
    ) create,
  ) {
    return NotKeepAliveProvider._(create: create);
  }
}

String _$notKeepAliveHash() => r'1ccc497d7c651f8e730ec1bcecf271ffe9615d83';

const $kDebugMode = bool.fromEnvironment('dart.vm.product');
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package
