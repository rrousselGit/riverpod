// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'split.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

typedef Counter2Ref = Ref<int>;

@ProviderFor(counter2)
const counter2Provider = Counter2Provider._();

final class Counter2Provider extends $FunctionalProvider<int, int, Counter2Ref>
    with $Provider<int, Counter2Ref> {
  const Counter2Provider._(
      {int Function(
        Counter2Ref ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'counter2Provider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final int Function(
    Counter2Ref ref,
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
  $ProviderElement<int> $createElement(ProviderContainer container) =>
      $ProviderElement(this, container);

  @override
  Counter2Provider $copyWithCreate(
    int Function(
      Counter2Ref ref,
    ) create,
  ) {
    return Counter2Provider._(create: create);
  }

  @override
  int create(Counter2Ref ref) {
    final _$cb = _createCb ?? counter2;
    return _$cb(ref);
  }
}

String _$counter2Hash() => r'9328919066a683f85226fc59201bb7c54f107a7d';

typedef CounterRef = Ref<int>;

@ProviderFor(counter)
const counterProvider = CounterProvider._();

final class CounterProvider extends $FunctionalProvider<int, int, CounterRef>
    with $Provider<int, CounterRef> {
  const CounterProvider._(
      {int Function(
        CounterRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'counterProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final int Function(
    CounterRef ref,
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
  $ProviderElement<int> $createElement(ProviderContainer container) =>
      $ProviderElement(this, container);

  @override
  CounterProvider $copyWithCreate(
    int Function(
      CounterRef ref,
    ) create,
  ) {
    return CounterProvider._(create: create);
  }

  @override
  int create(CounterRef ref) {
    final _$cb = _createCb ?? counter;
    return _$cb(ref);
  }
}

String _$counterHash() => r'9b0db44ecc47057e79891e5ecd92d34b08637679';

// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package, unreachable_from_main
