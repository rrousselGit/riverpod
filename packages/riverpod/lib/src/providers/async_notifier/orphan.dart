part of '../async_notifier.dart';

/// {@template riverpod.async_notifier}
/// A [Notifier] implementation that is asynchronously initialized.
///
/// This is similar to a [FutureProvider] but allows to perform side-effects
/// by defining public methods.
///
/// It is commonly used for:
/// - Caching a network request while also allowing to perform side-effects.
///   For example, `build` could fetch information about the current "user".
///   And the [AsyncNotifier] could expose methods such as "setName",
///   to allow changing the current user name.
/// - Initializing a [Notifier] from an asynchronous source of data.
///   For example, obtaining the initial state of [Notifier] from a local database.
/// {@endtemplate}
/// {@category Notifiers}
abstract class AsyncNotifier<StateT> extends $AsyncNotifier<StateT> {
  /// {@template riverpod.async_notifier.build}
  /// Initialize an [AsyncNotifier].
  ///
  /// It is safe to use [Ref.watch] or [Ref.listen] inside this method.
  ///
  /// If a dependency of this [AsyncNotifier] (when using [Ref.watch]) changes,
  /// then [build] will be re-executed. On the other hand, the [AsyncNotifier]
  /// will **not** be recreated. Its instance will be preserved between
  /// executions of [build].
  ///
  /// If this method throws or returns a future that fails, the error
  /// will be caught and an [AsyncError] will be emitted.
  /// {@endtemplate}
  @visibleForOverriding
  FutureOr<StateT> build();

  @mustCallSuper
  @override
  void runBuild() {
    requireElement().handleCreate(ref, build);
  }
}

/// {@template riverpod.async_notifier_provider}
/// A provider which creates and listen to an [AsyncNotifier].
///
/// This is similar to [FutureProvider] but allows to perform side-effects.
///
/// The syntax for using this provider is slightly different from the others
/// in that the provider's function doesn't receive a "ref" (and in case
/// of `family`, doesn't receive an argument either).
/// Instead the ref (and argument) are directly accessible in the associated
/// [AsyncNotifier].
/// {@endtemplate}
/// {@category Providers}
final class AsyncNotifierProvider<
  //
  NotifierT extends AsyncNotifier<ValueT>,
  ValueT
> //
    extends $AsyncNotifierProvider<NotifierT, ValueT>
    with LegacyProviderMixin<AsyncValue<ValueT>> {
  /// {@macro riverpod.async_notifier_provider}
  AsyncNotifierProvider(
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
  AsyncNotifierProvider.internal(
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
  static const autoDispose = AutoDisposeAsyncNotifierProviderBuilder();

  /// {@macro riverpod.family}
  static const family = AsyncNotifierProviderFamilyBuilder();

  final NotifierT Function() _createNotifier;

  /// @nodoc
  @internal
  @override
  NotifierT create() => _createNotifier();
}
