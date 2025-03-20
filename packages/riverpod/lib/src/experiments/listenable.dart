part of '../framework.dart';

mixin ProviderListenableTransformer<T> implements ProviderListenable<T> {
  @override
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

    final result = Result.guard(() => transform(_transformer));

    _transformer._state = result;

    if (fireImmediately) {
      switch (result) {
        case ResultData<T>():
          listener(null, result.value);
        case ResultError<T>():
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
  T read() => _transformer.state!.requireState;
}

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
  Result<T>? get state => _state;
  Result<T>? _state;
  final _onClose = <void Function()>[];

  void setState(Result<T> newState) {
    switch (newState) {
      case ResultData<T>():
        _listener?.call(state?.value, newState.value);
        _state = newState;

      case ResultError<T>():
        _onError?.call(newState.error, newState.stackTrace);
        _state = newState;
    }
  }

  ProviderSubscription<T> listen<T>(
    ProviderListenable<T> listenable,
    void Function(T? previous, T next) listener, {
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
