part of '../framework.dart';

abstract class CustomProviderListenable<InT, ValueT>
    implements ProviderListenable<ValueT> {
  /// The source of this transformer.
  ///
  /// This is the provider that this transformer listens to.
  @visibleForOverriding
  ProviderListenable<InT> get source;

  ProviderTransformer2<InT, ValueT, CustomProviderListenable<InT, ValueT>>
  createTransformer();

  @override
  ProviderSubscriptionImpl<ValueT> _addListener(
    Node node,
    void Function(ValueT? previous, ValueT next) listener, {
    required void Function(Object error, StackTrace stackTrace) onError,
    required void Function()? onDependencyMayHaveChanged,
    required bool weak,
  }) {
    final transformer =
        createTransformer()
          .._source = source
          .._listenable = this;

    return transformer._listenSource(
      node,
      weak: weak,
      onDependencyMayHaveChanged: onDependencyMayHaveChanged,
      listener: listener,
      onError: onError,
    );
  }
}

/// {@template provider_transformer}
/// The logic responsible for transforming a [ProviderListenable] into another
/// [ProviderListenable].
///
/// It is both:
/// - the object that hols the current state of the transformation
/// - a description of how to react to various life-cycles
///   related to the listened object.
/// {@endtemplate}
@publicInMisc
abstract base class ProviderTransformer2<
  InT,
  ValueT,
  ListenableT extends CustomProviderListenable<InT, ValueT>
> {
  final _pauser = _OnPauseMixin();

  late ProviderListenable<InT> _source;
  void Function(AsyncResult<ValueT> next)? _notify;

  ListenableT? _listenable;
  ListenableT get listenable {
    if (_listenable case final listenable?) return listenable;

    throw StateError('Cannot call listenable from a constructor.');
  }

  late AsyncResult<ValueT> _state;

  /// The currently exposed state of this transformer.
  ///
  /// When using [SyncProviderTransformerMixin2], will rethrow the error if any.
  AsyncResult<ValueT> get state => _state;
  set state(AsyncResult<ValueT> value) {
    _state = value;
    _notify?.call(value);
  }

  AsyncResult<InT>? _sourceState;
  void _setSourceState(AsyncResult<InT> state) {
    _sourceState = state;
  }

  AsyncResult<InT> get sourceState {
    if (_sourceState case final sourceState?) return sourceState;

    throw StateError('Cannot call sourceState from a constructor.');
  }

  ExternalProviderSubscription<InT, ValueT>? _outerSub;

  @mustCallSuper
  void pause() {
    if (!_pauser._isPaused) {
      _pauser.pause();
      // Using deactivate so that internal pause/resume are not impacted by external pause/resume
      _outerSub?.deactivate();
    }
  }

  @mustCallSuper
  void resume() {
    final wasPaused = _pauser._isPaused;
    _pauser.resume();

    if (wasPaused && !_pauser._isPaused) {
      _outerSub?.reactivate();
    }
  }

  ExternalProviderSubscription<InT, ValueT> _listenSource(
    Node node, {
    required bool weak,
    required void Function()? onDependencyMayHaveChanged,
    required void Function(ValueT? previous, ValueT next) listener,
    required void Function(Object error, StackTrace stackTrace) onError,
  }) {
    final innerSub = _source._addListener(
      node,
      (previous, next) => _setSourceState(AsyncData(next)),
      onError:
          (err, stackTrace) => _setSourceState(AsyncError(err, stackTrace)),
      onDependencyMayHaveChanged: onDependencyMayHaveChanged,
      weak: weak,
    );

    final resultSub = ExternalProviderSubscription.fromSub(
      innerSubscription: innerSub,
      listener: listener,
      onError: onError,
      onClose: () => node.container.runGuarded(onClose),
      read: () => _read(_flush()),
    );

    // 'weak' is lazy loaded, but weak:false isn't.
    if (!weak) resultSub.read();

    return resultSub;
  }

  AsyncResult<ValueT> _flush() => throw UnimplementedError();

  $Result<ValueT> _read(AsyncResult<ValueT> asyncResult);

  void initState() {}

  @mustCallSuper
  void didUpdateListenable(CustomProviderListenable<InT, ValueT> listenable) {}

  void onClose() {}

  void onData(
    ProviderTransformer2<InT, ValueT, ListenableT> self,
    AsyncResult<InT> prev,
    AsyncResult<InT> next,
  ) {}
}

@publicInMisc
abstract base class SyncProviderTransformer2<
  InT,
  ValueT,
  ListenableT extends CustomProviderListenable<InT, ValueT>
>
    extends ProviderTransformer2<InT, ValueT, ListenableT> {
  @override
  $Result<ValueT> _read(AsyncResult<ValueT> asyncResult) {
    switch (asyncResult) {
      case AsyncData(:final value):
        return $ResultData(value);
      case AsyncError():
        return $ResultError(asyncResult.error, asyncResult.stackTrace);
    }
  }
}
