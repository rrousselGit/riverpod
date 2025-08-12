part of '../stream_notifier.dart';

/// The [Family] of [StreamNotifierProvider].
@publicInMisc
final class StreamNotifierProviderFamily< //
        NotifierT extends StreamNotifier<ValueT>,
        ValueT,
        ArgT> //
    extends ClassFamily< //
        NotifierT,
        AsyncValue<ValueT>,
        ValueT,
        ArgT,
        Stream<ValueT>,
        StreamNotifierProvider<NotifierT, ValueT>> {
  /// The [Family] of [StreamNotifierProvider].
  /// @nodoc
  @internal
  StreamNotifierProviderFamily.internal(
    super._createFn, {
    super.name,
    super.dependencies,
    super.isAutoDispose = false,
    super.retry,
  }) : super(
          providerFactory: StreamNotifierProvider.internal,
          $allTransitiveDependencies:
              computeAllTransitiveDependencies(dependencies),
        );
}
