part of '../framework.dart';

final class _ProxySubscription<OutT, StateT>
    extends DelegatingProviderSubscription<OutT, StateT> {
  _ProxySubscription(
    this.innerSubscription,
    this._removeListeners,
    this._read,
  );

  @override
  final ProviderSubscriptionWithOrigin<Object?, StateT> innerSubscription;

  final void Function() _removeListeners;
  final OutT Function() _read;

  @override
  OutT read() {
    if (closed) {
      throw StateError(
        'called ProviderSubscription.read on a subscription that was closed',
      );
    }
    return _read();
  }

  @override
  void close() {
    if (closed) return;

    _removeListeners();
    super.close();
  }
}

/// An internal utility for reading alternate values of a provider.
///
/// For example, this is used by [FutureProvider] to differentiate:
///
/// ```dart
/// ref.watch(futureProvider);
/// ```
///
/// from:
///
/// ```dart
/// ref.watch(futureProvider.future);
/// ```
///
/// This API is not meant for public consumption.
@internal
class ProviderElementProxy<StateT, OutT>
    with ProviderListenable<OutT>, _ProviderRefreshable<OutT> {
  /// An internal utility for reading alternate values of a provider.
  ///
  /// For example, this is used by [FutureProvider] to differentiate:
  ///
  /// ```dart
  /// ref.watch(futureProvider);
  /// ```
  ///
  /// from:
  ///
  /// ```dart
  /// ref.watch(futureProvider.future);
  /// ```
  ///
  /// This API is not meant for public consumption.
  const ProviderElementProxy(this.provider, this._lense);

  @override
  final ProviderBase<StateT> provider;
  final ProxyElementValueListenable<OutT> Function(
    ProviderElement<StateT> element,
  ) _lense;

  @override
  ProviderSubscriptionWithOrigin<OutT, StateT> addListener(
    Node source,
    void Function(OutT? previous, OutT next) listener, {
    required void Function(Object error, StackTrace stackTrace)? onError,
    required void Function()? onDependencyMayHaveChanged,
    required bool fireImmediately,
    required bool weak,
  }) {
    final element = source.readProviderElement(provider);

    ; // TODO test weak proxy listener does not break what's said after this.
    // While we don't care about changes to the element, calling _listenElement
    // is necessary to tell the listened element that it is being listened.
    // We do it at the top of the file to trigger a "flush" before adding
    // a listener to the notifier.
    // This avoids the listener from being immediately notified of a new
    // future when adding the listener refreshes the future.
    final innerSub = provider.addListener(
      source,
      (prev, next) {},
      fireImmediately: false,
      weak: weak,
      onDependencyMayHaveChanged: onDependencyMayHaveChanged,
      onError: null,
    );

    final notifier = _lense(element);
    if (fireImmediately) {
      switch (notifier.result) {
        case null:
          break;
        case final ResultData<OutT> data:
          runBinaryGuarded(listener, null, data.state);
        case final ResultError<OutT> error:
          if (onError != null) {
            runBinaryGuarded(onError, error.error, error.stackTrace);
          }
      }
    }

    final removeListener = notifier.addListener(
      listener,
      onError: onError,
      onDependencyMayHaveChanged: onDependencyMayHaveChanged,
    );

    return _ProxySubscription<OutT, StateT>(
      innerSub,
      removeListener,
      () => read(source),
    );
  }

  @override
  OutT read(Node node) {
    final element = node.readProviderElement(provider);
    element.flush();
    element.mayNeedDispose();

    return _lense(element).value;
  }

  @override
  bool operator ==(Object other) =>
      other is ProviderElementProxy<StateT, OutT> && other.provider == provider;

  @override
  int get hashCode => provider.hashCode;
}
