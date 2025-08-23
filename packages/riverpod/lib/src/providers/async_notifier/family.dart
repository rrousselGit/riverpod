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
        AsyncNotifierProvider<NotifierT, ValueT>> {
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
          providerFactory: AsyncNotifierProvider.internal,
          $allTransitiveDependencies:
              computeAllTransitiveDependencies(dependencies),
        );
}
