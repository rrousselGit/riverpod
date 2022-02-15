// ignore_for_file: public_member_api_docs
// TODO remove ignore_doc

part of '../framework.dart';

/// A callback used by providers to create the value exposed.
///
/// If an exception is thrown within that callback, all attempts at reading
/// the provider associated with the given callback will throw.
///
/// The parameter [ref] can be used to interact with other providers
/// and the life-cycles of this provider.
///
/// See also:
///
/// - [Ref], which exposes the methods to read other providers.
/// - [Provider], a provider that uses [Create] to expose an immutable value.
typedef Create<T, R extends Ref> = T Function(R ref);

/// A [Create] equivalent used by [Family].
typedef FamilyCreate<T, R extends Ref, Arg> = T Function(
  R ref,
  Arg arg,
);

/// A function that reads the state of a provider.
typedef Reader = T Function<T>(ProviderBase<T> provider);

/// A base class for _all_ providers.
@immutable
abstract class ProviderBase<State> extends ProviderOrFamily
    with ProviderListenable<State>
    implements ProviderOverride {
  /// A base class for _all_ providers.
  ProviderBase({
    required this.name,
    required this.from,
    required this.argument,
  });

  @override
  ProviderBase get _origin => originProvider;
  @override
  ProviderBase get _override => originProvider;

  /// {@template riverpod.name}
  /// A custom label for providers.
  ///
  /// This is picked-up by devtools and [toString] to show better messages.
  /// {@endtemplate}
  final String? name;

  /// If this provider was created with the `.family` modifier, [from] is the `.family` instance.
  @override
  final Family? from;

  /// If this provider was created with the `.family` modifier, [argument] is
  /// the variable that was used.
  final Object? argument;

  /// The provider that will be refreshed when calling [ProviderContainer.refresh]
  /// and that will be overridden when passed to `ProviderScope`.
  ///
  /// Defaults to `this`.
  @visibleForOverriding
  // ignore: avoid_returning_this
  ProviderBase<Object?> get originProvider => this;

  @override
  ProviderSubscription<State> addListener(
    Node node,
    void Function(State? previous, State next) listener, {
    void Function(Object error, StackTrace stackTrace)? onError,
    bool fireImmediately = false,
  }) {
    onError ??= Zone.current.handleUncaughtError;

    final element = node.readProviderElement(this);

    element.flush();
    if (fireImmediately) {
      handleFireImmediately(
        element.getState()!,
        listener: listener,
        onError: onError,
      );
    }

    return node._createSubscription(
      element,
      listener: listener,
      onError: onError,
    );
  }

  /// Initializes the state of a provider
  @visibleForOverriding
  State create(covariant Ref ref);

  /// Called when a provider is rebuilt. Used for providers to not notify their
  /// listeners if the exposed value did not change.
  @visibleForOverriding
  bool updateShouldNotify(State previousState, State newState);

  /// An internal method that defines how a provider behaves.
  @visibleForOverriding
  ProviderElementBase<State> createElement();

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode {
    if (from == null) return super.hashCode;

    return from.hashCode ^ argument.hashCode;
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) {
    if (from == null) return identical(other, this);

    return other.runtimeType == runtimeType &&
        other is ProviderBase<State> &&
        other.from == from &&
        other.argument == argument;
  }

  @override
  String toString() {
    var leading = '';
    if (from != null) {
      leading = '($argument)';
    }

    var trailing = '';
    if (name != null) {
      trailing = '$name:';
    }

    return '$trailing${describeIdentity(this)}$leading';
  }
}

var _debugIsRunningSelector = false;

class _ProviderSubscription<State> implements ProviderSubscription<State> {
  _ProviderSubscription._(
    this._listenedElement,
    this._listener, {
    required this.onError,
  });

  final void Function(State? previous, State next) _listener;
  final ProviderElementBase<State> _listenedElement;
  final void Function(Object error, StackTrace stackTrace) onError;
  var _closed = false;

  @override
  void close() {
    _closed = true;
    _listenedElement._listeners.remove(this);
    _listenedElement._onRemoveListener();
  }

  @override
  State read() {
    if (_closed) {
      throw StateError(
        'called ProviderSubscription.read on a subscription that was closed',
      );
    }
    return _listenedElement.readSelf();
  }
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
  final void Function(Object, StackTrace) onError;

  @override
  void close() {
    dependentElement._subscriptions.remove(this);
    listenedElement
      .._subscribers.remove(this)
      .._onRemoveListener();
  }

  @override
  State read() => listenedElement.readSelf();
}

/// An internal class that handles the state of a provider.
///
/// Do not use.
abstract class ProviderElementBase<State> implements Ref, Node {
  /// Do not use.
  ProviderElementBase(this._provider);

  static ProviderElementBase? _debugCurrentlyBuildingElement;

  var _debugSkipNotifyListenersAsserts = false;

  /// The provider associated with this [ProviderElementBase], before applying overrides.
  // Not typed as <State> because of https://github.com/rrousselGit/river_pod/issues/1100
  ProviderBase<Object?> get origin => _origin;
  late ProviderBase<Object?> _origin;

  /// The provider associated with this [ProviderElementBase], after applying overrides.
  ProviderBase<State> get provider => _provider;
  ProviderBase<State> _provider;

  /// The [ProviderContainer] that owns this [ProviderElementBase].
  @override
  ProviderContainer get container => _container;
  late ProviderContainer _container;

  /// Whether this [ProviderElementBase] is currently listened to or not.
  ///
  /// This maps to listeners added with [listen].
  /// See also [mayNeedDispose], called when [hasListeners] may have changed.
  bool get hasListeners =>
      _listeners.isNotEmpty ||
      _subscribers.isNotEmpty ||
      _dependents.isNotEmpty;

  // TODO(rrousselGit) refactor to match ChangeNotifier
  /// Accepts only _ProviderSubscription<State>, but not typed so that
  /// _ProviderSubscription<void> is valid
  final _listeners = <_ProviderSubscription<State>>[];
  final _dependents = <ProviderElementBase>[];

  /// The listeners that were added using [listen].
  ///
  /// This list allows us to traverse up in the provider graph.
  final _subscriptions = <_ProviderListener>[];

  /// The list of listeners added using [listen] from another provider.
  ///
  /// Storing ProviderListener instead of the provider Element as a provider
  /// can listen another provider multiple times with different listeners.
  final _subscribers = <_ProviderListener>[];

  var _dependencies = HashMap<ProviderElementBase, Object>();
  HashMap<ProviderElementBase, Object>? _previousDependencies;
  List<void Function()>? _onDisposeListeners;
  List<void Function()>? _onResumeListeners;
  List<void Function()>? _onCancelListeners;
  List<void Function()>? _onAddListeners;
  List<void Function()>? _onRemoveListeners;

  bool _mustRecomputeState = false;
  bool _dependencyMayHaveChanged = false;
  bool _debugDidChangeDependency = false;
  var _didCancelOnce = false;

  bool _mounted = false;

  /// Whether the element was disposed or not
  @visibleForTesting
  bool get mounted => _mounted;

  /// Whether the assert that prevents [requireState] from returning
  /// if the state was not set before is enabled.
  @visibleForOverriding
  bool get debugAssertDidSetStateEnabled => true;

  bool _debugDidSetState = false;
  bool _didBuild = false;

  /* STATE */
  Result<State>? _state;

  void setState(State newState) {
    assert(() {
      _debugDidSetState = true;
      return true;
    }(), '');
    final previousResult = getState();

    Result<State> newResult;
    if (newState is AsyncValue && previousResult != null) {
      final previousState = previousResult.requireState;

      newResult = Result<State>.data(
        newState.copyWithPrevious(previousState as AsyncValue) as State,
      );
    } else {
      newResult = Result.data(newState);
    }

    final result = _state = newResult;

    if (_didBuild) {
      _notifyListeners(result, previousResult);
    }
  }

  Result<State>? getState() => _state;

  // TODO make protected
  State get requireState {
    assert(() {
      if (debugAssertDidSetStateEnabled && !_debugDidSetState) {
        throw StateError(
          'Tried to read the state of an uninitialized provider',
        );
      }
      return true;
    }(), '');

    final state = getState();
    if (state == null) {
      throw StateError('uninitialized');
    }

    return state.map(
      error: (error) => _rethrowProviderError(error.error, error.stackTrace),
      data: (data) => data.state,
    );
  }

  /* /STATE */

  /// Called the first time a provider is obtained.
  @protected
  @mustCallSuper
  void mount() {
    _mounted = true;
    assert(() {
      RiverpodBinding.debugInstance
          .providerListChangedFor(containerId: container._debugId);

      return true;
    }(), '');
    _buildState();
  }

  // ignore: use_setters_to_change_properties
  /// Called when the override of a provider changes.
  ///
  /// See also:
  /// - `overrideWithValue`, which relies on [update] to handle
  ///   the scenario where the value changed.
  @protected
  @mustCallSuper
  // ignore: use_setters_to_change_properties
  void update(ProviderBase<State> newProvider) {
    _provider = newProvider;
  }

  void markMustRecomputeState() {
    if (_mustRecomputeState) return;

    _mustRecomputeState = true;
    _runOnDispose();
    _container._scheduler.scheduleProviderRefresh(this);

    // We don't call this._markDependencyMayHaveChanged here because we voluntarily
    // do not want to set the _dependencyMayHaveChanged flag to true.
    // Since the dependency is known to have changed, there is no reason to try
    // and "flush" it, as it will already get rebuilt.
    visitChildren((element) => element._markDependencyMayHaveChanged());
  }

  void flush() {
    _maybeRebuildDependencies();
    if (_mustRecomputeState) {
      _mustRecomputeState = false;
      _performBuild();
    }
  }

  void _maybeRebuildDependencies() {
    if (!_dependencyMayHaveChanged) {
      return;
    }
    _dependencyMayHaveChanged = false;

    visitAncestors((element) => element.flush());
  }

  void _performBuild() {
    _previousDependencies = _dependencies;
    _dependencies = HashMap();

    final previousStateResult = _state;

    assert(() {
      _debugDidSetState = false;
      return true;
    }(), '');
    _buildState();

    if (_state != previousStateResult) {
      assert(() {
        // Asserts would otherwise prevent a provider rebuild from updating
        // other providers
        _debugSkipNotifyListenersAsserts = true;
        return true;
      }(), '');
      _state!.map(
        data: (data) => _notifyListeners(data, previousStateResult),
        error: (error) => _notifyListeners(_state!, previousStateResult),
      );
      assert(() {
        _debugSkipNotifyListenersAsserts = false;
        return true;
      }(), '');
    }

    // Unsubscribe to everything that a provider no longer depends on.
    for (final sub in _previousDependencies!.entries) {
      sub.key
        .._dependents.remove(this)
        .._onRemoveListener();
    }
    _previousDependencies = null;
  }

  @pragma('vm:notify-debugger-on-exception')
  void _buildState() {
    ProviderElementBase? debugPreviouslyBuildingElement;
    assert(() {
      _debugDidChangeDependency = false;
      debugPreviouslyBuildingElement = _debugCurrentlyBuildingElement;
      _debugCurrentlyBuildingElement = this;
      return true;
    }(), '');
    _didBuild = false;
    try {
      // TODO move outside this function?
      _mounted = true;
      setState(_provider.create(this));
    } catch (err, stack) {
      assert(() {
        _debugDidSetState = true;
        return true;
      }(), '');
      _state = Result.error(err, stack);
    } finally {
      _didBuild = true;
      assert(() {
        _debugCurrentlyBuildingElement = debugPreviouslyBuildingElement;
        return true;
      }(), '');
    }
  }

  void _notifyListeners(
    Result<State> newState,
    Result<State>? previousStateResult,
  ) {
    assert(() {
      if (_debugSkipNotifyListenersAsserts) return true;

      assert(
          _debugCurrentlyBuildingElement == null ||
              _debugCurrentlyBuildingElement == this,
          '''
Providers are not allowed to modify other providers during their initialization.

The provider ${_debugCurrentlyBuildingElement!.origin} modified $origin while building.
''');

      container.debugCanModifyProviders?.call();
      return true;
    }(), '');

    final previousState = previousStateResult?.stateOrNull;

    if (previousStateResult != null &&
        previousStateResult.hasState &&
        newState.hasState &&
        !provider.updateShouldNotify(
          previousState as State,
          newState.requireState,
        )) {
      return;
    }

    final listeners = _listeners.toList(growable: false);
    final subscribers = _subscribers.toList(growable: false);
    newState.map(
      data: (newState) {
        for (var i = 0; i < listeners.length; i++) {
          Zone.current.runBinaryGuarded(
            listeners[i]._listener,
            previousState,
            newState.state,
          );
        }
        for (var i = 0; i < subscribers.length; i++) {
          Zone.current.runBinaryGuarded(
            subscribers[i].listener,
            previousState,
            newState.state,
          );
        }
      },
      error: (newState) {
        for (var i = 0; i < listeners.length; i++) {
          Zone.current.runBinaryGuarded(
            listeners[i].onError,
            newState.error,
            newState.stackTrace,
          );
        }
        for (var i = 0; i < subscribers.length; i++) {
          Zone.current.runBinaryGuarded(
            subscribers[i].onError,
            newState.error,
            newState.stackTrace,
          );
        }
      },
    );

    for (var i = 0; i < _dependents.length; i++) {
      _dependents[i]._didChangeDependency();
    }

    for (final observer in _container._observers) {
      _runQuaternaryGuarded(
        observer.didUpdateProvider,
        provider,
        previousState,
        newState.stateOrNull,
        _container,
      );
    }

    for (final observer in _container._observers) {
      newState.map(
        data: (_) {},
        error: (newState) {
          _runQuaternaryGuarded(
            observer.providerDidFail,
            provider,
            newState.error,
            newState.stackTrace,
            _container,
          );
        },
      );
    }
  }

  void _didChangeDependency() {
    assert(() {
      _debugDidChangeDependency = true;
      return true;
    }(), '');
    if (_mustRecomputeState) return;

    // will notify children that their dependency may have changed
    markMustRecomputeState();
  }

  void _markDependencyMayHaveChanged() {
    if (_dependencyMayHaveChanged) return;

    _dependencyMayHaveChanged = true;

    visitChildren((element) => element._markDependencyMayHaveChanged());
  }

  bool _debugAssertCanDependOn(ProviderListenable listenable) {
    assert(() {
      if (listenable is! ProviderBase) return true;

      assert(
        provider != origin ||
            origin.dependencies == null ||
            origin.dependencies!.contains(listenable.from) ||
            origin.dependencies!.contains(listenable),
        'The provider $origin tried to read $listenable, but it specified a '
        "'dependendencies' list yet that list does not contain $listenable.\n\n"
        "To fix, add $listenable to $origin's 'dependencies' parameter",
      );

      final queue = Queue<ProviderElementBase>.from(_dependents);

      while (queue.isNotEmpty) {
        final current = queue.removeFirst();
        queue.addAll(current._dependents);

        if (current.origin == listenable) {
          throw CircularDependencyError._();
        }
      }

      return true;
    }(), '');
    return true;
  }

  void _assertNotOutdated() {
    assert(
      _debugDidChangeDependency == false,
      'Cannot use ref functions after the dependency of a provider changed but before the provider rebuilt',
    );
  }

  @override
  T refresh<T>(ProviderBase<T> provider) {
    _assertNotOutdated();
    return _container.refresh(provider);
  }

  @override
  T read<T>(ProviderBase<T> provider) {
    _assertNotOutdated();
    assert(!_debugIsRunningSelector, 'Cannot call ref.read inside a selector');
    assert(_debugAssertCanDependOn(provider), '');
    return _container.read(provider);
  }

  @override
  T watch<T>(ProviderListenable<T> listenable) {
    _assertNotOutdated();
    assert(!_debugIsRunningSelector, 'Cannot call ref.watch inside a selector');

    if (listenable is! ProviderBase<T>) {
      var initialized = false;
      late Result<T> firstValue;

      listen<T>(
        listenable,
        (prev, value) {
          if (initialized) {
            _didChangeDependency();
          } else {
            firstValue = Result.data(value);
            initialized = true;
          }
        },
        onError: (err, stack) {
          if (initialized) {
            _didChangeDependency();
          } else {
            initialized = true;
            firstValue = Result.error(err, stack);
          }
        },
        fireImmediately: true,
      );

      return firstValue.requireState;
    }

    assert(_debugAssertCanDependOn(listenable), '');

    final element = _container.readProviderElement(listenable);
    _dependencies.putIfAbsent(element, () {
      final previousSub = _previousDependencies?.remove(element);
      if (previousSub != null) {
        return previousSub;
      }

      assert(() {
        // Flushing the provider before adding a new dependency
        // as otherwise this could cause false positives with certain asserts.
        // It's done only in debug mode since `readSelf` will flush the value
        // again anyway, and the only value of this flush is to not break asserts.
        element.flush();
        return true;
      }(), '');

      element
        .._onListen()
        .._dependents.add(this);

      return Object();
    });

    return element.readSelf();
  }

  @override
  ProviderElementBase<T> readProviderElement<T>(ProviderBase<T> provider) {
    return _container.readProviderElement(provider);
  }

  @override
  ProviderSubscription<T> _createSubscription<T>(
    ProviderElementBase<T> element, {
    required void Function(T? previous, T next) listener,
    required void Function(Object error, StackTrace stackTrace) onError,
  }) {
    element._onListen();

    final sub = _ProviderListener<T>._(
      listenedElement: element,
      dependentElement: this,
      listener: (prev, value) => listener(prev as T?, value as T),
      onError: onError,
    );

    element._subscribers.add(sub);
    _subscriptions.add(sub);

    return sub;
  }

  @override
  ProviderSubscription<T> listen<T>(
    ProviderListenable<T> listenable,
    void Function(T? previous, T value) listener, {
    void Function(Object error, StackTrace stackTrace)? onError,
    bool fireImmediately = false,
  }) {
    _assertNotOutdated();
    assert(!_debugIsRunningSelector, 'Cannot call ref.read inside a selector');
    assert(_debugAssertCanDependOn(listenable), '');

    return listenable.addListener(
      this,
      listener,
      fireImmediately: fireImmediately,
      onError: onError,
    );
  }

  /// Returns the currently exposed by a provider
  ///
  /// May throw if the provider threw when creating the exposed value.
  State readSelf() {
    flush();

    return requireState;
  }

  /// Visit the [ProviderElement]s of providers that are listening to this element.
  ///
  /// A provider is considered as listening to this element if it either [watch]
  /// or [listen] this element.
  ///
  /// This method does not guarantee that a dependency is visited only once.
  /// If a provider both [watch] and [listen] an element, or if a provider
  /// [listen] multiple times to an element, it may be visited multiple times.
  void visitChildren(void Function(ProviderElementBase element) visitor) {
    for (var i = 0; i < _dependents.length; i++) {
      visitor(_dependents[i]);
    }

    for (var i = 0; i < _subscribers.length; i++) {
      visitor(_subscribers[i].dependentElement);
    }
  }

  /// Visit the [ProviderElementBase]s that this provider is listening to.
  ///
  /// A provider is considered as listening to this element if it either [watch]
  /// or [listen] this element.
  ///
  /// This method does not guarantee that a provider is visited only once.
  /// If this provider both [watch] and [listen] an element, or if it
  /// [listen] multiple times to an element, that element may be visited multiple times.
  void visitAncestors(void Function(ProviderElementBase element) visitor) {
    _dependencies.keys.forEach(visitor);

    for (var i = 0; i < _subscriptions.length; i++) {
      visitor(_subscriptions[i].listenedElement);
    }
  }

  /// Called on [ProviderContainer.dispose].
  @protected
  @mustCallSuper
  void dispose() {
    assert(
      _mounted || _debugDidChangeDependency,
      '$provider was disposed twice',
    );
    assert(() {
      RiverpodBinding.debugInstance
          .providerListChangedFor(containerId: container._debugId);
      return true;
    }(), '');

    _runOnDispose();

    // TODO test [listen] calls are cleared

    for (final sub in _dependencies.entries) {
      sub.key._dependents.remove(this);
      sub.key._onRemoveListener();
    }
    _dependencies.clear();

    for (final observer in _container._observers) {
      _runBinaryGuarded(
        observer.didDisposeProvider,
        _origin,
        _container,
      );
    }

    _listeners.clear();
  }

  void _onListen() {
    _onAddListeners?.forEach(_runGuarded);
    if (_didCancelOnce && !hasListeners) {
      _onResumeListeners?.forEach(_runGuarded);
    }
  }

  void _onRemoveListener() {
    _onRemoveListeners?.forEach(_runGuarded);
    if (!hasListeners) {
      _didCancelOnce = true;
      _onCancelListeners?.forEach(_runGuarded);
    }
    mayNeedDispose();
  }

  /// Life-cycle for when a listener is removed.
  ///
  /// See also:
  ///
  /// - [AutoDisposeProviderElementBase], which overrides this method to destroy the
  ///   state of a provider when no longer used.
  @protected
  @visibleForOverriding
  void mayNeedDispose() {}

  @override
  void onDispose(void Function() listener) {
    _assertNotOutdated();
    if (!_mounted) {
      throw StateError('Cannot call onDispose after a provider was dispose');
    }
    _onDisposeListeners ??= [];
    _onDisposeListeners!.add(listener);
  }

  @protected
  void _runOnDispose() {
    if (!_mounted) return;
    _mounted = false;

    while (_subscriptions.isNotEmpty) {
      _subscriptions.first.close();
    }

    _onDisposeListeners?.forEach(_runGuarded);

    _onDisposeListeners = null;
    _onCancelListeners = null;
    _onResumeListeners = null;
    _onAddListeners = null;
    _onRemoveListeners = null;
    _didCancelOnce = false;
  }

  @override
  void onAddListener(void Function() cb) {
    _onAddListeners ??= [];
    _onAddListeners!.add(cb);
  }

  @override
  void onRemoveListener(void Function() cb) {
    _onRemoveListeners ??= [];
    _onRemoveListeners!.add(cb);
  }

  @override
  void onCancel(void Function() cb) {
    _onCancelListeners ??= [];
    _onCancelListeners!.add(cb);
  }

  @override
  void onResume(void Function() cb) {
    _onResumeListeners ??= [];
    _onResumeListeners!.add(cb);
  }

  @override
  String toString() {
    return '$runtimeType(provider: $provider, origin: $origin)';
  }
}

Never _rethrowProviderError(Object error, StackTrace stackTrace) {
  final chain = Chain([
    Trace.current(),
    ...Chain.forTrace(stackTrace).traces,
  ]).foldFrames((frame) => frame.package == 'riverpod');

  Error.throwWithStackTrace(error, chain);
}

mixin OverrideWithValueMixin<State> on ProviderBase<State> {
  /// {@template riverpod.overrridewithvalue}
  /// Overrides a provider with a value, ejecting the default behaviour.
  ///
  /// This will also disable the auto-scoping mechanism, meaning that if the
  /// overridden provider specified [dependencies], it will have no effect.
  ///
  /// Some common use-cases are:
  /// - testing, by replacing a service with a fake implementation, or to reach
  ///   a very specific state easily.
  /// - multiple environments, by changing the implementation of a class
  ///   based on the platform or other parameters.
  ///
  /// This function should be used in combination with `ProviderScope.overrides`
  /// or `ProviderContainer.overrides`:
  ///
  /// ```dart
  /// final myService = Provider((ref) => MyService());
  ///
  /// runApp(
  ///   ProviderScope(
  ///     overrides: [
  ///       myService.overrideWithValue(
  ///         // Replace the implementation of MyService with a fake implementation
  ///         MyFakeService(),
  ///       ),
  ///     ],
  ///     child: MyApp(),
  ///   ),
  /// );
  /// ```
  /// {@endtemplate}
  Override overrideWithValue(State value) {
    return ProviderOverride(
      origin: this,
      override: ValueProvider<State>(value),
    );
  }
}

mixin OverrideWithProviderMixin<State,
    ProviderType extends ProviderBase<Object?>> {
  ProviderBase<State> get originProvider;

  /// {@template riverpod.overridewithprovider}
  /// Overrides a provider with a value, ejecting the default behaviour.
  ///
  /// This will also disable the auto-scoping mechanism, meaning that if the
  /// overridden provider specified `dependencies`, it will have no effect.
  ///
  /// The override must not specify a `dependencies`.
  ///
  /// Some common use-cases are:
  /// - testing, by replacing a service with a fake implementation, or to reach
  ///   a very specific state easily.
  /// - multiple environments, by changing the implementation of a class
  ///   based on the platform or other parameters.
  ///
  /// This function should be used in combination with `ProviderScope.overrides`
  /// or `ProviderContainer.overrides`:
  ///
  /// ```dart
  /// final myService = Provider((ref) => MyService());
  ///
  /// runApp(
  ///   ProviderScope(
  ///     overrides: [
  ///       myService.overrideWithProvider(
  ///         // Replace the implementation of the provider with a different one
  ///         Provider((ref) {
  ///           ref.watch('other');
  ///           return MyFakeService(),
  ///         }),
  ///       ),
  ///     ],
  ///     child: MyApp(),
  ///   ),
  /// );
  /// ```
  /// {@endtemplate}
  Override overrideWithProvider(ProviderType value) {
    assert(
      value.originProvider.dependencies == null,
      'When using overrideWithProvider, the override cannot specify `dependencies`.',
    );

    return ProviderOverride(
      origin: originProvider,
      override: value.originProvider,
    );
  }
}

@immutable
abstract class Result<State> {
  // coverage:ignore-start
  factory Result.data(State state) = ResultData;
  // coverage:ignore-end

  // coverage:ignore-start
  factory Result.error(Object error, StackTrace stackTrace) = ResultError;
  // coverage:ignore-end

  static Result<State> guard<State>(State Function() cb) {
    try {
      return Result.data(cb());
    } catch (err, stack) {
      return Result.error(err, stack);
    }
  }

  bool get hasState;

  State? get stateOrNull;
  State get requireState;

  R map<R>({
    required R Function(ResultData<State> data) data,
    required R Function(ResultError<State>) error,
  });
}

class ResultData<State> implements Result<State> {
  ResultData(this.state);

  final State state;

  @override
  bool get hasState => true;

  @override
  State? get stateOrNull => state;

  @override
  State get requireState => state;

  @override
  R map<R>({
    required R Function(ResultData<State> data) data,
    required R Function(ResultError<State>) error,
  }) {
    return data(this);
  }

  @override
  bool operator ==(Object? other) =>
      other is ResultData<State> &&
      other.runtimeType == runtimeType &&
      other.state == state;

  @override
  int get hashCode => Object.hash(runtimeType, state);
}

class ResultError<State> implements Result<State> {
  ResultError(this.error, this.stackTrace);

  final Object error;
  final StackTrace stackTrace;

  @override
  bool get hasState => false;

  @override
  State? get stateOrNull => null;

  @override
  // ignore: only_throw_errors
  State get requireState => throw error;

  @override
  R map<R>({
    required R Function(ResultData<State> data) data,
    required R Function(ResultError<State>) error,
  }) {
    return error(this);
  }

  @override
  bool operator ==(Object? other) =>
      other is ResultError<State> &&
      other.runtimeType == runtimeType &&
      other.stackTrace == stackTrace &&
      other.error == error;

  @override
  int get hashCode => Object.hash(runtimeType, error, stackTrace);
}
