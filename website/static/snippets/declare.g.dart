// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'declare.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(Count)
const countProvider = CountProvider._();

final class CountProvider extends $NotifierProvider<Count, int> {
  const CountProvider._(
      {super.runNotifierBuildOverride, Count Function()? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'countProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final Count Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$countHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }

  @$internal
  @override
  Count create() => _createCb?.call() ?? Count();

  @$internal
  @override
  CountProvider $copyWithCreate(
    Count Function() create,
  ) {
    return CountProvider._(create: create);
  }

  @$internal
  @override
  CountProvider $copyWithBuild(
    int Function(
      Ref<int>,
      Count,
    ) build,
  ) {
    return CountProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<Count, int> $createElement(
          ProviderContainer container) =>
      $NotifierProviderElement(this, container);
}

String _$countHash() => r'6fc5f8ad4bbd390899dd0d14c7b902407d4413bd';

abstract class _$Count extends $Notifier<int> {
  int build();
  @$internal
  @override
  int runBuild() => build();
}

// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package, unreachable_from_main, invalid_use_of_internal_member
