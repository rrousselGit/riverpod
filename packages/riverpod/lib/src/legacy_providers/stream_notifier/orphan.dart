part of '../async_notifier.dart';

/// {@macro riverpod.streamNotifier}
final class StreamNotifierProvider<
        NotifierT extends StreamNotifier<StateT>, //
        StateT> //
    extends _StreamNotifierProviderBase<NotifierT, StateT> {
  /// {@macro riverpod.streamNotifier}
  StreamNotifierProvider(
    super._createNotifier, {
    super.name,
    super.dependencies,
  })  : _runNotifierBuildOverride = null,
        super(
          allTransitiveDependencies:
              computeAllTransitiveDependencies(dependencies),
          from: null,
          argument: null,
          debugGetCreateSourceHash: null,
          isAutoDispose: false,
        );

  @internal
  const StreamNotifierProvider.internal(
    super._createNotifier, {
    required super.name,
    required super.from,
    required super.argument,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.isAutoDispose,
    RunNotifierBuild<NotifierT, Stream<StateT>, Ref<AsyncValue<StateT>>>?
        runNotifierBuildOverride,
  }) : _runNotifierBuildOverride = runNotifierBuildOverride;

  /// {@macro riverpod.autoDispose}
  static const autoDispose = AutoDisposeStreamNotifierProviderBuilder();

  /// {@macro riverpod.family}
  static const family = StreamNotifierProviderFamilyBuilder();

  final RunNotifierBuild<NotifierT, Stream<StateT>, Ref<AsyncValue<StateT>>>?
      _runNotifierBuildOverride;

  StreamNotifierProvider<NotifierT, StateT> _copyWith({
    NotifierT Function()? create,
    RunNotifierBuild<NotifierT, Stream<StateT>, Ref<AsyncValue<StateT>>>? build,
  }) {
    return StreamNotifierProvider.internal(
      create ?? _createNotifier,
      name: name,
      from: from,
      argument: argument,
      dependencies: dependencies,
      allTransitiveDependencies: allTransitiveDependencies,
      debugGetCreateSourceHash: debugGetCreateSourceHash,
      isAutoDispose: isAutoDispose,
      runNotifierBuildOverride: build ?? _runNotifierBuildOverride,
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
  Stream<StateT> runNotifierBuild(
    Ref<AsyncValue<StateT>> ref,
    NotifierT notifier,
  ) {
    return notifier.build();
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
}
