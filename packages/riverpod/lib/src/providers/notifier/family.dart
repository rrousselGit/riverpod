part of '../notifier.dart';

/// {@macro riverpod.notifier}
///
/// {@macro riverpod.notifier_provider_modifier}
abstract class FamilyNotifier<StateT, ArgT> extends $Notifier<StateT> {
  /// {@macro riverpod.notifier.family_arg}
  late final ArgT arg = ref.$arg as ArgT;

  /// {@macro riverpod.async_notifier.build}
  @visibleForOverriding
  StateT build(ArgT arg);

  @internal
  @override
  StateT runBuild() => build(arg);
}

final class FamilyNotifierProvider //
    <NotifierT extends $Notifier<StateT>, StateT, ArgT>
    extends $NotifierProvider<NotifierT, StateT>
    with LegacyProviderMixin<StateT> {
  /// An implementation detail of Riverpod
  const FamilyNotifierProvider._(
    this._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.from,
    required super.argument,
    required super.isAutoDispose,
    required super.runNotifierBuildOverride,
  });

  final NotifierT Function() _createNotifier;

  @override
  NotifierT create() => _createNotifier();

  @internal
  @override
  $NotifierProviderElement<NotifierT, StateT> $createElement(
    ProviderContainer container,
  ) {
    return $NotifierProviderElement(this, container);
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
      isAutoDispose: isAutoDispose,
      runNotifierBuildOverride: build ?? runNotifierBuildOverride,
      from: from,
      argument: argument,
    );
  }

  @override
  @mustBeOverridden
  @visibleForOverriding
  FamilyNotifierProvider<NotifierT, StateT, ArgT> $copyWithBuild(
    RunNotifierBuild<NotifierT, StateT, Ref<StateT>> build,
  ) {
    return _copyWith(build: build);
  }

  @mustBeOverridden
  @visibleForOverriding
  @override
  FamilyNotifierProvider<NotifierT, StateT, ArgT> $copyWithCreate(
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
        ArgT,
        StateT,
        FamilyNotifierProvider<NotifierT, StateT, ArgT>> {
  /// The [Family] of [AsyncNotifierProvider].
  @internal
  NotifierProviderFamily.internal(
    super._createFn, {
    super.name,
    super.dependencies,
    super.isAutoDispose = false,
  }) : super(
          providerFactory: FamilyNotifierProvider._,
          allTransitiveDependencies:
              computeAllTransitiveDependencies(dependencies),
        );
}
