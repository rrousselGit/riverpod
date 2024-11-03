part of '../async_notifier.dart';

/// {@macro riverpod.async_notifier}
///
/// {@macro riverpod.async_notifier_provider_modifier}
abstract class FamilyAsyncNotifier<StateT, ArgT> extends $AsyncNotifier<StateT>
    implements
        // When not using code-generation, we always implement PersistAdapter
        // but throw if unimplemented.
        // This avoids using from having to subclass either `Notifier` or `OfflineNotifier`
        // when using offline persistence.
        // Code-generation handles this better by only implementing PersistAdapter
        // when offline persistence is used.
        PersistAdapter<AsyncValue<StateT>> {
  /// {@template riverpod.notifier.family_arg}
  /// The argument that was passed to this family.
  ///
  /// For example, when doing:
  ///
  /// ```dart
  /// ref.watch(provider(0));
  /// ```
  ///
  /// then [arg] will be `0`.
  /// {@endtemplate}
  late final ArgT arg = ref.$arg as ArgT;

  /// {@macro riverpod.async_notifier.build}
  @visibleForOverriding
  FutureOr<StateT> build(ArgT arg);

  @internal
  @override
  FutureOr<StateT> runBuild() => build(arg);

  @override
  Object? get persistKey => throw UnimplementedNotifierPersistError();
  @override
  Object? encode(AsyncValue<StateT> value) =>
      throw UnimplementedNotifierPersistError();
  @override
  AsyncValue<StateT> decode(Object? serialized) =>
      throw UnimplementedNotifierPersistError();
}

/// The [Family] of [AsyncNotifierProvider].
class AsyncNotifierProviderFamily< //
        NotifierT extends FamilyAsyncNotifier<StateT, ArgT>,
        StateT,
        ArgT> //
    extends ClassFamily< //
        NotifierT,
        AsyncValue<StateT>,
        ArgT,
        FutureOr<StateT>,
        FamilyAsyncNotifierProvider<NotifierT, StateT, ArgT>> {
  /// The [Family] of [AsyncNotifierProvider].
  @internal
  AsyncNotifierProviderFamily.internal(
    super._createFn, {
    super.name,
    super.dependencies,
    super.isAutoDispose = false,
    super.retry,
    super.persistOptions,
    super.shouldPersist,
  }) : super(
          providerFactory: FamilyAsyncNotifierProvider._,
          allTransitiveDependencies:
              computeAllTransitiveDependencies(dependencies),
        );
}

/// The provider returned by [AsyncNotifierProviderFamily].
final class FamilyAsyncNotifierProvider< //
        NotifierT extends FamilyAsyncNotifier<StateT, ArgT>,
        StateT,
        ArgT> //
    extends $AsyncNotifierProvider<NotifierT, StateT>
    with LegacyProviderMixin<AsyncValue<StateT>> {
  /// An implementation detail of Riverpod
  const FamilyAsyncNotifierProvider._(
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

  FamilyAsyncNotifierProvider<NotifierT, StateT, ArgT> _copyWith({
    NotifierT Function()? create,
    RunNotifierBuild<NotifierT, FutureOr<StateT>>? build,
  }) {
    return FamilyAsyncNotifierProvider<NotifierT, StateT, ArgT>._(
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

  final NotifierT Function() _createNotifier;

  @internal
  @override
  NotifierT create() => _createNotifier();

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
  FamilyAsyncNotifierProvider<NotifierT, StateT, ArgT> $copyWithBuild(
    RunNotifierBuild<NotifierT, FutureOr<StateT>>? build,
  ) {
    return _copyWith(build: build);
  }

  @mustBeOverridden
  @visibleForOverriding
  @override
  FamilyAsyncNotifierProvider<NotifierT, StateT, ArgT> $copyWithCreate(
    NotifierT Function() create,
  ) {
    return _copyWith(create: create);
  }
}
