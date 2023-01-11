part of '../framework.dart';

class _ProxySubscription<T> extends ProviderSubscription<T> {
  _ProxySubscription(
    this._removeListeners,
    this._read, {
    required this.innerSubscription,
  });

  final ProviderSubscription<Object?> innerSubscription;
  final RemoveListener _removeListeners;
  final T Function() _read;

  @override
  void close() {
    innerSubscription.close();
    _removeListeners();
  }

  @override
  T read() => _read();
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
    with ProviderListenable<Output>, AlwaysAliveProviderListenable<Output>
    implements AlwaysAliveRefreshable<Output> {
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

    // TODO does this need a "flush"?
    // element.flush();

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
      removeListener,
      () => read(node),
      // While we don't care about changes to the element, calling _listenElement
      // is necessary to tell the listened element that it is being listened.
      innerSubscription: node._listenElement<Input>(
        element,
        listener: (prev, next) {},
        onError: (err, stack) {},
      ),
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
