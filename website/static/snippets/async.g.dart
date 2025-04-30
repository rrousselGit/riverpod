// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'async.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(configurations)
const configurationsProvider = ConfigurationsProvider._();

final class ConfigurationsProvider extends $FunctionalProvider<
        AsyncValue<Configuration>, FutureOr<Configuration>>
    with $FutureModifier<Configuration>, $FutureProvider<Configuration> {
  const ConfigurationsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'configurationsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$configurationsHash();

  @$internal
  @override
  $FutureProviderElement<Configuration> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Configuration> create(Ref ref) {
    return configurations(ref);
  }
}

String _$configurationsHash() => r'9ba3dc8a87bfe57002a403f03c8e0db6ba4759fd';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
