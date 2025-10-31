// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'async.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(configurations)
final configurationsProvider = ConfigurationsProvider._();

final class ConfigurationsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Configuration>,
          Configuration,
          FutureOr<Configuration>
        >
    with $FutureModifier<Configuration>, $FutureProvider<Configuration> {
  ConfigurationsProvider._()
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
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Configuration> create(Ref ref) {
    return configurations(ref);
  }
}

String _$configurationsHash() => r'9ba3dc8a87bfe57002a403f03c8e0db6ba4759fd';
