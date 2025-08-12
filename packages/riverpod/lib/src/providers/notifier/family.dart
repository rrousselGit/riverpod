part of '../notifier.dart';

/// The [NotifierProvider] that can be used with a [Family].
@publicInMisc
final class FamilyNotifierProvider //
    <NotifierT extends $Notifier<ValueT>, ValueT, ArgT>
    extends $NotifierProvider<NotifierT, ValueT>
    with LegacyProviderMixin<ValueT> {
  /// An implementation detail of Riverpod
  const FamilyNotifierProvider._(
    this._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.$allTransitiveDependencies,
    required super.from,
    required super.argument,
    required super.isAutoDispose,
    required super.retry,
  });

  final NotifierT Function() _createNotifier;

  /// @nodoc
  @internal
  @override
  NotifierT create() => _createNotifier();
}

/// The [Family] of [NotifierProvider].
@publicInMisc
final class NotifierProviderFamily<
        NotifierT extends Notifier<StateT>, StateT, ArgT>
    extends ClassFamily< //
        NotifierT,
        StateT,
        StateT,
        ArgT,
        StateT,
        FamilyNotifierProvider<NotifierT, StateT, ArgT>> {
  /// The [Family] of [FamilyNotifierProvider].
  /// @nodoc
  @internal
  NotifierProviderFamily.internal(
    super._createFn, {
    super.name,
    super.dependencies,
    super.isAutoDispose = false,
    super.retry,
  }) : super(
          providerFactory: FamilyNotifierProvider._,
          $allTransitiveDependencies:
              computeAllTransitiveDependencies(dependencies),
        );
}
