part of '../framework.dart';

@internal
@publicInCodegen
final class $LazyProxyListenable<OutT, OriginStateT>
    implements ProviderListenable<OutT> {
  $LazyProxyListenable(this.provider, this._lense);

  final $ProviderBaseImpl<OriginStateT> provider;
  final $Observable<OutT> Function(
    ProviderElement<OriginStateT, Object?> element,
  ) _lense;

  @override
  ProviderSubscriptionImpl<OutT> _addListener(
    Node source,
    void Function(OutT? previous, OutT next) listener, {
    required void Function(Object error, StackTrace stackTrace) onError,
    required void Function()? onDependencyMayHaveChanged,
    required bool weak,
  }) {
    final element = source.readProviderElement(provider);

    final innerSub = source.container.listen(provider, (a, b) {});

    final listenable = _lense(element);

    late final ProviderSubscriptionImpl<OutT> sub;
    final removeListener = listenable.addListener(
      (a, b) => sub._notifyData(a, b),
      onError: onError,
      onDependencyMayHaveChanged: onDependencyMayHaveChanged,
    );

    return sub = ExternalProviderSubscription<OriginStateT, OutT>(
      innerSubscription: innerSub,
      onClose: removeListener,
      onError: onError,
      listener: listener,
      read: () => listenable.value,
    );
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
final class ProviderElementProxy<OutT, OriginStateT>
    with _ProviderRefreshable<OutT, OriginStateT> {
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
  const ProviderElementProxy(
    this.provider,
    this._lense, {
    this.flushElement = false,
  });

  final bool flushElement;

  @override
  final $ProviderBaseImpl<OriginStateT> provider;
  final $Observable<OutT> Function(
    ProviderElement<OriginStateT, Object?> element,
  ) _lense;

  @override
  ProviderSubscriptionImpl<OutT> _addListener(
    Node source,
    void Function(OutT? previous, OutT next) listener, {
    required void Function(Object error, StackTrace stackTrace) onError,
    required void Function()? onDependencyMayHaveChanged,
    required bool weak,
  }) {
    final element = source.readProviderElement(provider);

    // While we don't care about changes to the element, calling addListener
    // is necessary to tell the listened element that it is being listened.
    // We do it at the top of the file to trigger a "flush" before adding
    // a listener to the notifier.
    // This avoids the listener from being immediately notified of a new
    // future when adding the listener refreshes the future.
    final innerSub = provider._addListener(
      source,
      (prev, next) {},
      weak: weak,
      onDependencyMayHaveChanged: onDependencyMayHaveChanged,
      onError: (err, stack) {},
    );

    final notifier = _lense(element);

    late ExternalProviderSubscription<OriginStateT, OutT> sub;
    final removeListener = notifier.addListener(
      (prev, next) => sub._notifyData(prev, next),
      onError: onError,
      onDependencyMayHaveChanged: onDependencyMayHaveChanged,
    );

    return sub = ExternalProviderSubscription<OriginStateT, OutT>(
      innerSubscription: innerSub,
      onClose: removeListener,
      listener: listener,
      onError: onError,
      read: () {
        final element = source.readProviderElement(provider);
        element.flush();
        element.mayNeedDispose();

        return _lense(element).value;
      },
    );
  }

  @override
  bool operator ==(Object other) =>
      other is ProviderElementProxy<OutT, OriginStateT> &&
      other.provider == provider;

  @override
  int get hashCode => provider.hashCode;
}
