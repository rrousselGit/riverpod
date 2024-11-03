// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'build_init.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(CounterNotifier)
const counterNotifierProvider = CounterNotifierProvider._();

final class CounterNotifierProvider
    extends $NotifierProvider<CounterNotifier, int> {
  const CounterNotifierProvider._(
      {super.runNotifierBuildOverride, CounterNotifier Function()? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'counterNotifierProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final CounterNotifier Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$counterNotifierHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }

  @$internal
  @override
  CounterNotifier create() => _createCb?.call() ?? CounterNotifier();

  @$internal
  @override
  CounterNotifierProvider $copyWithCreate(
    CounterNotifier Function() create,
  ) {
    return CounterNotifierProvider._(create: create);
  }

  @$internal
  @override
  CounterNotifierProvider $copyWithBuild(
    int Function(
      Ref,
      CounterNotifier,
    ) build,
  ) {
    return CounterNotifierProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<CounterNotifier, int> $createElement(
          $ProviderPointer pointer) =>
      $NotifierProviderElement(this, pointer);
}

String _$counterNotifierHash() => r'4a971b45b66819f429f205806499527353d1a78e';

abstract class _$CounterNotifier extends $Notifier<int> {
  int build();
  @$internal
  @override
  int runBuild() => build();
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
