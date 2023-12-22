part of '../framework.dart';

/// Represents the subscription to a [ProviderListenable]
abstract class ProviderSubscription<State> {
  /// Stops listening to the provider
  @mustCallSuper
  void close();

  /// Obtain the latest value emitted by the provider
  State read();
}

/// When a provider listens to another provider using `listen`
class _ProviderListener<State> implements ProviderSubscription<State> {
  _ProviderListener._({
    required this.listenedElement,
    required this.dependentElement,
    required this.listener,
    required this.onError,
  });

// TODO can't we type it properly?
  final void Function(Object? prev, Object? state) listener;
  final ProviderElementBase<Object?> dependentElement;
  final ProviderElementBase<State> listenedElement;
  final OnError onError;

  @override
  void close() {
    dependentElement._listenedProviderSubscriptions.remove(this);
    listenedElement
      .._subscribers.remove(this)
      .._onRemoveListener();
  }

  @override
  State read() => listenedElement.readSelf();
}
