part of '../stream_notifier.dart';

/// {@macro riverpod.async_notifier}
///
/// {@macro riverpod.async_notifier_provider_modifier}
abstract class FamilyStreamNotifier<State, Arg>
    extends _StreamNotifierBase<State> {
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
  Stream<State> build(Arg arg);
}

final class FamilyStreamNotifierProvider< //
        NotifierT extends FamilyStreamNotifier<StateT, ArgT>,
        StateT,
        ArgT> //
    extends _StreamNotifierProviderBase<NotifierT, StateT> {
  /// An implementation detail of Riverpod
  const FamilyStreamNotifierProvider._(
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
  _StreamNotifierProviderElement<NotifierT, StateT> createElement(
    ProviderContainer container,
  ) {
    return _StreamNotifierProviderElement(this, container);
  }

  FamilyStreamNotifierProvider<NotifierT, StateT, ArgT> _copyWith({
    NotifierT Function()? create,
    RunNotifierBuild< //
            NotifierT,
            Stream<StateT>,
            Ref<AsyncValue<StateT>>>?
        build,
  }) {
    return FamilyStreamNotifierProvider._(
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
  FamilyStreamNotifierProvider<NotifierT, StateT, ArgT> copyWithBuild(
    RunNotifierBuild<NotifierT, Stream<StateT>, Ref<AsyncValue<StateT>>> build,
  ) {
    return _copyWith(build: build);
  }

  @override
  FamilyStreamNotifierProvider<NotifierT, StateT, ArgT> copyWithCreate(
    NotifierT Function() create,
  ) {
    return _copyWith(create: create);
  }
}

/// The [Family] of [StreamNotifierProvider].
class StreamNotifierProviderFamily< //
        NotifierT extends FamilyStreamNotifier<StateT, ArgT>,
        StateT,
        ArgT> //
    extends ClassFamily< //
        NotifierT,
        AsyncValue<StateT>,
        Ref<AsyncValue<StateT>>,
        ArgT,
        Stream<StateT>,
        FamilyStreamNotifierProvider<NotifierT, StateT, ArgT>> {
  /// The [Family] of [StreamNotifierProvider].
  @internal
  StreamNotifierProviderFamily.internal(
    super._createFn, {
    super.name,
    super.dependencies,
    super.isAutoDispose = false,
  }) : super(
          providerFactory: FamilyStreamNotifierProvider._,
          allTransitiveDependencies:
              computeAllTransitiveDependencies(dependencies),
          debugGetCreateSourceHash: null,
        );
}
