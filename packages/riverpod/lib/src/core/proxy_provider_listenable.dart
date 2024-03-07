part of '../framework.dart';

class _ProxySubscription<StateT> extends ProviderSubscription<StateT> {
  _ProxySubscription(
    this._removeListeners,
    this._read, {
    required this.innerSubscription,
  });

  final ProviderSubscription<Object?> innerSubscription;
  final void Function() _removeListeners;
  final StateT Function() _read;

  @override
  void close() {
    innerSubscription.close();
    _removeListeners();
  }

  @override
  StateT read() => _read();
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
class ProviderElementProxy<InputT, OutputT>
    with ProviderListenable<OutputT>, _ProviderRefreshable<OutputT> {
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
  final ProviderBase<InputT> provider;
  final ProxyElementValueListenable<OutputT> Function(
    ProviderElementBase<InputT> element,
  ) _lense;

  @override
  ProviderSubscription<OutputT> addListener(
    Node node,
    void Function(OutputT? previous, OutputT next) listener, {
    required void Function(Object error, StackTrace stackTrace)? onError,
    required void Function()? onDependencyMayHaveChanged,
    required bool fireImmediately,
  }) {
    final element = node.readProviderElement(provider);

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
      innerSubscription: node._listenElement<InputT>(
        element,
        listener: (prev, next) {},
        onError: (err, stack) {},
      ),
    );
  }

  @override
  OutputT read(Node node) {
    final element = node.readProviderElement(provider);
    element.flush();
    element._mayNeedDispose();

    return _lense(element).value;
  }

  @override
  bool operator ==(Object other) =>
      other is ProviderElementProxy<InputT, OutputT> &&
      other.provider == provider;

  @override
  int get hashCode => provider.hashCode;
}
