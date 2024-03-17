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
abstract class StreamNotifier<StateT> extends $StreamNotifier<StateT> {
  /// {@macro riverpod.async_notifier.build}
  @visibleForOverriding
  Stream<StateT> build();

  @internal
  @override
  Stream<StateT> runBuild() => build();
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
/// When using your notifier type changes.
/// Instead of extending [StreamNotifier], you should extend [FamilyStreamNotifier].
/// {@endtemplate}
final class StreamNotifierProvider< //
        NotifierT extends StreamNotifier<StateT>,
        StateT> //
    extends $StreamNotifierProvider<NotifierT, StateT>
    with LegacyProviderMixin<AsyncValue<StateT>> {
  /// {@macro riverpod.async_notifier_provider}
  ///
  /// {@macro riverpod.async_notifier_provider_modifier}
  StreamNotifierProvider(
    this._createNotifier, {
    super.name,
    super.dependencies,
    super.runNotifierBuildOverride,
    super.isAutoDispose = false,
  }) : super(
          allTransitiveDependencies:
              computeAllTransitiveDependencies(dependencies),
          from: null,
          argument: null,
        );

  /// An implementation detail of Riverpod
  @internal
  const StreamNotifierProvider.internal(
    this._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.from,
    required super.argument,
    required super.isAutoDispose,
    required super.runNotifierBuildOverride,
  });

  /// {@macro riverpod.autoDispose}
  static const autoDispose = AutoDisposeStreamNotifierProviderBuilder();

  /// {@macro riverpod.family}
  static const family = StreamNotifierProviderFamilyBuilder();

  final NotifierT Function() _createNotifier;

  @internal
  @override
  NotifierT create() => _createNotifier();

  StreamNotifierProvider<NotifierT, StateT> _copyWith({
    NotifierT Function()? create,
    RunNotifierBuild<NotifierT, Stream<StateT>, Ref<AsyncValue<StateT>>>? build,
  }) {
    return StreamNotifierProvider<NotifierT, StateT>.internal(
      create ?? _createNotifier,
      name: name,
      dependencies: dependencies,
      allTransitiveDependencies: allTransitiveDependencies,
      from: from,
      argument: argument,
      isAutoDispose: isAutoDispose,
      runNotifierBuildOverride: build ?? runNotifierBuildOverride,
    );
  }

  @internal
  @override
  $StreamNotifierProviderElement<NotifierT, StateT> $createElement(
    $ProviderPointer pointer,
  ) {
    return $StreamNotifierProviderElement(this, pointer);
  }

  @mustBeOverridden
  @visibleForOverriding
  @override
  StreamNotifierProvider<NotifierT, StateT> $copyWithBuild(
    RunNotifierBuild<NotifierT, Stream<StateT>, Ref<AsyncValue<StateT>>>? build,
  ) {
    return _copyWith(build: build);
  }

  @mustBeOverridden
  @visibleForOverriding
  @override
  StreamNotifierProvider<NotifierT, StateT> $copyWithCreate(
    NotifierT Function() create,
  ) {
    return _copyWith(create: create);
  }
}
