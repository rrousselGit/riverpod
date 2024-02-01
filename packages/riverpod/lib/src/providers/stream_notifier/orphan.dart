part of '../stream_notifier.dart';

/// {@template riverpod.streamNotifier}
/// A variant of [AsyncNotifier] which has [build] creating a [Stream].
///
/// This can be considered as a [StreamProvider] that can mutate its value over time.
///
/// The syntax for using this provider is slightly different from the others
/// in that the provider's function doesn't receive a "ref" (and in case
/// of `family`, doesn't receive an argument either).
/// Instead the ref (and argument) are directly accessible in the associated
/// [AsyncNotifier].
///
/// This can be considered as a [StreamProvider] that can mutate its value over time.
/// When using `family`, your notifier type changes. Instead of extending
/// [StreamNotifier], you should extend [FamilyStreamNotifier].
/// {@endtemplate}
abstract class StreamNotifier<State> extends StreamNotifierBase<State> {
  /// {@macro riverpod.async_notifier.build}
  @visibleForOverriding
  Stream<State> build();

  @internal
  @override
  Stream<State> runBuild() => build();
}

/// {@template riverpod.async_notifier_provider}
/// A provider which creates and listen to an [StreamNotifier].
///
/// This is similar to [FutureProvider] but allows to perform side-effects.
///
/// The syntax for using this provider is slightly different from the others
/// in that the provider's function doesn't receive a "ref" (and in case
/// of `family`, doesn't receive an argument either).
/// Instead the ref (and argument) are directly accessible in the associated
/// [StreamNotifier].
/// {@endtemplate}
///
/// {@template riverpod.async_notifier_provider_modifier}
/// When using `autoDispose` or `family`, your notifier type changes.
/// Instead of extending [StreamNotifier], you should extend either:
/// - [AutoDisposeAsyncNotifier] for `autoDispose`
/// - [FamilyAsyncNotifier] for `family`
/// - [AutoDisposeFamilyAsyncNotifier] for `autoDispose.family`
/// {@endtemplate}
final class StreamNotifierProvider< //
        NotifierT extends StreamNotifier<StateT>,
        StateT> //
    extends StreamNotifierProviderBase<NotifierT, StateT> {
  /// {@macro riverpod.async_notifier_provider}
  ///
  /// {@macro riverpod.async_notifier_provider_modifier}
  StreamNotifierProvider(
    super._createNotifier, {
    super.name,
    super.dependencies,
    super.runNotifierBuildOverride,
    super.isAutoDispose = false,
  }) : super(
          allTransitiveDependencies:
              computeAllTransitiveDependencies(dependencies),
          from: null,
          argument: null,
          debugGetCreateSourceHash: null,
        );

  StreamNotifierProvider._autoDispose(
    super._createNotifier, {
    super.name,
    super.dependencies,
    super.runNotifierBuildOverride,
  }) : super(
          allTransitiveDependencies:
              computeAllTransitiveDependencies(dependencies),
          from: null,
          argument: null,
          debugGetCreateSourceHash: null,
          isAutoDispose: true,
        );

  /// An implementation detail of Riverpod
  @internal
  const StreamNotifierProvider.internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required super.argument,
    required super.isAutoDispose,
    required super.runNotifierBuildOverride,
  });

  /// {@macro riverpod.autoDispose}
  static const autoDispose = AutoDisposeStreamNotifierProviderBuilder();

  /// {@macro riverpod.family}
  static const family = StreamNotifierProviderFamilyBuilder();

  StreamNotifierProvider<NotifierT, StateT> _copyWith({
    NotifierT Function()? create,
    RunNotifierBuild<NotifierT, Stream<StateT>, Ref<AsyncValue<StateT>>>? build,
  }) {
    return StreamNotifierProvider<NotifierT, StateT>.internal(
      create ?? _createNotifier,
      name: name,
      dependencies: dependencies,
      allTransitiveDependencies: allTransitiveDependencies,
      debugGetCreateSourceHash: debugGetCreateSourceHash,
      from: from,
      argument: argument,
      isAutoDispose: isAutoDispose,
      runNotifierBuildOverride: build ?? runNotifierBuildOverride,
    );
  }

  @internal
  @override
  _StreamNotifierProviderElement<NotifierT, StateT> createElement(
    ProviderContainer container,
  ) {
    return _StreamNotifierProviderElement(this, container);
  }

  @internal
  @override
  StreamNotifierProvider<NotifierT, StateT> copyWithBuild(
    RunNotifierBuild<NotifierT, Stream<StateT>, Ref<AsyncValue<StateT>>>? build,
  ) {
    return _copyWith(build: build);
  }

  @internal
  @override
  StreamNotifierProvider<NotifierT, StateT> copyWithCreate(
    NotifierT Function() create,
  ) {
    return _copyWith(create: create);
  }
}

class _StreamNotifierProviderElement< //
        NotifierT extends StreamNotifierBase<StateT>,
        StateT> //
    extends ClassProviderElement< //
        NotifierT,
        AsyncValue<StateT>,
        Stream<StateT>> //
    with
        FutureModifierElement<StateT> {
  _StreamNotifierProviderElement(this.provider, super.container);

  @override
  final StreamNotifierProviderBase<NotifierT, StateT> provider;

  @override
  void handleError(
    Object error,
    StackTrace stackTrace, {
    required bool didChangeDependency,
  }) {
    onError(AsyncError(error, stackTrace), seamless: !didChangeDependency);
  }

  @override
  void handleValue(
    Stream<StateT> created, {
    required bool didChangeDependency,
  }) {
    handleStream(
      () => created,
      didChangeDependency: didChangeDependency,
    );
  }
}
