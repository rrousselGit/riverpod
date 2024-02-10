// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'combine.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

typedef NumberRef = Ref<int>;

@ProviderFor(number)
const numberProvider = NumberProvider._();

final class NumberProvider extends $FunctionalProvider<int, int, NumberRef>
    with $Provider<int, NumberRef> {
  const NumberProvider._(
      {int Function(
        NumberRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'numberProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final int Function(
    NumberRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$numberHash();

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
  NumberProvider $copyWithCreate(
    int Function(
      NumberRef ref,
    ) create,
  ) {
    return NumberProvider._(create: create);
  }

  @override
  int create(NumberRef ref) {
    final _$cb = _createCb ?? number;
    return _$cb(ref);
  }
}

String _$numberHash() => r'725e25be57b9cc2bd914752f156e26a214596b63';

typedef DoubledRef = Ref<int>;

@ProviderFor(doubled)
const doubledProvider = DoubledProvider._();

final class DoubledProvider extends $FunctionalProvider<int, int, DoubledRef>
    with $Provider<int, DoubledRef> {
  const DoubledProvider._(
      {int Function(
        DoubledRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'doubledProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final int Function(
    DoubledRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$doubledHash();

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
  DoubledProvider $copyWithCreate(
    int Function(
      DoubledRef ref,
    ) create,
  ) {
    return DoubledProvider._(create: create);
  }

  @override
  int create(DoubledRef ref) {
    final _$cb = _createCb ?? doubled;
    return _$cb(ref);
  }
}

String _$doubledHash() => r'ddc640c876bdbe49fe72fe1632b5ff48687c9279';

const $kDebugMode = bool.fromEnvironment('dart.vm.product');
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package, unreachable_from_main
