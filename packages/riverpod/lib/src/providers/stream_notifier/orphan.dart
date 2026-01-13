part of '../stream_notifier.dart';

/// {@template riverpod.stream_notifier}
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
/// {@endtemplate}
/// {@category Notifiers}
abstract class StreamNotifier<ValueT> extends $StreamNotifier<ValueT> {
  /// {@macro riverpod.async_notifier.build}
  @visibleForOverriding
  Stream<ValueT> build();

  @mustCallSuper
  @override
  void runBuild() {
    requireElement().handleCreate(ref, build);
  }
}

/// {@template riverpod.stream_notifier_provider}
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
/// {@category Providers}
final class StreamNotifierProvider<
  //
  NotifierT extends StreamNotifier<ValueT>,
  ValueT
> //
    extends $StreamNotifierProvider<NotifierT, ValueT>
    with LegacyProviderMixin<AsyncValue<ValueT>> {
  /// {@macro riverpod.stream_notifier_provider}
  StreamNotifierProvider(
    this._createNotifier, {
    super.name,
    super.dependencies,
    super.isAutoDispose = false,
    super.retry,
  }) : super(
         $allTransitiveDependencies: computeAllTransitiveDependencies(
           dependencies,
         ),
         from: null,
         argument: null,
       );

  /// An implementation detail of Riverpod
  /// @nodoc
  @internal
  StreamNotifierProvider.internal(
    this._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.$allTransitiveDependencies,
    required super.from,
    required super.argument,
    required super.isAutoDispose,
    required super.retry,
  });

  /// {@macro riverpod.autoDispose}
  static const autoDispose = AutoDisposeStreamNotifierProviderBuilder();

  /// {@macro riverpod.family}
  static const family = StreamNotifierProviderFamilyBuilder();

  final NotifierT Function() _createNotifier;

  /// @nodoc
  @internal
  @override
  NotifierT create() => _createNotifier();
}
