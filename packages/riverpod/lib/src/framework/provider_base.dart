// ignore_for_file: public_member_api_docs
// TODO remove ignore_doc

part of '../framework.dart';

class _Sentinel {
  const _Sentinel();
}

/// Alias for [Ref]
@Deprecated('Use Ref instead.')
typedef ProviderReference = Ref;

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

/// A function to stop listenening to a provider
typedef RemoveListener = void Function();

/// A [Create] equivalent used by [Family].
typedef FamilyCreate<T, R extends Ref, Arg> = T Function(
  R ref,
  Arg arg,
);

/// A function that reads the state of a provider.
typedef Reader = T Function<T>(ProviderBase<T> provider);

/// A base class for _all_ providers.
abstract class ProviderBase<State> extends ProviderOrFamily
    implements ProviderListenable<State>, ProviderOverride {
  /// A base class for _all_ providers.
  ProviderBase({required this.name});

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

  Family? _from;

  /// If this provider was created with the `.family` modifier, [from] is the `.family` instance.
  Family? get from => _from;

  Object? _argument;

  /// If this provider was created with the `.family` modifier, [argument] is
  /// variable used.
  Object? get argument => _argument;

  /// The provider that will be refreshed when calling [ProviderContainer.refresh]
  /// and that will be overridden when passed to `ProviderScope`.
  ///
  /// Defaults to `this`.
  @visibleForOverriding
  // ignore: avoid_returning_this
  ProviderBase<Object?> get originProvider => this;

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

  /// Partially listen to a provider.
  ///
  /// Note: This method of listening to an object is currently only supported
  /// by `ref.watch(` from `hooks_riverpod` and [ProviderContainer.listen].
  ///
  /// The [select] function allows filtering unwanted rebuilds of a Widget
  /// by reading only the properties that we care about.
  ///
  /// For example, consider the following `ChangeNotifier`:
  ///
  /// ```dart
  /// class Person extends ChangeNotifier {
  ///   int _age = 0;
  ///   int get age => _age;
  ///   set age(int age) {
  ///     _age = age;
  ///     notifyListeners();
  ///   }
  ///
  ///   String _name = '';
  ///   String get name => _name;
  ///   set name(String name) {
  ///     _name = name;
  ///     notifyListeners();
  ///   }
  /// }
  ///
  /// final personProvider = ChangeNotifierProvider((_) => Person());
  /// ```
  ///
  /// In this class, both `name` and `age` may change, but a widget may need
  /// only `age`.
  ///
  /// If we used `ref.watch(`/`Consumer` as we normally would, this would cause
  /// widgets that only use `age` to still rebuild when `name` changes, which
  /// is inefficient.
  ///
  /// The method [select] can be used to fix this, by explicitly reading only
  /// a specific part of the object.
  ///
  /// A typical usage would be:
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context, WidgetRef ref) {
  ///   final age = ref.watch(personProvider.select((p) => p.age));
  ///   return Text('$age');
  /// }
  /// ```
  ///
  /// This will cause our widget to rebuild **only** when `age` changes.
  ///
  ///
  /// **NOTE**: The function passed to [select] can return complex computations
  /// too.
  ///
  /// For example, instead of `age`, we could return a "isAdult" boolean:
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context, WidgetRef ref) {
  ///   final isAdult = ref.watch(personProvider.select((p) => p.age >= 18));
  ///   return Text('$isAdult');
  /// }
  /// ```
  ///
  /// This will further optimise our widget by rebuilding it only when "isAdult"
  /// changed instead of whenever the age changes.
  ProviderListenable<Selected> select<Selected>(
    Selected Function(State value) selector,
  ) {
    return _ProviderSelector<State, Selected>(
      provider: this,
      selector: selector,
    );
  }

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
    this._listener,
  );

  final void Function(State? previous, State next) _listener;
  final ProviderElementBase<State> _listenedElement;
  var _closed = false;

  @override
  void close() {
    _closed = true;
    _listenedElement._listeners.remove(this);
    _listenedElement.mayNeedDispose();
  }

  @override
  State read() {
    if (_closed) {
      throw StateError(
        'called ProviderSubscription.read on a subscription that was closed',
      );
    }
    return _listenedElement.getExposedValue();
  }
}

/// When a provider listens to another provider using `listen`
class _ProviderListener {
  _ProviderListener._({
    required this.listenedElement,
    required this.dependentElement,
    required this.listener,
  });

  final void Function(Object? prev, Object? state) listener;
  final ProviderElementBase dependentElement;
  final ProviderElementBase listenedElement;

  void close() {
    listenedElement
      .._subscribers.remove(this)
      ..mayNeedDispose();
  }
}

/// An internal class that handles the state of a provider.
///
/// Do not use.
abstract class ProviderElementBase<State> implements Ref {
  /// Do not use.
  ProviderElementBase(this._provider);

  static ProviderElementBase? _debugCurrentlyBuildingElement;

  var _debugSkipNotifyListenersAsserts = false;

  /// The provider associated to this [ProviderElementBase], before applying overrides.
  ProviderBase<State> get origin => _origin;
  late ProviderBase<State> _origin;

  /// The provider associated to this [ProviderElementBase], after applying overrides.
  ProviderBase<State> get provider => _provider;
  ProviderBase<State> _provider;

  /// The [ProviderContainer] that owns this [ProviderElementBase].
  @override
  ProviderContainer get container => _container;
  late ProviderContainer _container;

  /// Whether this [ProviderElementBase] is currently listened or not.
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
  DoubleLinkedQueue<void Function()>? _onDisposeListeners;

  bool _mustRecomputeState = false;
  bool _dependencyMayHaveChanged = false;
  bool _debugDidChangeDependency = false;

  bool _mounted = false;

  /// Whether the element was disposed or not
  @visibleForTesting
  bool get mounted => _mounted;

  bool _didBuild = false;

  /* STATE */
  var _state = AsyncValue<State>.loading();

  void setState(State newState) {
    final previousState = getState();

    _state = AsyncData<State>(newState);

    if (_didBuild &&
        provider.updateShouldNotify(previousState.value, newState)) {
      notifyListeners(previousState: previousState);
    }
  }

  void setError(Object error, StackTrace? stackTrace) {
    _state = AsyncError<State>(
      ProviderException._(error, stackTrace, provider),
      stackTrace: stackTrace,
    );

    notifyListeners(
// TODO previous

        );
  }

  AsyncValue<State> getState() => _state;

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
    _mounted = false;
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
    _maybeRebuildState();
  }

  void _maybeRebuildDependencies() {
    if (!_dependencyMayHaveChanged) {
      return;
    }
    _dependencyMayHaveChanged = false;

    visitAncestors((element) => element.flush());
  }

  /// A debug-only life-cycle called before a provider rebuilds.
  ///
  /// Useful to reset debug state before a provider rebuilds, such as variables
  /// for asserts.
  void debugWillRebuildState() {}

  void _maybeRebuildState() {
    if (_mustRecomputeState) {
      _previousDependencies = _dependencies;
      _dependencies = HashMap();

      assert(() {
        debugWillRebuildState();
        return true;
      }(), '');

      final previousState = getState();

      _buildState();

      if (provider.updateShouldNotify(previousState.value, getState().value)) {
        ProviderElementBase? debugPreviouslyBuildingElement;
        assert(() {
          // Asserts would otherwise prevent a provider rebuild from updating
          // other providers
          _debugSkipNotifyListenersAsserts = true;
          return true;
        }(), '');
        notifyListeners(previousState: previousState);
        assert(() {
          _debugSkipNotifyListenersAsserts = false;
          return true;
        }(), '');
      }

      // Unsubscribe to everything that a provider no-longer depends on.
      for (final sub in _previousDependencies!.entries) {
        sub.key
          .._dependents.remove(this)
          ..mayNeedDispose();
      }
      _previousDependencies = null;
      _mustRecomputeState = false;
    }
  }

  void notifyListeners({AsyncValue<State>? previousState}) {
    assert(() {
      if (_debugSkipNotifyListenersAsserts) return true;

      assert(
          _debugCurrentlyBuildingElement == null ||
              _debugCurrentlyBuildingElement == this,
          '''
Providers are not allowed to modify other providers during their initialization.

The provider ${_debugCurrentlyBuildingElement!.provider} modified $provider while building.
''');

      container.debugCanModifyProviders?.call();
      return true;
    }(), '');

    final listeners = _listeners.toList(growable: false);
    final subscribers = _subscribers.toList(growable: false);

    final state = getState();

    state.whenOrNull(
      // TODO error
      data: (state) {
        for (var i = 0; i < listeners.length; i++) {
          Zone.current.runBinaryGuarded(
            listeners[i]._listener,
            previousState?.value,
            state,
          );
        }
        for (var i = 0; i < subscribers.length; i++) {
          Zone.current.runBinaryGuarded(
            subscribers[i].listener,
            previousState?.value,
            state,
          );
        }
      },
    );

    for (var i = 0; i < _dependents.length; i++) {
      _dependents[i]._didChangeDependency();
    }

    state.whenOrNull(
      // TODO error
      data: (state) {
        if (previousState != null && previousState is! AsyncLoading) {
          // TODO "loading" handling
          for (final observer in _container._observers) {
            // TODO error handling
            Zone.current.runGuarded(
              () => observer.didUpdateProvider(
                provider,
                previousState.value,
                getState().value,
                _container,
              ),
            );
          }
        }
      },
    );
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

  bool _debugAssertCanDependOn(ProviderBase provider) {
    assert(
      origin.dependencies == null ||
          origin.dependencies!.contains(provider.from) ||
          origin.dependencies!.contains(provider),
      'The provider $origin tried to read $provider, but it specified a '
      "'dependendencies' list yet that list does not contain $provider.\n\n"
      "To fix, add $provider to $origin's 'dependencies' parameter",
    );

    assert(() {
      final queue = Queue<ProviderElementBase>.from(_dependents);

      while (queue.isNotEmpty) {
        final current = queue.removeFirst();
        queue.addAll(current._dependents);

        if (current.origin == provider) {
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

  ProviderSubscription<State> addListener(
    ProviderBase<State> provider,
    void Function(State? previous, State next) listener, {
    required bool fireImmediately,
  }) {
    // TODO(rrousselGit) add onError parameter
    if (fireImmediately) {
      try {
        listener(null, getExposedValue());
      } catch (err, stack) {
        Zone.current.handleUncaughtError(err, stack);
      }
    }

    final sub = _ProviderSubscription<State>._(this, listener);

    _listeners.add(sub);

    return sub;
  }

  @override
  T watch<T>(ProviderListenable<T> listenable) {
    _assertNotOutdated();
    assert(!_debugIsRunningSelector, 'Cannot call ref.watch inside a selector');

    if (listenable is _ProviderSelector) {
      var initialized = false;
      late T firstValue;

      listen<T>(
        listenable,
        (prev, value) {
          if (initialized) {
            _didChangeDependency();
          } else {
            firstValue = value;
            initialized = true;
          }
        },
        fireImmediately: true,
      );

      return firstValue;
    }

    final provider = listenable as ProviderBase<T>;
    assert(_debugAssertCanDependOn(provider), '');

    final element = _container.readProviderElement(provider);
    _dependencies.putIfAbsent(element, () {
      final previousSub = _previousDependencies?.remove(element);
      if (previousSub != null) {
        return previousSub;
      }

      element._dependents.add(this);

      return Object();
    });

    return element.getExposedValue();
  }

  @override
  void Function() listen<T>(
    ProviderListenable<T> listenable,
    void Function(T? previous, T value) listener, {
    bool fireImmediately = false,
  }) {
    _assertNotOutdated();
    assert(!_debugIsRunningSelector, 'Cannot call ref.read inside a selector');

    if (listenable is _ProviderSelector<Object?, T>) {
      return listenable._elementListen(
        this,
        listener,
        fireImmediately: fireImmediately,
      );
    }

    final provider = listenable as ProviderBase<T>;
    assert(_debugAssertCanDependOn(provider), '');

    // TODO remove by passing the a debug flag to `listen`
    final element = container.readProviderElement(provider);
    // TODO test flush
    element.flush();

    if (fireImmediately) {
      listener(null, element.getExposedValue());
    }

    // TODO(rrousselGit) test
    // TODO(rrousselGit) onError

    final sub = _ProviderListener._(
      listenedElement: element,
      dependentElement: this,
      listener: (prev, value) => listener(prev as T?, value as T),
    );

    element._subscribers.add(sub);
    _subscriptions.add(sub);

    return () {
      _subscriptions.remove(sub);
      // this will remove element._subscribers
      sub.close();
    };
  }

  /// Returns the currently exposed by a provider
  ///
  /// May throw if the provider threw when creating the exposed value.
  State getExposedValue() {
    flush();

    return getState().value;
  }

  @protected
  void _buildState() {
    ProviderElementBase? debugPreviouslyBuildingElement;
    assert(() {
      _debugDidChangeDependency = false;
      debugPreviouslyBuildingElement = _debugCurrentlyBuildingElement;
      _debugCurrentlyBuildingElement = this;
      return true;
    }(), '');

    try {
      _mounted = true;
      _didBuild = false;
      setState(_provider.create(this));
    } catch (err, stack) {
      setError(err, stack);
    } finally {
      _didBuild = true;
      assert(() {
        _debugCurrentlyBuildingElement = debugPreviouslyBuildingElement;
        return true;
      }(), '');
    }
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

    _mounted = false;
    _runOnDispose();

    // TODO test [listen] calls are cleared

    for (final sub in _dependencies.entries) {
      sub.key._dependents.remove(this);
      sub.key.mayNeedDispose();
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

  /// Life-cycle for when a listener is removed.
  ///
  /// See also:
  ///
  /// - [AutoDisposeProviderElementBase], which overrides this method to destroy the
  ///   state of a provider when no-longer used.
  @protected
  @visibleForOverriding
  void mayNeedDispose() {}

  @override
  void onDispose(void Function() listener) {
    _assertNotOutdated();
    if (!_mounted) {
      throw StateError('Cannot call onDispose after a provider was dispose');
    }
    _onDisposeListeners ??= DoubleLinkedQueue();
    _onDisposeListeners!.add(listener);
  }

  @protected
  void _runOnDispose() {
    // TODO(rrousselGit) test
    for (final subscription in _subscriptions) {
      subscription.close();
    }
    _subscriptions.clear();

    _onDisposeListeners?.forEach(_runGuarded);
    _onDisposeListeners = null;
  }
}

/// Encapulates an exception thrown while building a provider.
///
/// This exception can be thrown if a provider fails to return a valid value:
/// ```dart
/// final example = Provider((ref) => throw Error());
/// ```
///
/// in which case, any attempt at listening to `example` with result in a [ProviderException].
class ProviderException implements Exception {
  ProviderException._(this.exception, this.stackTrace, this.provider);

  /// The exception thrown while building the provider
  final Object exception;

  /// The [StackTrace] associated with [exception].
  final StackTrace? stackTrace;

  /// The provider that threw this exception.
  final ProviderBase provider;

  @override
  String toString() {
    return '''
An exception was thrown while building $provider.

Thrown exception:
$exception

Stack trace:
$stackTrace
''';
  }
}

mixin OverrideWithValueMixin<State> on ProviderBase<State> {
  /// {@template riverpod.overrridewithvalue}
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
