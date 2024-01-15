part of '../async_notifier.dart';

/// {@macro riverpod.async_notifier}
///
/// {@macro riverpod.async_notifier_provider_modifier}
abstract class FamilyAsyncNotifier<State, Arg>
    extends _AsyncNotifierBase<State> {
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
  late final Arg arg;

  /// {@macro riverpod.async_notifier.build}
  @visibleForOverriding
  FutureOr<State> build(Arg arg);
}

final class FamilyAsyncNotifierProvider< //
        NotifierT extends FamilyAsyncNotifier<StateT, ArgT>,
        StateT,
        ArgT> //
    extends _AsyncNotifierProviderBase<NotifierT, StateT> {
  /// An implementation detail of Riverpod
  const FamilyAsyncNotifierProvider._(
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

  @override
  _AsyncNotifierProviderElement<NotifierT, StateT> createElement(
    ProviderContainer container,
  ) {
    return _AsyncNotifierProviderElement(this, container);
  }

  FamilyAsyncNotifierProvider<NotifierT, StateT, ArgT> _copyWith({
    NotifierT Function()? create,
    RunNotifierBuild< //
            NotifierT,
            FutureOr<StateT>,
            Ref<AsyncValue<StateT>>>?
        build,
  }) {
    return FamilyAsyncNotifierProvider._(
      create ?? _createNotifier,
      name: name,
      dependencies: dependencies,
      allTransitiveDependencies: allTransitiveDependencies,
      debugGetCreateSourceHash: debugGetCreateSourceHash,
      isAutoDispose: isAutoDispose,
      runNotifierBuildOverride: build ?? runNotifierBuildOverride,
      from: from,
      argument: argument,
    );
  }

  @override
  FamilyAsyncNotifierProvider<NotifierT, StateT, ArgT> copyWithBuild(
    RunNotifierBuild<NotifierT, FutureOr<StateT>, Ref<AsyncValue<StateT>>>
        build,
  ) {
    return _copyWith(build: build);
  }

  @override
  FamilyAsyncNotifierProvider<NotifierT, StateT, ArgT> copyWithCreate(
    NotifierT Function() create,
  ) {
    return _copyWith(create: create);
  }
}

/// The [Family] of [AsyncNotifierProvider].
class AsyncNotifierProviderFamily< //
        NotifierT extends FamilyAsyncNotifier<StateT, ArgT>,
        StateT,
        ArgT> //
    extends ClassFamily< //
        NotifierT,
        AsyncValue<StateT>,
        Ref<AsyncValue<StateT>>,
        ArgT,
        FutureOr<StateT>,
        FamilyAsyncNotifierProvider<NotifierT, StateT, ArgT>> {
  /// The [Family] of [AsyncNotifierProvider].
  AsyncNotifierProviderFamily._(
    super._createFn, {
    super.name,
    super.dependencies,
    super.isAutoDispose = false,
  }) : super(
          providerFactory: FamilyAsyncNotifierProvider._,
          debugGetCreateSourceHash: null,
          allTransitiveDependencies:
              computeAllTransitiveDependencies(dependencies),
        );

  AsyncNotifierProviderFamily._autoDispose(
    super._createFn, {
    super.name,
    super.dependencies,
  }) : super(
          providerFactory: FamilyAsyncNotifierProvider._,
          debugGetCreateSourceHash: null,
          isAutoDispose: true,
          allTransitiveDependencies:
              computeAllTransitiveDependencies(dependencies),
        );

  /// The [Family] of [AsyncNotifierProvider].
  @internal
  AsyncNotifierProviderFamily.internal(
    super._createFn, {
    super.name,
    super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.isAutoDispose,
  }) : super(providerFactory: FamilyAsyncNotifierProvider._);
}
