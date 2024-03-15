part of '../framework.dart';

final class _ProxySubscription<StateT> extends ProviderSubscription<StateT> {
  _ProxySubscription(
    super.source,
    this._removeListeners,
    this._read, {
    required this.innerSubscription,
  });

  final ProviderSubscription<Object?> innerSubscription;
  final void Function() _removeListeners;
  final StateT Function() _read;

  @override
  StateT read() {
    if (closed) {
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
    ProviderElement<InputT> element,
  ) _lense;

  @override
  ProviderSubscription<OutputT> addListener(
    Node node,
    void Function(OutputT? previous, OutputT next) listener, {
    required void Function(Object error, StackTrace stackTrace)? onError,
    required void Function()? onDependencyMayHaveChanged,
    required bool fireImmediately,
    required bool weak,
  }) {
    final element = node.readProviderElement(provider);

    // While we don't care about changes to the element, calling _listenElement
    // is necessary to tell the listened element that it is being listened.
    // We do it at the top of the file to trigger a "flush" before adding
    // a listener to the notifier.
    // This avoids the listener from being immediately notified of a new
    // future when adding the listener refreshes the future.
    final innerSub = node.listen<Object?>(
      provider,
      (prev, next) {},
      weak: weak,
      fireImmediately: false,
      onError: null,
    );

    final notifier = _lense(element);
    if (fireImmediately) {
      switch (notifier.result) {
        case null:
          break;
        case final ResultData<OutputT> data:
          runBinaryGuarded(listener, null, data.state);
        case final ResultError<OutputT> error:
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

    return _ProxySubscription(
      node,
      removeListener,
      () => read(node),
      innerSubscription: innerSub,
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
