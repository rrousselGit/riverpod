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
  void runBuild() {
    final created = build(arg);
    element()!.handleValue(ref, created);
  }
}

@publicInMisc
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
    required super.retry,
  });

  final NotifierT Function() _createNotifier;

  @internal
  @override
  NotifierT create() => _createNotifier();
}

/// The [Family] of [NotifierProvider].
@publicInMisc
final class NotifierProviderFamily<
        NotifierT extends FamilyNotifier<StateT, ArgT>, StateT, ArgT>
    extends ClassFamily< //
        NotifierT,
        StateT,
        StateT,
        ArgT,
        StateT,
        FamilyNotifierProvider<NotifierT, StateT, ArgT>> {
  /// The [Family] of [FamilyNotifierProvider].
  @internal
  NotifierProviderFamily.internal(
    super._createFn, {
    super.name,
    super.dependencies,
    super.isAutoDispose = false,
    super.retry,
  }) : super(
          providerFactory: FamilyNotifierProvider._,
          allTransitiveDependencies:
              computeAllTransitiveDependencies(dependencies),
        );
}
