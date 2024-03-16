// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'codegen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

typedef CityRef = Ref<String>;

@ProviderFor(city)
const cityProvider = CityProvider._();

final class CityProvider extends $FunctionalProvider<String, String>
    with $Provider<String, CityRef> {
  const CityProvider._(
      {String Function(
        CityRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'cityProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final String Function(
    CityRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$cityHash();

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
  CityProvider $copyWithCreate(
    String Function(
      CityRef ref,
    ) create,
  ) {
    return CityProvider._(create: create);
  }

  @override
  String create(CityRef ref) {
    final _$cb = _createCb ?? city;
    return _$cb(ref);
  }
}

String _$cityHash() => r'2ccdee096b5d5c1cafa736b3e52b788431b9af38';

// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package, unreachable_from_main, invalid_use_of_internal_member
