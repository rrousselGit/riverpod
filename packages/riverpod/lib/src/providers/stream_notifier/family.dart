part of '../stream_notifier.dart';

/// An implementation detail of Riverpod
@publicInMisc
final class FamilyStreamNotifierProvider< //
        NotifierT extends StreamNotifier<ValueT>,
        ValueT,
        ArgT> //
    extends $StreamNotifierProvider<NotifierT, ValueT>
    with LegacyProviderMixin<AsyncValue<ValueT>> {
  /// An implementation detail of Riverpod
  const FamilyStreamNotifierProvider._(
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
        FamilyStreamNotifierProvider<NotifierT, ValueT, ArgT>> {
  /// The [Family] of [FamilyStreamNotifierProvider].
  /// @nodoc
  @internal
  StreamNotifierProviderFamily.internal(
    super._createFn, {
    super.name,
    super.dependencies,
    super.isAutoDispose = false,
    super.retry,
  }) : super(
          providerFactory: FamilyStreamNotifierProvider._,
          $allTransitiveDependencies:
              computeAllTransitiveDependencies(dependencies),
        );
}
