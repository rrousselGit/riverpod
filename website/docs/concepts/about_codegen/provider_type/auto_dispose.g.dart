// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'auto_dispose.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

typedef Example1Ref = Ref<String>;

@ProviderFor(example1)
const example1Provider = Example1Provider._();

final class Example1Provider extends $FunctionalProvider<String, String>
    with $Provider<String, Example1Ref> {
  const Example1Provider._(
      {String Function(
        Example1Ref ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'example1Provider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final String Function(
    Example1Ref ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$example1Hash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<String>(value),
    );
  }

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

  @override
  Example1Provider $copyWithCreate(
    String Function(
      Example1Ref ref,
    ) create,
  ) {
    return Example1Provider._(create: create);
  }

  @override
  String create(Example1Ref ref) {
    final _$cb = _createCb ?? example1;
    return _$cb(ref);
  }
}

String _$example1Hash() => r'6a361ee6f9dd1d0cdbb42f967f6356aa058f7041';

typedef Example2Ref = Ref<String>;

@ProviderFor(example2)
const example2Provider = Example2Provider._();

final class Example2Provider extends $FunctionalProvider<String, String>
    with $Provider<String, Example2Ref> {
  const Example2Provider._(
      {String Function(
        Example2Ref ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'example2Provider',
          isAutoDispose: false,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final String Function(
    Example2Ref ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$example2Hash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<String>(value),
    );
  }

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

  @override
  Example2Provider $copyWithCreate(
    String Function(
      Example2Ref ref,
    ) create,
  ) {
    return Example2Provider._(create: create);
  }

  @override
  String create(Example2Ref ref) {
    final _$cb = _createCb ?? example2;
    return _$cb(ref);
  }
}

String _$example2Hash() => r'181b89435c06a7284a8978c5ab9f13bb4a3693b0';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
