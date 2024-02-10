// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'codegen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

typedef ConfigsRef = Ref<AsyncValue<Configuration>>;

@ProviderFor(configs)
const configsProvider = ConfigsProvider._();

final class ConfigsProvider extends $FunctionalProvider<
        AsyncValue<Configuration>, Stream<Configuration>, ConfigsRef>
    with
        $FutureModifier<Configuration>,
        $StreamProvider<Configuration, ConfigsRef> {
  const ConfigsProvider._(
      {Stream<Configuration> Function(
        ConfigsRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'configsProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final Stream<Configuration> Function(
    ConfigsRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$configsHash();

  @override
  $StreamProviderElement<Configuration> createElement(
          ProviderContainer container) =>
      $StreamProviderElement(this, container);

  @override
  ConfigsProvider $copyWithCreate(
    Stream<Configuration> Function(
      ConfigsRef ref,
    ) create,
  ) {
    return ConfigsProvider._(create: create);
  }

  @override
  Stream<Configuration> create(ConfigsRef ref) {
    final _$cb = _createCb ?? configs;
    return _$cb(ref);
  }
}

String _$configsHash() => r'166cbe95e6b49ed7bc78c96041fb14abddbf6911';

typedef CharactersRef = Ref<AsyncValue<List<Character>>>;

@ProviderFor(characters)
const charactersProvider = CharactersProvider._();

final class CharactersProvider extends $FunctionalProvider<
        AsyncValue<List<Character>>, FutureOr<List<Character>>, CharactersRef>
    with
        $FutureModifier<List<Character>>,
        $FutureProvider<List<Character>, CharactersRef> {
  const CharactersProvider._(
      {FutureOr<List<Character>> Function(
        CharactersRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'charactersProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final FutureOr<List<Character>> Function(
    CharactersRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$charactersHash();

  @override
  $FutureProviderElement<List<Character>> createElement(
          ProviderContainer container) =>
      $FutureProviderElement(this, container);

  @override
  CharactersProvider $copyWithCreate(
    FutureOr<List<Character>> Function(
      CharactersRef ref,
    ) create,
  ) {
    return CharactersProvider._(create: create);
  }

  @override
  FutureOr<List<Character>> create(CharactersRef ref) {
    final _$cb = _createCb ?? characters;
    return _$cb(ref);
  }
}

String _$charactersHash() => r'b1e8e15bbeab60d92fe959d9e1dd4ceba6a31446';

const $kDebugMode = bool.fromEnvironment('dart.vm.product');
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package, unreachable_from_main
