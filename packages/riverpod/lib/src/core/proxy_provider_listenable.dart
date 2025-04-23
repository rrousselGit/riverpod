part of '../framework.dart';

@internal
@publicInCodegen
class $LazyProxyListenable<OutT, OriginT>
    with ProviderListenable<OutT>, ProviderListenableWithOrigin<OutT, OriginT> {
  $LazyProxyListenable(this.provider, this._lense);

  final ProviderBase<OriginT> provider;
  final $ElementLense<OutT> Function(
    ProviderElement<OriginT> element,
  ) _lense;

  @override
  ProviderSubscriptionWithOrigin<OutT, OriginT> _addListener(
    Node source,
    void Function(OutT? previous, OutT next) listener, {
    required void Function(Object error, StackTrace stackTrace)? onError,
    required void Function()? onDependencyMayHaveChanged,
    required bool fireImmediately,
    required bool weak,
  }) {
    final element = source.readProviderElement(provider);

    final listenable = _lense(element);
    if (fireImmediately) {
      switch (listenable.result) {
        case null:
          break;
        case final $ResultData<OutT> data:
          runBinaryGuarded(listener, null, data.value);
        case final $ResultError<OutT> error:
          if (onError != null) {
            runBinaryGuarded(onError, error.error, error.stackTrace);
          }
      }
    }

    late final ProviderSubscriptionImpl<OutT, OriginT> sub;
    final removeListener = listenable.addListener(
      (a, b) => sub._notifyData(a, b),
      onError: onError,
      onDependencyMayHaveChanged: onDependencyMayHaveChanged,
    );

    return sub = DelegatingProviderSubscription<OutT, OriginT, OriginT>(
      listenedElement: element,
      source: source,
      weak: weak,
      origin: provider,
      onClose: removeListener,
      errorListener: onError,
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
class ProviderElementProxy<OutT, OriginT>
    with
        ProviderListenable<OutT>,
        ProviderListenableWithOrigin<OutT, OriginT>,
        _ProviderRefreshable<OutT, OriginT> {
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
  final ProviderBase<OriginT> provider;
  final $ElementLense<OutT> Function(
    ProviderElement<OriginT> element,
  ) _lense;

  @override
  ProviderSubscriptionWithOrigin<OutT, OriginT> _addListener(
    Node source,
    void Function(OutT? previous, OutT next) listener, {
    required void Function(Object error, StackTrace stackTrace)? onError,
    required void Function()? onDependencyMayHaveChanged,
    required bool fireImmediately,
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
        case final $ResultData<OutT> data:
          runBinaryGuarded(listener, null, data.value);
        case final $ResultError<OutT> error:
          if (onError != null) {
            runBinaryGuarded(onError, error.error, error.stackTrace);
          }
      }
    }

    late ProviderSubscriptionView<OutT, OriginT> sub;
    final removeListener = notifier.addListener(
      (prev, next) => sub._notifyData(prev, next),
      onError: onError,
      onDependencyMayHaveChanged: onDependencyMayHaveChanged,
    );

    return sub = ProviderSubscriptionView<OutT, OriginT>(
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
      other is ProviderElementProxy<OutT, OriginT> &&
      other.provider == provider;

  @override
  int get hashCode => provider.hashCode;
}
