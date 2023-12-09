part of 'framework.dart';

enum _DirtyType {
  reload,
  refresh,
}

/// The element of a provider is a class responsible for managing the state
/// of a provider.
///
/// It is responsible for:
/// - Initializing the provider
/// - Recomputing the provider when requested (such as with [Ref.watch] or [Ref.invalidate])
/// - Disposing the state
abstract class ProviderElement<StateT> {
  ProviderElement(this.container);

  /// The provider associated with this [ProviderElement].
  Provider<Object?> get provider;

  /// The container where this [ProviderElement] is attached to.
  final ProviderContainer container;

  /// Whether this provider is currently paused.
  ///
  /// A provider is paused when if:
  /// - It has no listeners
  /// - All of its listeners are paused
  /// - The provider was manually using [pause].
  bool get paused =>
      _subscriptions.isEmpty || _pauseCount > 0 || _pausedListenerCount > 0;

  bool get disposed => _disposed;
  bool _disposed = false;

  _DirtyType? _dirty;

  /// What this provider is currently listening to.
  List<ProviderSubscription<Object?>> _subscriptions = [];

  /// The listeners listening to this provider.
  List<ProviderSubscription<Object?>> _listeners = [];

  var _pauseCount = 0;
  var _pausedListenerCount = 0;

  // // The various life-cycles listeners of a provider.
  // // We store them in the element instead of Ref for performance reasons.
  // // This avoids having to create a new list for each Ref and is less DC intensive.
  // TODO
  // final _onDispose = VoidNotifier();
  // final _onAddListener = VoidNotifier();
  // final _onRemoveListener = VoidNotifier();
  // final _onResume = VoidNotifier();
  // final _onPause = VoidNotifier();

  Ref<StateT>? _ref;

  AsyncValue<StateT>? get result => _result;
  AsyncValue<StateT>? _result;

  int get depthApproximation => _depthApproximation;
  int _depthApproximation = 0;

  AsyncValue<StateT> requestState() {
    container._scheduler.scheduleBuildFor(this);

    final result = this.result;
    if (result != null) return result;

    throw StateError(
      'Cannot request state while the provider is not built',
    );
  }

  void _runProviderBuild() {
    assert(_dirty != null);

    _dirty = null;

    setLoading();
    final ref = _ref = Ref<StateT>._(this);

    List<ProviderSubscription<Object?>>? previousSubscriptions = _subscriptions;
    _subscriptions = [];

    void closePreviousSubscriptions() {
      for (final subscription in previousSubscriptions!) {
        subscription.close();
      }
      previousSubscriptions = null;
    }

    // Prevent listeners from being notified while we are building.
    // TODO assert(_lockNotifyListeners());

    final tenable = Tenable.fromFutureOr(() => build(ref));

    // Once "build" has completed, we fully close previous subscriptions.
    tenable.whenComplete(closePreviousSubscriptions);

    // If "build" completed synchronously, subscriptions should already be closed.
    // No need to pause them.
    // We pause subscriptions _after_ starting build, for the sake of efficiency.
    // This avoids both pausing and closing subscriptions in a quick succession.
    if (previousSubscriptions != null) {
      // Pause previous subscriptions to disable them while "build" is running.
      // This avoids unnecessary work in providers that may not be used anymore.
      for (final subscription in previousSubscriptions!) {
        subscription.pause();
      }
    }

    // TODO assert(_unlockNotifyListeners());
    assert(result != null);
    // We notify listeners after "build" has completed.
    // This avoids notifying listeners multiple times if multiple state change
    // operations are performed at once.
    // TODO _notifyListeners();
  }

  void setLoading() {
    // TODO
  }

  void setError(Object error, StackTrace stackTrace) {
    // TODO
  }

  void setData(StateT value) {
    // TODO
  }

  ProviderSubscription<ResultT> addListener<ResultT>(
    ProviderListener<ResultT> listener, {
    required bool fireImmediately,
    required OnError? onError,
    required ResultT Function(AsyncValue<StateT> value) convert,
    required DebugDependentSource? debugDependentSource,
    required ProviderElement<Object?>? dependent,
    required OnCancel? onCancel,
  }) {
    final subscription = _ProviderSubscription<ResultT, StateT>(
      this,
      listener,
      convert: convert,
      fireImmediately: fireImmediately,
      onError: onError,
      debugDependentSource: debugDependentSource,
      dependent: dependent,
      originalDependentSubscriptions: _subscriptions,
      onCancel: onCancel,
    );

    _listeners.add(subscription);

    if (dependent != null) {
      dependent._subscriptions.add(subscription);
    }

    return subscription;
  }

  /// Invoke the "create" method of a provider.
  ///
  /// Should not notify listeners during the synchronous execution of the build
  /// method.
  @visibleForOverriding
  FutureOr<void> build(Ref<StateT> ref);

  void pause() {
    if (_disposed) throw StateError('Cannot pause a disposed ProviderElement');

    _pauseCount++;
  }

  void resume() {
    if (_disposed) throw StateError('Cannot resume a disposed ProviderElement');

    // Noop if not paused.
    if (_pauseCount == 0) return;

    _pauseCount--;
  }

  void markNeedsRebuild({bool asReload = false}) {
    if (_dirty != null) {
      // If at least one rebuild request asks for a "reload", then we reload.
      // Otherwise we "refresh".
      if (asReload) _dirty = _DirtyType.reload;

      return;
    }

    _dirty = asReload ? _DirtyType.reload : _DirtyType.refresh;

    container._scheduler.scheduleBuildFor(this);
  }

  void _runDispose() {
    // By disposing the "ref" before invoking "onDispose",
    // then we ensure that "onDispose" cannot call "ref.state=" & co.
    _ref?._dispose();
    _ref = null;

    // TODO _onDispose
    //   ..notifyListeners()
    //   ..clear();
  }

  @mustCallSuper
  void unmount() {
    _runDispose();

    _disposed = true;

    // Clearing the subscriptions before closing them, for efficiency.
    // This avoids having to remove the subscriptions from the list.
    // Cf _ProviderSubscription._originalDependentSubscriptions.
    final subscriptions = _subscriptions;
    final listeners = _listeners;
    _listeners = [];
    _subscriptions = [];

    for (final subscription in subscriptions) {
      subscription.close();
    }
    for (final listener in listeners) {
      listener.close();
    }

    _ref = null;
    _result = null;
  }
}

class _ProviderSubscription<ResultT, StateT>
    implements ProviderSubscription<ResultT> {
  _ProviderSubscription(
    this._element,
    this._listener, {
    required ResultT Function(AsyncValue<StateT> value) convert,
    required bool fireImmediately,
    required void Function(Object error, StackTrace stackTrace)? onError,
    required DebugDependentSource? debugDependentSource,
    required ProviderElement<Object?>? dependent,
    required List<ProviderSubscription<Object?>> originalDependentSubscriptions,
    required void Function()? onCancel,
  })  : _fireImmediately = fireImmediately,
        _onError = onError,
        _convert = convert,
        _debugDependentSource = debugDependentSource,
        _dependent = dependent,
        _originalDependentSubscriptions = originalDependentSubscriptions,
        _onCancel = onCancel;

  final ProviderElement<StateT> _element;
  final ResultT Function(AsyncValue<StateT>) _convert;
  final void Function(ResultT? previous, ResultT next) _listener;
  final bool _fireImmediately;
  final void Function(Object error, StackTrace stackTrace)? _onError;
  final DebugDependentSource? _debugDependentSource;
  final ProviderElement<Object?>? _dependent;
  final void Function()? _onCancel;

  /// [ProvidElement._subscriptions] at the time this subscription was created.
  ///
  /// Used to optimize the removal of this subscription from the list when the
  /// provider's state was refreshed.
  final List<ProviderSubscription<Object?>> _originalDependentSubscriptions;

  bool _closed = false;
  int _pauseCount = 0;

  @override
  ResultT read() {
    if (_closed) {
      throw StateError('Cannot read from a closed subscription');
    }
    if (_pauseCount > 0) {
      throw StateError('Cannot read from a paused subscription');
    }

    return _convert(_element.requestState());
  }

  @override
  void pause() {
    if (_closed) {
      throw StateError('Cannot pause a closed subscription');
    }

    // If this is the first pause, pause the provider too.
    if (_pauseCount == 0) _element._pausedListenerCount++;

    _pauseCount++;
  }

  @override
  void resume() {
    if (_closed) {
      throw StateError('Cannot resume a closed subscription');
    }

    // Noop if not paused.
    if (_pauseCount == 0) return;

    // If this is the last resume, unpause the provider too.
    if (_pauseCount == 1) _element._pausedListenerCount--;

    _pauseCount--;
  }

  @override
  void close() {
    if (_closed) {
      throw StateError('Cannot close a closed subscription');
    }

    _closed = true;

    // If closing a paused subscription, unpause the provider too.
    if (_pauseCount > 0) _element._pausedListenerCount--;

    _onCancel?.call();

    _element._listeners.remove(this);

    if (_dependent != null &&
        _dependent._subscriptions == _originalDependentSubscriptions) {
      _dependent._subscriptions.remove(this);
    }
  }
}
