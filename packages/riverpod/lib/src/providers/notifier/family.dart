part of '../notifier.dart';

/// {@macro riverpod.notifier}
///
/// {@macro riverpod.notifier_provider_modifier}
abstract class FamilyNotifier<State, Arg> extends _NotifierBase<State> {
  /// {@macro riverpod.notifier.family_arg}
  late final Arg arg;

  /// {@macro riverpod.async_notifier.build}
  @visibleForOverriding
  State build(Arg arg);
}

/// The implementation of [NotifierFamilyProvider] but with loosened type constraints
/// that can be shared with [AutoDisposeNotifierProvider].
///
/// This enables tests to execute on both [NotifierProvider] and
/// [AutoDisposeNotifierProvider] at the same time.
@visibleForTesting
@internal
final class FamilyNotifierProvider //
    <NotifierT extends _NotifierBase<StateT>, StateT, ArgT>
    extends _NotifierProvider<NotifierT, StateT> {
  /// An implementation detail of Riverpod
  const FamilyNotifierProvider._(
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
  _NotifierProviderElement<NotifierT, StateT> createElement(
    ProviderContainer container,
  ) {
    return _NotifierProviderElement(this, container);
  }

  FamilyNotifierProvider<NotifierT, StateT, ArgT> _copyWith({
    NotifierT Function()? create,
    RunNotifierBuild<NotifierT, StateT, Ref<StateT>>? build,
  }) {
    return FamilyNotifierProvider._(
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
  FamilyNotifierProvider<NotifierT, StateT, ArgT> copyWithBuild(
    RunNotifierBuild<NotifierT, StateT, Ref<StateT>> build,
  ) {
    return _copyWith(build: build);
  }

  @override
  FamilyNotifierProvider<NotifierT, StateT, ArgT> copyWithCreate(
    NotifierT Function() create,
  ) {
    return _copyWith(create: create);
  }
}

/// The [Family] of [NotifierProvider].
class NotifierProviderFamily<
        NotifierT extends FamilyNotifier<StateT, ArgT>, StateT, ArgT>
    extends ClassFamily< //
        NotifierT,
        StateT,
        Ref<StateT>,
        ArgT,
        StateT,
        FamilyNotifierProvider<NotifierT, StateT, ArgT>> {
  /// The [Family] of [AsyncNotifierProvider].
  NotifierProviderFamily._(
    super._createFn, {
    super.name,
    super.dependencies,
  }) : super(
          providerFactory: FamilyNotifierProvider._,
          debugGetCreateSourceHash: null,
          isAutoDispose: false,
          allTransitiveDependencies:
              computeAllTransitiveDependencies(dependencies),
        );

  NotifierProviderFamily._autoDispose(
    super._createFn, {
    super.name,
    super.dependencies,
  }) : super(
          providerFactory: FamilyNotifierProvider._,
          debugGetCreateSourceHash: null,
          isAutoDispose: true,
          allTransitiveDependencies:
              computeAllTransitiveDependencies(dependencies),
        );

  /// The [Family] of [AsyncNotifierProvider].
  @internal
  NotifierProviderFamily.internal(
    super._createFn, {
    super.name,
    super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.isAutoDispose,
  }) : super(providerFactory: FamilyNotifierProvider._);
}
