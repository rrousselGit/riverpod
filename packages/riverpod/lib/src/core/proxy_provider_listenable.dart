part of '../framework.dart';

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
  final AnyProvider<Input> _origin;
  final ProxyElementValueNotifier<Output> Function(
    ProviderElementBase<Input> element,
  ) _lense;

  @override
  ProviderSubscription<Output> _addListener(
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
      switch (notifier.result) {
        case null:
          break;

        case ResultData<Output>(:final value):
          runBinaryGuarded(listener, null, value);

        case ResultError<Output>(:final error, :final stackTrace):
          if (onError != null) {
            runBinaryGuarded(onError, error, stackTrace);
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

/// Deals with the internals of synchronously calling the listeners
/// when using `fireImmediately: true`
void _handleFireImmediately<StateT>(
  Result<StateT> currentState, {
  required void Function(StateT? previous, StateT current) listener,
  required void Function(Object error, StackTrace stackTrace) onError,
}) {
  switch (currentState) {
    case ResultData():
      runBinaryGuarded(listener, null, currentState.value);
    case ResultError():
      runBinaryGuarded(onError, currentState.error, currentState.stackTrace);
  }
}
