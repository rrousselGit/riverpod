// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'split.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

typedef Counter2Ref = Ref<int>;

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
          debugGetCreateSourceHash: _$counter2Hash,
          name: r'counter2',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final int Function(
    Counter2Ref ref,
  )? _createCb;

  @override
  void $unimplemented() {}

  @override
  $ProviderElement<int> createElement(ProviderContainer container) =>
      $ProviderElement(this, container);

  @override
  int create(Counter2Ref ref) {
    final fn = _createCb ?? counter2;

    return fn(
      ref,
    );
  }

  @override
  Counter2Provider copyWithCreate(
    int Function(
      Counter2Ref ref,
    ) create,
  ) {
    return Counter2Provider._(create: create);
  }
}

String _$counter2Hash() => r'9328919066a683f85226fc59201bb7c54f107a7d';

typedef CounterRef = Ref<int>;

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
          debugGetCreateSourceHash: _$counterHash,
          name: r'counter',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final int Function(
    CounterRef ref,
  )? _createCb;

  @override
  void $unimplemented() {}

  @override
  $ProviderElement<int> createElement(ProviderContainer container) =>
      $ProviderElement(this, container);

  @override
  int create(CounterRef ref) {
    final fn = _createCb ?? counter;

    return fn(
      ref,
    );
  }

  @override
  CounterProvider copyWithCreate(
    int Function(
      CounterRef ref,
    ) create,
  ) {
    return CounterProvider._(create: create);
  }
}

String _$counterHash() => r'9b0db44ecc47057e79891e5ecd92d34b08637679';

const $kDebugMode = bool.fromEnvironment('dart.vm.product');
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package
