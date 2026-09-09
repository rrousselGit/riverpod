// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'codegen.dart';

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

String _$breweryHash() => r'b70d9d5c77a6f80a0583d423ff09babe30976877';
