// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'async.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

typedef ConfigurationsRef = Ref<AsyncValue<Configuration>>;

@ProviderFor(configurations)
const configurationsProvider = ConfigurationsProvider._();

final class ConfigurationsProvider extends $FunctionalProvider<
        AsyncValue<Configuration>, FutureOr<Configuration>>
    with
        $FutureModifier<Configuration>,
        $FutureProvider<Configuration, ConfigurationsRef> {
  const ConfigurationsProvider._(
      {FutureOr<Configuration> Function(
        ConfigurationsRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'configurationsProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final FutureOr<Configuration> Function(
    ConfigurationsRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$configurationsHash();

  @$internal
  @override
  $FutureProviderElement<Configuration> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(this, pointer);

  @override
  ConfigurationsProvider $copyWithCreate(
    FutureOr<Configuration> Function(
      ConfigurationsRef ref,
    ) create,
  ) {
    return ConfigurationsProvider._(create: create);
  }

  @override
  FutureOr<Configuration> create(ConfigurationsRef ref) {
    final _$cb = _createCb ?? configurations;
    return _$cb(ref);
  }
}

String _$configurationsHash() => r'27f534f8b2a22c39b2d28c2414358a228c552155';

// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package, unreachable_from_main, invalid_use_of_internal_member
