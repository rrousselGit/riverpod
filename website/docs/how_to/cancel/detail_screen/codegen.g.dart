// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'codegen.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Brewery _$BreweryFromJson(Map<String, dynamic> json) => _Brewery(
  name: json['name'] as String,
  breweryType: json['brewery_type'] as String,
  city: json['city'] as String,
  country: json['country'] as String,
);

Map<String, dynamic> _$BreweryToJson(_Brewery instance) => <String, dynamic>{
  'name': instance.name,
  'brewery_type': instance.breweryType,
  'city': instance.city,
  'country': instance.country,
};

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(brewery)
final breweryProvider = BreweryProvider._();

final class BreweryProvider
    extends $FunctionalProvider<AsyncValue<Brewery>, Brewery, FutureOr<Brewery>>
    with $FutureModifier<Brewery>, $FutureProvider<Brewery> {
  BreweryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'breweryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$breweryHash();

  @$internal
  @override
  $FutureProviderElement<Brewery> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Brewery> create(Ref ref) {
    return brewery(ref);
  }
}

String _$breweryHash() => r'c9a98cce6e0baeac2e729fada58916332db6712b';
