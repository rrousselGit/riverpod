// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'split.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(counter2)
const counter2Provider = Counter2Provider._();

final class Counter2Provider extends $FunctionalProvider<int, int>
    with $Provider<int> {
  const Counter2Provider._(
      {int Function(
        Ref ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'counter2Provider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final int Function(
    Ref ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$counter2Hash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

  @override
  Counter2Provider $copyWithCreate(
    int Function(
      Ref ref,
    ) create,
  ) {
    return Counter2Provider._(create: create);
  }

  @override
  int create(Ref ref) {
    final _$cb = _createCb ?? counter2;
    return _$cb(ref);
  }
}

String _$counter2Hash() => r'ab7bef7da79217c780c76761a5ae0c0172ca097e';

@ProviderFor(counter)
const counterProvider = CounterProvider._();

final class CounterProvider extends $FunctionalProvider<int, int>
    with $Provider<int> {
  const CounterProvider._(
      {int Function(
        Ref ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'counterProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final int Function(
    Ref ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$counterHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

  @override
  CounterProvider $copyWithCreate(
    int Function(
      Ref ref,
    ) create,
  ) {
    return CounterProvider._(create: create);
  }

  @override
  int create(Ref ref) {
    final _$cb = _createCb ?? counter;
    return _$cb(ref);
  }
}

String _$counterHash() => r'784ece48cb20fcfdec1553774ecfbd381d1e081f';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
