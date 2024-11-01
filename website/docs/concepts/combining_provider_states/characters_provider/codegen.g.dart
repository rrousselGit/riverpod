// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'codegen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(search)
const searchProvider = SearchProvider._();

final class SearchProvider extends $FunctionalProvider<String, String>
    with $Provider<String> {
  const SearchProvider._(
      {String Function(
        Ref ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'searchProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final String Function(
    Ref ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$searchHash();

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
  SearchProvider $copyWithCreate(
    String Function(
      Ref ref,
    ) create,
  ) {
    return SearchProvider._(create: create);
  }

  @override
  String create(Ref ref) {
    final _$cb = _createCb ?? search;
    return _$cb(ref);
  }
}

String _$searchHash() => r'bc08d7ad4026615f3c0e4824c6b943f315cf18be';

@ProviderFor(configs)
const configsProvider = ConfigsProvider._();

final class ConfigsProvider extends $FunctionalProvider<
        AsyncValue<Configuration>, Stream<Configuration>>
    with $FutureModifier<Configuration>, $StreamProvider<Configuration> {
  const ConfigsProvider._(
      {Stream<Configuration> Function(
        Ref ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'configsProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final Stream<Configuration> Function(
    Ref ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$configsHash();

  @$internal
  @override
  $StreamProviderElement<Configuration> $createElement(
          $ProviderPointer pointer) =>
      $StreamProviderElement(this, pointer);

  @override
  ConfigsProvider $copyWithCreate(
    Stream<Configuration> Function(
      Ref ref,
    ) create,
  ) {
    return ConfigsProvider._(create: create);
  }

  @override
  Stream<Configuration> create(Ref ref) {
    final _$cb = _createCb ?? configs;
    return _$cb(ref);
  }
}

String _$configsHash() => r'6416514dacd408abb24de2bd1404860e6518c564';

@ProviderFor(characters)
const charactersProvider = CharactersProvider._();

final class CharactersProvider extends $FunctionalProvider<
        AsyncValue<List<Character>>, FutureOr<List<Character>>>
    with $FutureModifier<List<Character>>, $FutureProvider<List<Character>> {
  const CharactersProvider._(
      {FutureOr<List<Character>> Function(
        Ref ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'charactersProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final FutureOr<List<Character>> Function(
    Ref ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$charactersHash();

  @$internal
  @override
  $FutureProviderElement<List<Character>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(this, pointer);

  @override
  CharactersProvider $copyWithCreate(
    FutureOr<List<Character>> Function(
      Ref ref,
    ) create,
  ) {
    return CharactersProvider._(create: create);
  }

  @override
  FutureOr<List<Character>> create(Ref ref) {
    final _$cb = _createCb ?? characters;
    return _$cb(ref);
  }
}

String _$charactersHash() => r'd2bac558571ceae538d012696be58e2a06e8013f';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
