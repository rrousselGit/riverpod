// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'another.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

typedef BRef = Ref<int>;

@ProviderFor(b)
const bProvider = BProvider._();

final class BProvider extends $FunctionalProvider<int, int, BRef>
    with $Provider<int, BRef> {
  const BProvider._(
      {int Function(
        BRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'bProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final int Function(
    BRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$bHash();

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
  BProvider $copyWithCreate(
    int Function(
      BRef ref,
    ) create,
  ) {
    return BProvider._(create: create);
  }

  @override
  int create(BRef ref) {
    final _$cb = _createCb ?? b;
    return _$cb(ref);
  }
}

String _$bHash() => r'52593050701642f22b31c590f20c003dc2ee1579';

typedef AnotherScopedRef = Ref<int>;

@ProviderFor(anotherScoped)
const anotherScopedProvider = AnotherScopedProvider._();

final class AnotherScopedProvider
    extends $FunctionalProvider<int, int, AnotherScopedRef>
    with $Provider<int, AnotherScopedRef> {
  const AnotherScopedProvider._(
      {int Function(
        AnotherScopedRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'anotherScopedProvider',
          isAutoDispose: true,
          dependencies: const <ProviderOrFamily>[],
          allTransitiveDependencies: const <ProviderOrFamily>[],
        );

  final int Function(
    AnotherScopedRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$anotherScopedHash();

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
  AnotherScopedProvider $copyWithCreate(
    int Function(
      AnotherScopedRef ref,
    ) create,
  ) {
    return AnotherScopedProvider._(create: create);
  }

  @override
  int create(AnotherScopedRef ref) {
    final _$cb = _createCb ?? anotherScoped;
    return _$cb(ref);
  }
}

String _$anotherScopedHash() => r'409a070806b566d16d98f18c99bf6243d481887f';

typedef AnotherNonEmptyScopedRef = Ref<int>;

@ProviderFor(anotherNonEmptyScoped)
const anotherNonEmptyScopedProvider = AnotherNonEmptyScopedProvider._();

final class AnotherNonEmptyScopedProvider
    extends $FunctionalProvider<int, int, AnotherNonEmptyScopedRef>
    with $Provider<int, AnotherNonEmptyScopedRef> {
  const AnotherNonEmptyScopedProvider._(
      {int Function(
        AnotherNonEmptyScopedRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'anotherNonEmptyScopedProvider',
          isAutoDispose: true,
          dependencies: const <ProviderOrFamily>[anotherScopedProvider],
          allTransitiveDependencies: const <ProviderOrFamily>[
            AnotherNonEmptyScopedProvider.$allTransitiveDependencies0,
          ],
        );

  static const $allTransitiveDependencies0 = anotherScopedProvider;

  final int Function(
    AnotherNonEmptyScopedRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$anotherNonEmptyScopedHash();

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
  AnotherNonEmptyScopedProvider $copyWithCreate(
    int Function(
      AnotherNonEmptyScopedRef ref,
    ) create,
  ) {
    return AnotherNonEmptyScopedProvider._(create: create);
  }

  @override
  int create(AnotherNonEmptyScopedRef ref) {
    final _$cb = _createCb ?? anotherNonEmptyScoped;
    return _$cb(ref);
  }
}

String _$anotherNonEmptyScopedHash() =>
    r'cc21d248e644c853e4647ad60ca72cb42b82475f';

// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package, unreachable_from_main, invalid_use_of_internal_member
