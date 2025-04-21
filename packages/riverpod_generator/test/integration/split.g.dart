// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'split.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(counter2)
const counter2Provider = Counter2Provider._();

final class Counter2Provider extends $FunctionalProvider<int, int>
    with $Provider<int> {
  const Counter2Provider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'counter2Provider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$counter2Hash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return counter2(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }
}

String _$counter2Hash() => r'ab7bef7da79217c780c76761a5ae0c0172ca097e';

@ProviderFor(counter)
const counterProvider = CounterProvider._();

final class CounterProvider extends $FunctionalProvider<int, int>
    with $Provider<int> {
  const CounterProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'counterProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$counterHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return counter(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }
}

String _$counterHash() => r'784ece48cb20fcfdec1553774ecfbd381d1e081f';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
