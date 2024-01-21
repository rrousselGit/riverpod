part of '../async_notifier.dart';

/// {@template riverpod.async_notifier}
/// A [Notifier] implementation that is asynchronously initialized.
///
/// This is similar to a [FutureProvider] but allows to perform side-effects
/// by defining public methods.
///
/// It is commonly used for:
/// - Caching a network request while also allowing to perform side-effects.
///   For example, `build` could fetch information about the current "user".
///   And the [AsyncNotifier] could expose methods such as "setName",
///   to allow changing the current user name.
/// - Initializing a [Notifier] from an asynchronous source of data.
///   For example, obtaining the initial state of [Notifier] from a local database.
/// {@endtemplate}
///
/// {@macro riverpod.async_notifier_provider_modifier}
abstract class AsyncNotifier<State> extends _AsyncNotifierBase<State> {
  /// {@template riverpod.async_notifier.build}
  /// Initialize an [AsyncNotifier].
  ///
  /// It is safe to use [Ref.watch] or [Ref.listen] inside this method.
  ///
  /// If a dependency of this [AsyncNotifier] (when using [Ref.watch]) changes,
  /// then [build] will be re-executed. On the other hand, the [AsyncNotifier]
  /// will **not** be recreated. Its instance will be preserved between
  /// executions of [build].
  ///
  /// If this method throws or returns a future that fails, the error
  /// will be caught and an [AsyncError] will be emitted.
  /// {@endtemplate}
  @visibleForOverriding
  FutureOr<State> build();
}

/// {@template riverpod.async_notifier_provider}
/// A provider which creates and listen to an [AsyncNotifier].
///
/// This is similar to [FutureProvider] but allows to perform side-effects.
///
/// The syntax for using this provider is slightly different from the others
/// in that the provider's function doesn't receive a "ref" (and in case
/// of `family`, doesn't receive an argument either).
/// Instead the ref (and argument) are directly accessible in the associated
/// [AsyncNotifier].
/// {@endtemplate}
///
/// {@template riverpod.async_notifier_provider_modifier}
/// When using `autoDispose` or `family`, your notifier type changes.
/// Instead of extending [AsyncNotifier], you should extend either:
/// - [AutoDisposeAsyncNotifier] for `autoDispose`
/// - [FamilyAsyncNotifier] for `family`
/// - [AutoDisposeFamilyAsyncNotifier] for `autoDispose.family`
/// {@endtemplate}
final class AsyncNotifierProvider< //
        NotifierT extends AsyncNotifier<StateT>,
        StateT> //
    extends _AsyncNotifierProviderBase<NotifierT, StateT> {
  /// {@macro riverpod.async_notifier_provider}
  ///
  /// {@macro riverpod.async_notifier_provider_modifier}
  AsyncNotifierProvider(
    super._createNotifier, {
    super.name,
    super.dependencies,
    super.isAutoDispose = false,
  }) : super(
          allTransitiveDependencies:
              computeAllTransitiveDependencies(dependencies),
          from: null,
          argument: null,
          debugGetCreateSourceHash: null,
          runNotifierBuildOverride: null,
        );

  AsyncNotifierProvider._autoDispose(
    super._createNotifier, {
    super.name,
    super.dependencies,
  }) : super(
          allTransitiveDependencies:
              computeAllTransitiveDependencies(dependencies),
          from: null,
          argument: null,
          debugGetCreateSourceHash: null,
          isAutoDispose: true,
          runNotifierBuildOverride: null,
        );

  /// An implementation detail of Riverpod
  @internal
  const AsyncNotifierProvider.internal(
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
  static const autoDispose = AutoDisposeAsyncNotifierProviderBuilder();

  /// {@macro riverpod.family}
  static const family = AsyncNotifierProviderFamilyBuilder();

  AsyncNotifierProvider<NotifierT, StateT> _copyWith({
    NotifierT Function()? create,
    RunNotifierBuild<NotifierT, FutureOr<StateT>, Ref<AsyncValue<StateT>>>?
        build,
  }) {
    return AsyncNotifierProvider<NotifierT, StateT>.internal(
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
  _AsyncNotifierProviderElement<NotifierT, StateT> createElement(
    ProviderContainer container,
  ) {
    return _AsyncNotifierProviderElement(this, container);
  }

  @internal
  @override
  AsyncNotifierProvider<NotifierT, StateT> copyWithBuild(
    RunNotifierBuild<NotifierT, FutureOr<StateT>, Ref<AsyncValue<StateT>>>?
        build,
  ) {
    return _copyWith(build: build);
  }

  @internal
  @override
  AsyncNotifierProvider<NotifierT, StateT> copyWithCreate(
    NotifierT Function() create,
  ) {
    return _copyWith(create: create);
  }
}

class _AsyncNotifierProviderElement< //
        NotifierT extends _AsyncNotifierBase<StateT>,
        StateT> //
    extends ClassProviderElement< //
        NotifierT,
        AsyncValue<StateT>,
        FutureOr<StateT>> //
    with
        FutureModifierElement<StateT> {
  _AsyncNotifierProviderElement(this.provider, super.container);

  @override
  final _AsyncNotifierProviderBase<NotifierT, StateT> provider;

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
    FutureOr<StateT> created, {
    required bool didChangeDependency,
  }) {
    handleFuture(
      () => created,
      didChangeDependency: didChangeDependency,
    );
  }
}
