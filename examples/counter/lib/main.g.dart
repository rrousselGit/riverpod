// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

/// Annotating a class by `@riverpod` defines a new shared state for your application,
/// accessible using the generated [counterProvider].
/// This class is both responsible for initializing the state (through the [build] method)
/// and exposing ways to modify it (cf [increment]).
@ProviderFor(Counter)
const counterProvider = CounterProvider._();

/// Annotating a class by `@riverpod` defines a new shared state for your application,
/// accessible using the generated [counterProvider].
/// This class is both responsible for initializing the state (through the [build] method)
/// and exposing ways to modify it (cf [increment]).
final class CounterProvider extends $NotifierProvider<Counter, int> {
  /// Annotating a class by `@riverpod` defines a new shared state for your application,
  /// accessible using the generated [counterProvider].
  /// This class is both responsible for initializing the state (through the [build] method)
  /// and exposing ways to modify it (cf [increment]).
  const CounterProvider._(
      {super.runNotifierBuildOverride, Counter Function()? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'counterProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final Counter Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$counterHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }

  @$internal
  @override
  Counter create() => _createCb?.call() ?? Counter();

  @$internal
  @override
  CounterProvider $copyWithCreate(
    Counter Function() create,
  ) {
    return CounterProvider._(create: create);
  }

  @$internal
  @override
  CounterProvider $copyWithBuild(
    int Function(
      Ref<int>,
      Counter,
    ) build,
  ) {
    return CounterProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<Counter, int> $createElement(
          ProviderContainer container) =>
      $NotifierProviderElement(this, container);
}

String _$counterHash() => r'4243b34530f53accfd9014a9f0e316fe304ada3e';

abstract class _$Counter extends $Notifier<int> {
  int build();
  @$internal
  @override
  int runBuild() => build();
}

const $kDebugMode = bool.fromEnvironment('dart.vm.product');
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package, unreachable_from_main
