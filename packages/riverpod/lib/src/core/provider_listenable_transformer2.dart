part of '../framework.dart';

/// A [ProviderListenable] whose value is derived from transforming another
/// [ProviderListenable] ([source]).
///
/// This is the base class for implementing custom variants of methods such
/// as [ProviderListenableSelect.select].
///
/// ## Usage
///
/// To use this class, you must implement the [source]. getter (the provider
/// that is being transformed) and [createTransformer] (the object responsible
/// for computing/holding the transformed state, see [ProviderTransformer2]).
///
/// The following example implements a variant of [ProviderListenableSelect.select],
/// where the callback returns a boolean instead of the selected value.
///
/// ```dart
/// final class Where<T> extends CustomProviderListenable<T, T> {
///   Where(this.source, this.where);
///
///   @override
///   final ProviderListenable<T> source;
///   final bool Function(T previous, T value) where;
///
///   @override
///   _WhereTransformer<T> createTransformer() => _WhereTransformer<T>();
/// }
///
/// final class _WhereTransformer<T>
///     extends SyncProviderTransformer2<T, T, Where<T>> {
///   @override
///   T initState() => sourceState.requireValue;
///
///   @override
///   void onEvent(
///     AsyncResult<T> prev,
///     AsyncResult<T> next,
///   ) {
///     if (listenable.where(prev.requireValue, next.requireValue)) {
///       state = next;
///     }
///   }
/// }
///
/// extension<T> on ProviderListenable<T> {
///   ProviderListenable<T> where(
///     bool Function(T previous, T value) where,
///   ) => Where<T>(this, where);
/// }
/// ```
///
/// Used as `ref.watch(provider.where((previous, value) => value > 0))`.
///
/// See also:
/// - [ProviderTransformer2], the object responsible for the transformation logic.
@publicInMisc
abstract class CustomProviderListenable<InT, ValueT>
    implements ProviderListenable<ValueT> {
  /// The source of this transformer.
  ///
  /// This is the provider that this transformer listens to.
  @visibleForOverriding
  ProviderListenable<InT> get source;

  /// Creates the [ProviderTransformer2] responsible for computing and
  /// holding the state of this [CustomProviderListenable].
  ///
  /// This is called once per subscription (every time [CustomProviderListenable.source]. gains a
  /// new listener).
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
          .._listenable = this
          .._node = node;

    return transformer._listenSource(
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

  /// The [CustomProviderListenable] that created this transformer.
  ///
  /// This offers a convenient way to access the properties of the
  /// [CustomProviderListenable] (such as a `select` callback) from within
  /// the transformer.
  ListenableT get listenable {
    if (_listenable case final listenable?) return listenable;

    throw StateError('Cannot call listenable from a constructor.');
  }

  late AsyncResult<ValueT> _state;

  /// The currently exposed state of this transformer.
  ///
  /// When using [SyncProviderTransformer2], will rethrow the error if any.
  AsyncResult<ValueT> get state => _state;
  set state(AsyncResult<ValueT> value) {
    _state = value;
    _notify?.call(value);
  }

  late Node _node;
  ProviderSubscription<InT>? _innerSub;
  ExternalProviderSubscription<InT, ValueT>? _outerSub;

  AsyncResult<InT>? _sourceState;
  void _setSourceState(AsyncResult<InT> next) {
    final prev = _sourceState;
    _sourceState = next;

    // Only forward to `onData` once the transformer was initialized and
    // has an actual previous state to compare against.
    if (_initialized && prev != null) {
      _node.container.runBinaryGuarded(onEvent, prev, next);
    }
  }

  /// The current state of [CustomProviderListenable.source].
  AsyncResult<InT> get sourceState {
    if (_sourceState case final sourceState?) return sourceState;

    throw StateError('Cannot call sourceState from a constructor.');
  }

  /// Reads the latest value of [CustomProviderListenable.source]., bypassing the pause state.
  InT read() {
    if (_innerSub case final innerSub?) return innerSub.read();

    throw StateError('Cannot call read() from a constructor.');
  }

  /// Pauses the subscription to [CustomProviderListenable.source]., stopping it from being notified
  /// of any change until [resume] is called.
  @mustCallSuper
  void pause() {
    if (!_pauser._isPaused) {
      _pauser.pause();
      // Using deactivate so that internal pause/resume are not impacted by external pause/resume
      _outerSub?.deactivate();
    }
  }

  /// Resumes the subscription to [CustomProviderListenable.source]. after a call to [pause].
  @mustCallSuper
  void resume() {
    final wasPaused = _pauser._isPaused;
    _pauser.resume();

    if (wasPaused && !_pauser._isPaused) {
      _outerSub?.reactivate();
    }
  }

  ExternalProviderSubscription<InT, ValueT> _listenSource({
    required bool weak,
    required void Function()? onDependencyMayHaveChanged,
    required void Function(ValueT? previous, ValueT next) listener,
    required void Function(Object error, StackTrace stackTrace) onError,
  }) {
    final innerSub =
        _innerSub = _source._addListener(
          _node,
          (previous, next) => _setSourceState(AsyncData(next)),
          onError:
              (err, stackTrace) => _setSourceState(AsyncError(err, stackTrace)),
          onDependencyMayHaveChanged: onDependencyMayHaveChanged,
          weak: weak,
        );

    ExternalProviderSubscription<InT, ValueT>? outerSub;
    $Result<ValueT>? currentRead;

    _notify = (next) {
      final prevResult = currentRead ??= _read(_flush());
      final nextResult = _read(next);
      currentRead = nextResult;

      final sub = outerSub;
      if (sub == null) return;

      switch (nextResult) {
        case $ResultData(:final value):
          sub._notifyData(prevResult.value, value);
        case $ResultError(:final error, :final stackTrace):
          sub._notifyError(error, stackTrace);
      }
    };

    outerSub =
        _outerSub = ExternalProviderSubscription.fromSub(
          innerSubscription: innerSub,
          listener: listener,
          onError: onError,
          onClose: () => _node.container.runGuarded(onClose),
          read: () => currentRead = _read(_flush()),
        );
    // Pause was called before the subscription was created, so we need to pause it now.
    // Otherwise even though pause was called, the source provider would still be active and listening to its dependencies.
    if (_pauser._isPaused) outerSub.pause();

    // 'weak' is lazy loaded, but weak:false isn't.
    if (!weak) outerSub.read();

    return outerSub;
  }

  var _initialized = false;

  AsyncResult<ValueT> _flush() {
    if (!_initialized) {
      _initialized = true;

      try {
        _sourceState = switch (_innerSub!.readSafe()) {
          $ResultData(:final value) => AsyncData(value),
          $ResultError(:final error, :final stackTrace) => AsyncError(
            error,
            stackTrace,
          ),
        };
        _state = AsyncData(initState());
      } catch (error, stackTrace) {
        _state = AsyncError(error, stackTrace);
      }
    }

    return _state;
  }

  $Result<ValueT> _read(AsyncResult<ValueT> asyncResult);

  /// Initializes the state of this transformer.
  ///
  /// This is called lazily, the first time the state of this transformer
  /// is read, and its return value is used as the initial [state].
  ValueT initState();

  /// A life-cycle method invoked when [CustomProviderListenable.source]. changes after the initial
  /// event.
  ///
  /// It will _not_ be called with the initial value.
  ///
  /// - `self` represents the `this` object of the [ProviderTransformer2].
  ///   It offers a convenient way to call [ProviderTransformer2.state].
  void onEvent(AsyncResult<InT> prev, AsyncResult<InT> next) {}

  /// A life-cycle method for when the [ProviderSubscription] obtained from
  /// [CustomProviderListenable] is closed.
  ///
  /// This callback will only be called once regardless of how many times
  /// [ProviderSubscription.close] is called.
  void onClose() {}
}

/// A variant of [ProviderTransformer2] for [CustomProviderListenable]s that
/// do not emit [AsyncValue].
///
/// If in error state, an exception will happen when trying to read the state
/// of the associated [CustomProviderListenable].
///
/// See [CustomProviderListenable] for a usage example.
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
