// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'auto_dispose.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

@ProviderFor(example1)
const example1Provider = Example1Provider._();

final class Example1Provider extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  const Example1Provider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'example1Provider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$example1Hash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return example1(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$example1Hash() => r'6a361ee6f9dd1d0cdbb42f967f6356aa058f7041';

@ProviderFor(example2)
const example2Provider = Example2Provider._();

final class Example2Provider extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  const Example2Provider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'example2Provider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$example2Hash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return example2(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$example2Hash() => r'181b89435c06a7284a8978c5ab9f13bb4a3693b0';
