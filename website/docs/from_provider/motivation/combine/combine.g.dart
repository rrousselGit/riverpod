// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'combine.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(number)
const numberProvider = NumberProvider._();

final class NumberProvider extends $FunctionalProvider<int, int>
    with $Provider<int> {
  const NumberProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'numberProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$numberHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return number(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }
}

String _$numberHash() => r'03ac91d5904c18f04321b140fd263ed6bc85d3c1';

@ProviderFor(doubled)
const doubledProvider = DoubledProvider._();

final class DoubledProvider extends $FunctionalProvider<int, int>
    with $Provider<int> {
  const DoubledProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'doubledProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$doubledHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return doubled(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }
}

String _$doubledHash() => r'2a7f7fadb89e55d6adcf11aaa21943c66b10df5e';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
