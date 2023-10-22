part of 'async_notifier.dart';

ProviderElementProxy<AsyncValue<T>, NotifierT>
    _streamNotifier<NotifierT extends AsyncNotifierBase<T>, T>(
  StreamNotifierProviderBase<NotifierT, T> that,
) {
  return ProviderElementProxy<AsyncValue<T>, NotifierT>(
    that,
    (element) {
      return (element as StreamNotifierProviderElement<NotifierT, T>)
          ._notifierNotifier;
    },
  );
}

ProviderElementProxy<AsyncValue<T>, Future<T>> _streamFuture<T>(
  StreamNotifierProviderBase<AsyncNotifierBase<T>, T> that,
) {
  return ProviderElementProxy<AsyncValue<T>, Future<T>>(
    that,
    (element) {
      return (element as StreamNotifierProviderElement<AsyncNotifierBase<T>, T>)
          .futureNotifier;
    },
  );
}

/// A base class for [StreamNotifierProvider]
///
/// Not meant for public consumption
@visibleForTesting
@internal
abstract class StreamNotifierProviderBase<
    NotifierT extends AsyncNotifierBase<T>,
    T> extends ProviderBase<AsyncValue<T>> {
  /// A base class for [StreamNotifierProvider]
  ///
  /// Not meant for public consumption
  const StreamNotifierProviderBase(
    this._createNotifier, {
    required super.name,
    required super.from,
    required super.argument,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
  });

  /// Obtains the [StreamNotifier] associated with this provider, without listening
  /// to state changes.
  ///
  /// This is typically used to invoke methods on a [StreamNotifier]. For example:
  ///
  /// ```dart
  /// Button(
  ///   onTap: () => ref.read(streamNotifierProvider.notifier).increment(),
  /// )
  /// ```
  ///
  /// This listenable will notify its notifiers if the [StreamNotifier] instance
  /// changes.
  /// This may happen if the provider is refreshed or one of its dependencies
  /// has changes.
  Refreshable<NotifierT> get notifier;

  /// {@macro riverpod.async_notifier.future}
  ///
  /// Listening to this using [Ref.watch] will rebuild the widget/provider
  /// when the [StreamNotifier] emits a new value.
  /// This will then return a new [Future] that resoles with the latest "state".
  Refreshable<Future<T>> get future;

  final NotifierT Function() _createNotifier;

  /// Runs the `build` method of a notifier.
  ///
  /// This is an implementation detail for differentiating [StreamNotifier.build]
  /// from [FamilyStreamNotifier.build].
  Stream<T> runNotifierBuild(AsyncNotifierBase<T> notifier);
}
