part of '../framework.dart';

/// {@template ProviderListenableTransformer}
/// A mixin for making custom [ProviderListenable]s.
///
/// **Note**:
/// Consider overriding [==]/[hashCode] if it makes sense for your listenable.
/// If `provider.myListenable == provider.myListenable` is `true`, then
/// Riverpod will be able to optimize subscriptions when a provider/widget rebuilds.
///
/// ## Usage: A custom `when` Listenable
///
/// The following implements a `when` listenable as an alternative to `select`:
///
/// ```dart
/// class When<T> with ProviderListenableMixin<T> {
///   When(this.provider, this.when);
///   final ProviderListenable<T> provider;
///   final bool Function(T a, T b) when;
///
///   @override
///   int transform(transformer) {
///     // Listen to the provider and filter updates based on `when`
///     final sub = transformer.listen(provider, (previous, value) {
///       if (previous is! T || when(previous, value)) {
///         transformer.setData(value);
///       }
///     });
///
///     return sub.read(); // Return initial value;
///   }
/// }
///
/// extension<T> on ProviderListenable<T> {
///    When<T> when(bool Function(T a, T b) when) => When(this, when);
/// }
/// ```
///
/// Used as:
///
/// ```dart
/// ref.watch(myProvider.when((a, b) => a.value != b.value));
/// ```
/// {@endtemplate}
mixin ProviderListenableTransformer<T> implements ProviderListenable<T> {
  static ProviderSubscription<T> _transform<T>(
    Node node,
    void Function(T? previous, T next) listener, {
    required T Function(ProviderTransformer<T> transformer) transform,
    required void Function(Object error, StackTrace stackTrace)? onError,
    required void Function()? onDependencyMayHaveChanged,
    required bool fireImmediately,
  }) {
    final _transformer = ProviderTransformer<T>._(
      node,
      listener,
      onError,
      onDependencyMayHaveChanged,
    );

    final result = $Result.guard(() => transform(_transformer));

    _transformer._state = result;

    if (fireImmediately) {
      switch (result) {
        case $ResultData<T>():
          listener(null, result.value);
        case $ResultError<T>():
          onError?.call(result.error, result.stackTrace);
      }
    }

    return _TransformerSubscription(_transformer, node);
  }

  @override
  ProviderSubscription<T> _addListener(
    Node node,
    void Function(T? previous, T next) listener, {
    required void Function(Object error, StackTrace stackTrace)? onError,
    required void Function()? onDependencyMayHaveChanged,
    required bool fireImmediately,
  }) {
    return _transform(
      node,
      listener,
      transform: transform,
      onError: onError,
      onDependencyMayHaveChanged: onDependencyMayHaveChanged,
      fireImmediately: fireImmediately,
    );
  }

  @override
  @Deprecated('Use ProviderListenableTransformer')
  ProviderSubscription<T> addListener(
    Node node,
    void Function(T? previous, T next) listener, {
    required void Function(Object error, StackTrace stackTrace)? onError,
    required void Function()? onDependencyMayHaveChanged,
    required bool fireImmediately,
  }) {
    return _addListener(
      node,
      listener,
      onError: onError,
      onDependencyMayHaveChanged: onDependencyMayHaveChanged,
      fireImmediately: fireImmediately,
    );
  }

  /// {@macro ProviderListenableTransformer}
  T transform(ProviderTransformer<T> transformer);
}

class _TransformerSubscription<T> extends ProviderSubscription<T> {
  _TransformerSubscription(this._transformer, super.source);

  final ProviderTransformer<T> _transformer;

  @override
  void close() {
    if (_closed) return;

    super.close();
    for (var i = 0; i < _transformer._onClose.length; i++) {
      final onClose = _transformer._onClose[i];
      onClose();
    }
  }

  @override
  T read() => _transformer._state!.requireState;
}

/// An object created using [ProviderListenableTransformer], for transforming
/// the state of a provider.
final class ProviderTransformer<T> {
  ProviderTransformer._(
    this._node,
    this._listener,
    this._onError,
    this._onDependencyMayHaveChanged,
  );

  final Node _node;
  final void Function(T? previous, T next)? _listener;
  final void Function(Object error, StackTrace stackTrace)? _onError;
  final void Function()? _onDependencyMayHaveChanged;

  /// The currently exposed state.
  ///
  /// Will be null if:
  /// - No state has been set yet
  /// - The state is in error state
  T? get state => _state?.value;

  /// The current error, if any.
  Object? get error => _state?.error;

  /// The stacktrace for the current error, if any.
  StackTrace? get stackTrace => _state?.stackTrace;
  $Result<T>? _state;

  final _onClose = <void Function()>[];

  /// Updates [state].
  ///
  /// Calling this will notify listeners of the new state, and set [error]/[stackTrace]
  /// to null.
  void setData(T newState) {
    _listener?.call(state, newState);
    _state = $ResultData(newState);
  }

  /// Sets the listenable in error state.
  ///
  /// Calling this will notify the `onError` of listeners, and set [state] to null.
  void setError(Object error, StackTrace stackTrace) {
    _onError?.call(error, stackTrace);
    _state = $ResultError(error, stackTrace);
  }

  /// Listens to another [ProviderListenable].
  ///
  /// The returned subscription is automatically closed.
  ProviderSubscription<InT> listen<InT>(
    ProviderListenable<InT> listenable,
    void Function(InT? previous, InT next) listener, {
    required void Function(Object error, StackTrace stackTrace) onError,
  }) {
    final sub = listenable._addListener(
      _node,
      listener,
      onError: onError,
      onDependencyMayHaveChanged: _onDependencyMayHaveChanged,
      fireImmediately: false,
    );

    _onClose.add(sub.close);

    return sub;
  }
}
