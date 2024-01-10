part of '../async_notifier.dart';

/// {@macro riverpod.streamNotifier}
abstract class FamilyStreamNotifier<State, Arg>
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

  /// {@macro riverpod.StreamNotifier.build}
  @visibleForOverriding
  Stream<State> build(Arg arg);
}

final class FamilyStreamNotifierProvider<
    NotifierT extends FamilyStreamNotifier<StateT, ArgT>,
    StateT,
    ArgT> extends _StreamNotifierProviderBase<NotifierT, StateT> {
  @internal
  const FamilyStreamNotifierProvider.internal(
    super._createNotifier, {
    required super.name,
    required super.from,
    required super.argument,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.isAutoDispose,
    required RunNotifierBuild<NotifierT, Stream<StateT>,
            Ref<AsyncValue<StateT>>>?
        runNotifierBuild,
  }) : _runNotifierBuildOverride = runNotifierBuild;

  /// {@macro riverpod.autoDispose}
  static const autoDispose = AutoDisposeStreamNotifierProviderFamily.new;

  final RunNotifierBuild<NotifierT, Stream<StateT>, Ref<AsyncValue<StateT>>>?
      _runNotifierBuildOverride;

  FamilyStreamNotifierProvider<NotifierT, StateT, ArgT> _copyWith({
    NotifierT Function()? create,
    RunNotifierBuild<NotifierT, Stream<StateT>, Ref<AsyncValue<StateT>>>? build,
  }) {
    return FamilyStreamNotifierProvider.internal(
      create ?? _createNotifier,
      name: name,
      from: from,
      argument: argument,
      dependencies: dependencies,
      allTransitiveDependencies: allTransitiveDependencies,
      debugGetCreateSourceHash: debugGetCreateSourceHash,
      isAutoDispose: isAutoDispose,
      runNotifierBuild: build ?? _runNotifierBuildOverride,
    );
  }

  @override
  _StreamNotifierProviderElement<NotifierT, StateT> createElement(
    ProviderContainer container,
  ) {
    return _StreamNotifierProviderElement(this, container);
  }

  @internal
  @override
  ClassProvider< //
      NotifierT,
      AsyncValue<StateT>,
      Stream<StateT>,
      Ref<AsyncValue<StateT>>> copyWithBuild(
    RunNotifierBuild<NotifierT, Stream<StateT>, Ref<AsyncValue<StateT>>> build,
  ) {
    return _copyWith(build: build);
  }

  @internal
  @override
  ClassProvider< //
      NotifierT,
      AsyncValue<StateT>,
      Stream<StateT>,
      Ref<AsyncValue<StateT>>> copyWithCreate(NotifierT Function() create) {
    return _copyWith(create: create);
  }

  @internal
  @override
  Stream<StateT> runNotifierBuild(
    Ref<AsyncValue<StateT>> ref,
    NotifierT notifier,
  ) {
    return notifier.build(argument as ArgT);
  }
}

/// The [Family] of [StreamNotifierProvider].
class StreamNotifierProviderFamily< //
        NotifierT extends FamilyStreamNotifier<StateT, Arg>,
        StateT,
        Arg> //
    extends ClassFamily< //
        NotifierT,
        AsyncValue<StateT>,
        Ref<AsyncValue<StateT>>,
        Arg,
        Stream<StateT>,
        _StreamNotifierProviderBase<NotifierT, StateT>> {
  @internal
  StreamNotifierProviderFamily.internal(
    super._createFn, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.isAutoDispose,
  }) : super(
          providerFactory: (
            create, {
            required name,
            required dependencies,
            required allTransitiveDependencies,
            required debugGetCreateSourceHash,
            required isAutoDispose,
            required from,
            required argument,
          }) {
            return FamilyStreamNotifierProvider<NotifierT, StateT,
                Arg>.internal(
              create,
              name: name,
              dependencies: dependencies,
              allTransitiveDependencies: allTransitiveDependencies,
              debugGetCreateSourceHash: debugGetCreateSourceHash,
              isAutoDispose: isAutoDispose,
              from: from,
              argument: argument,
              runNotifierBuild: null,
            );
          },
        );
}
