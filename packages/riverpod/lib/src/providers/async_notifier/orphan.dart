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
abstract class AsyncNotifier<StateT> extends $AsyncNotifier<StateT> {
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
  FutureOr<StateT> build();

  @internal
  @override
  FutureOr<StateT> runBuild() => build();
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
/// When using `family`, your notifier type changes.
/// Instead of extending [AsyncNotifier], you should extend [FamilyAsyncNotifier].
/// {@endtemplate}
final class AsyncNotifierProvider< //
        NotifierT extends AsyncNotifier<StateT>,
        StateT> //
    extends $AsyncNotifierProvider<NotifierT, StateT>
    with LegacyProviderMixin<AsyncValue<StateT>> {
  /// {@macro riverpod.async_notifier_provider}
  ///
  /// {@macro riverpod.async_notifier_provider_modifier}
  AsyncNotifierProvider(
    this._createNotifier, {
    super.name,
    super.dependencies,
    super.isAutoDispose = false,
    super.retry,
    super.persistOptions,
    super.shouldPersist,
  }) : super(
          allTransitiveDependencies:
              computeAllTransitiveDependencies(dependencies),
          from: null,
          argument: null,
          runNotifierBuildOverride: null,
        );

  /// An implementation detail of Riverpod
  @internal
  const AsyncNotifierProvider.internal(
    this._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.from,
    required super.argument,
    required super.isAutoDispose,
    required super.runNotifierBuildOverride,
    required super.retry,
    required super.persistOptions,
    required super.shouldPersist,
  });

  /// {@macro riverpod.autoDispose}
  static const autoDispose = AutoDisposeAsyncNotifierProviderBuilder();

  /// {@macro riverpod.family}
  static const family = AsyncNotifierProviderFamilyBuilder();

  final NotifierT Function() _createNotifier;

  @internal
  @override
  NotifierT create() => _createNotifier();

  AsyncNotifierProvider<NotifierT, StateT> _copyWith({
    NotifierT Function()? create,
    RunNotifierBuild<NotifierT, FutureOr<StateT>>? build,
  }) {
    return AsyncNotifierProvider<NotifierT, StateT>.internal(
      create ?? _createNotifier,
      name: name,
      dependencies: dependencies,
      allTransitiveDependencies: allTransitiveDependencies,
      from: from,
      argument: argument,
      isAutoDispose: isAutoDispose,
      runNotifierBuildOverride: build ?? runNotifierBuildOverride,
      retry: retry,
      persistOptions: persistOptions,
      shouldPersist: shouldPersist,
    );
  }

  @internal
  @override
  $AsyncNotifierProviderElement<NotifierT, StateT> $createElement(
    $ProviderPointer pointer,
  ) {
    return $AsyncNotifierProviderElement(this, pointer);
  }

  @mustBeOverridden
  @visibleForOverriding
  @override
  AsyncNotifierProvider<NotifierT, StateT> $copyWithBuild(
    RunNotifierBuild<NotifierT, FutureOr<StateT>>? build,
  ) {
    return _copyWith(build: build);
  }

  @mustBeOverridden
  @visibleForOverriding
  @override
  AsyncNotifierProvider<NotifierT, StateT> $copyWithCreate(
    NotifierT Function() create,
  ) {
    return _copyWith(create: create);
  }
}
