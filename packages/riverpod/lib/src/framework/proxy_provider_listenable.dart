part of '../framework.dart';

class _ProxySubscription<T> extends ProviderSubscription<T> {
  _ProxySubscription(
    super.source,
    this._removeListeners,
    this._read, {
    required this.innerSubscription,
  });

  final ProviderSubscription<Object?> innerSubscription;
  final RemoveListener _removeListeners;
  final T Function() _read;

  @override
  T read() {
    if (_closed) {
      throw StateError(
        'called ProviderSubscription.read on a subscription that was closed',
      );
    }
    return _read();
  }

  @override
  void close() {
    if (!closed) {
      innerSubscription.close();
      _removeListeners();
    }

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
class ProviderElementProxy<Input, Output>
    with
        ProviderListenable<Output>,
        // ignore: deprecated_member_use_from_same_package
        AlwaysAliveProviderListenable<Output>
    implements
        // ignore: deprecated_member_use_from_same_package
        AlwaysAliveRefreshable<Output> {
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
  const ProviderElementProxy(this._origin, this._lense);

  @override
  final ProviderBase<Input> _origin;
  final ProxyElementValueNotifier<Output> Function(
    ProviderElementBase<Input> element,
  ) _lense;

  @override
  ProviderSubscription<Output> addListener(
    Node node,
    void Function(Output? previous, Output next) listener, {
    required void Function(Object error, StackTrace stackTrace)? onError,
    required void Function()? onDependencyMayHaveChanged,
    required bool fireImmediately,
  }) {
    final element = node.readProviderElement(_origin);

    // While we don't care about changes to the element, calling _listenElement
    // is necessary to tell the listened element that it is being listened.
    // We do it at the top of the file to trigger a "flush" before adding
    // a listener to the notifier.
    // This avoids the listener from being immediately notified of a new
    // future when adding the listener refreshes the future.
    final innerSub = node.listen<Object?>(
      _origin,
      (prev, next) {},
    );

    final notifier = _lense(element);
    if (fireImmediately) {
      notifier.result?.when(
        data: (data) {
          runBinaryGuarded(listener, null, data);
        },
        error: (err, stack) {
          if (onError != null) {
            runBinaryGuarded(onError, err, stack);
          }
        },
      );
    }

    final removeListener = notifier.addListener(
      listener,
      onError: onError,
      onDependencyMayHaveChanged: onDependencyMayHaveChanged,
    );

    return _ProxySubscription(
      node,
      removeListener,
      () => read(node),
      innerSubscription: innerSub,
    );
  }

  @override
  Output read(Node node) {
    final element = node.readProviderElement(_origin);
    element.flush();
    element.mayNeedDispose();
    return _lense(element).value;
  }

  @override
  bool operator ==(Object other) =>
      other is ProviderElementProxy<Input, Output> && other._origin == _origin;

  @override
  int get hashCode => _origin.hashCode;
}
