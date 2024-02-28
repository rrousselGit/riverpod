// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'codegen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

typedef FetchConfigurationRef = Ref<AsyncValue<Configuration>>;

@ProviderFor(fetchConfiguration)
const fetchConfigurationProvider = FetchConfigurationProvider._();

final class FetchConfigurationProvider extends $FunctionalProvider<
        AsyncValue<Configuration>,
        FutureOr<Configuration>,
        FetchConfigurationRef>
    with
        $FutureModifier<Configuration>,
        $FutureProvider<Configuration, FetchConfigurationRef> {
  const FetchConfigurationProvider._(
      {FutureOr<Configuration> Function(
        FetchConfigurationRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'fetchConfigurationProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final FutureOr<Configuration> Function(
    FetchConfigurationRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$fetchConfigurationHash();

  @$internal
  @override
  $FutureProviderElement<Configuration> $createElement(
          ProviderContainer container) =>
      $FutureProviderElement(this, container);

  @override
  FetchConfigurationProvider $copyWithCreate(
    FutureOr<Configuration> Function(
      FetchConfigurationRef ref,
    ) create,
  ) {
    return FetchConfigurationProvider._(create: create);
  }

  @override
  FutureOr<Configuration> create(FetchConfigurationRef ref) {
    final _$cb = _createCb ?? fetchConfiguration;
    return _$cb(ref);
  }
}

String _$fetchConfigurationHash() =>
    r'6c0f062e6f20baf883c4282856f1197fbe633d89';

// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package, unreachable_from_main, invalid_use_of_internal_member
