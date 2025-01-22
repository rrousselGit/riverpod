// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offline.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(Offline)
@MyAnnotation()
const offlineProvider = OfflineProvider._();

final class OfflineProvider extends $NotifierProvider<Offline, String> {
  const OfflineProvider._(
      {super.runNotifierBuildOverride, Offline Function()? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'offlineProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final Offline Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$offlineHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<String>(value),
    );
  }

  @$internal
  @override
  Offline create() => _createCb?.call() ?? Offline();

  @$internal
  @override
  OfflineProvider $copyWithCreate(
    Offline Function() create,
  ) {
    return OfflineProvider._(create: create);
  }

  @$internal
  @override
  OfflineProvider $copyWithBuild(
    String Function(
      Ref,
      Offline,
    ) build,
  ) {
    return OfflineProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<Offline, String> $createElement(
          $ProviderPointer pointer) =>
      $NotifierProviderElement(this, pointer);
}

String _$offlineHash() => r'c146ef72dec4f58874cf0b61357bfe4d87e44a1a';

abstract class _$Offline extends $Notifier<String> {
  String build();
  @$internal
  @override
  String runBuild() => build();
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
