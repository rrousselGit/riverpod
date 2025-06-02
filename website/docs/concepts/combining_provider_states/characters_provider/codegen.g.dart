// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'codegen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(search)
const searchProvider = SearchProvider._();

final class SearchProvider extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  const SearchProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'searchProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$searchHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return search(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<String, String>(value),
    );
  }
}

String _$searchHash() => r'bc08d7ad4026615f3c0e4824c6b943f315cf18be';

@ProviderFor(configs)
const configsProvider = ConfigsProvider._();

final class ConfigsProvider extends $FunctionalProvider<
        AsyncValue<Configuration>, Configuration, Stream<Configuration>>
    with $FutureModifier<Configuration>, $StreamProvider<Configuration> {
  const ConfigsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'configsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$configsHash();

  @$internal
  @override
  $StreamProviderElement<Configuration> $createElement(
          $ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Configuration> create(Ref ref) {
    return configs(ref);
  }
}

String _$configsHash() => r'6416514dacd408abb24de2bd1404860e6518c564';

@ProviderFor(characters)
const charactersProvider = CharactersProvider._();

final class CharactersProvider extends $FunctionalProvider<
        AsyncValue<List<Character>>, List<Character>, FutureOr<List<Character>>>
    with $FutureModifier<List<Character>>, $FutureProvider<List<Character>> {
  const CharactersProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'charactersProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$charactersHash();

  @$internal
  @override
  $FutureProviderElement<List<Character>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Character>> create(Ref ref) {
    return characters(ref);
  }
}

String _$charactersHash() => r'd2bac558571ceae538d012696be58e2a06e8013f';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
