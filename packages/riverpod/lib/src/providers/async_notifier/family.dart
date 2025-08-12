part of '../async_notifier.dart';

/// The [Family] of [AsyncNotifierProvider].
/// @nodoc
@publicInMisc
final class AsyncNotifierProviderFamily< //
        NotifierT extends AsyncNotifier<ValueT>,
        ValueT,
        ArgT> //
    extends ClassFamily< //
        NotifierT,
        AsyncValue<ValueT>,
        ValueT,
        ArgT,
        FutureOr<ValueT>,
        FamilyAsyncNotifierProvider<NotifierT, ValueT, ArgT>> {
  /// The [Family] of [AsyncNotifierProvider].
  /// @nodoc
  @internal
  AsyncNotifierProviderFamily.internal(
    super._createFn, {
    super.name,
    super.dependencies,
    super.isAutoDispose = false,
    super.retry,
  }) : super(
          providerFactory: FamilyAsyncNotifierProvider._,
          $allTransitiveDependencies:
              computeAllTransitiveDependencies(dependencies),
        );
}

/// The provider returned by [AsyncNotifierProviderFamily].
@publicInMisc
final class FamilyAsyncNotifierProvider< //
        NotifierT extends AsyncNotifier<ValueT>,
        ValueT,
        ArgT> //
    extends $AsyncNotifierProvider<NotifierT, ValueT>
    with LegacyProviderMixin<AsyncValue<ValueT>> {
  /// An implementation detail of Riverpod
  const FamilyAsyncNotifierProvider._(
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
