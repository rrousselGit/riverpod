// ignore_for_file: public_member_api_docs
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
/// - [ProviderRefBase], which exposes the methods to read other providers.
/// - [Provider], a provider that uses [Create] to expose an immutable value.
typedef Create<T, Ref extends ProviderRefBase> = T Function(Ref ref);

typedef RemoveListener = void Function();

/// A [Create] equivalent used by [Family].
typedef FamilyCreate<T, Ref extends ProviderRefBase, Arg> = T Function(
  Ref ref,
  Arg arg,
);

class _Default {
  const _Default();
}

/// A function that reads the state of a provider.
typedef Reader = T Function<T>(ProviderBase<T> provider);

// Copied from Flutter
/// Returns a summary of the runtime type and hash code of `object`.
///
/// See also:
///
///  * [Object.hashCode], a value used when placing an object in a [Map] or
///    other similar data structure, and which is also used in debug output to
///    distinguish instances of the same class (hash collisions are
///    possible, but rare enough that its use in debug output is useful).
///  * [Object.runtimeType], the [Type] of an object.
String describeIdentity(Object? object) {
  return '${object.runtimeType}#${shortHash(object)}';
}

// Copied from Flutter
/// [Object.hashCode]'s 20 least-significant bits.
String shortHash(Object? object) {
  return object.hashCode.toUnsigned(20).toRadixString(16).padLeft(5, '0');
}

/// A base class for all providers, used to consume a provider.
///
/// It is used by [ProviderContainer.listen] and `ref.watch` to listen to
/// both a provider and `provider.select`.
///
/// Do not implement or extend.
abstract class ProviderListenable<State> {}

/// A base class for all providers, used to consume a provider.
///
/// It is used by [ProviderContainer.listen] and `ref.watch` to listen to
/// both a provider and `provider.select`.
///
/// Do not implement or extend.
mixin AlwaysAliveProviderListenable<State>
    implements ProviderListenable<State> {}

/// A base class for providers that never disposes themselves.
///
/// This is the default base class for providers, unless a provider was marked
/// with the `.autoDispose` modifier, like: `Provider.autoDispose(...)`
abstract class AlwaysAliveProviderBase<State> extends ProviderBase<State>
    implements AlwaysAliveProviderListenable<State> {
  /// Creates an [AlwaysAliveProviderBase].
  AlwaysAliveProviderBase(String? name) : super(name);

  @override
  ProviderElementBase<State> createElement();

  @override
  AlwaysAliveProviderListenable<Selected> select<Selected>(
    Selected Function(State value) selector,
  ) {
    return _AlwaysAliveProviderSelector<State, Selected>(
      provider: this,
      selector: selector,
    );
  }
}

/// A base class for _all_ providers.
abstract class ProviderBase<State>
    implements ProviderListenable<State>, ProviderOverride {
  /// A base class for _all_ providers.
  ProviderBase(this.name);

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

  State create(covariant ProviderRefBase ref);

  /// Called when a provider is rebuilt. Used for providers to not notify their
  /// listeners if the exposed value did not change.
  bool recreateShouldNotify(State previousState, State newState);

  /// An internal method that defines how a provider behaves.
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

/// An internal class for `ProviderBase.select`.
@sealed
class _ProviderSelector<Input, Output> implements ProviderListenable<Output> {
  /// An internal class for `ProviderBase.select`.
  _ProviderSelector({
    required this.provider,
    required this.selector,
  });

  /// The provider that was selected
  final ProviderBase<Input> provider;

  /// The selector applied
  final Output Function(Input) selector;

  _SelectorSubscription<Input, Output> listen(
    ProviderContainer container,
    void Function(Output) listener, {
    required bool fireImmediately,
  }) {
    var lastSelectedValue = selector(container.read(provider));

    if (fireImmediately) {
      listener(lastSelectedValue);
    }

    final sub = container.listen<Input>(provider, (value) {
      final newSelectedValue = selector(value);
      if (newSelectedValue != lastSelectedValue) {
        lastSelectedValue = newSelectedValue;
        listener(lastSelectedValue);
      }
    });

    return _SelectorSubscription(sub, () => lastSelectedValue);
  }

  void Function() _elementListen(
    ProviderElementBase element,
    void Function(Output) listener, {
    required bool fireImmediately,
  }) {
    var lastValue = selector(element._container.read(provider));
    if (fireImmediately) listener(lastValue);

    return element.listen<Input>(provider, (input) {
      final newValue = selector(input);
      if (lastValue != newValue) {
        lastValue = newValue;
        listener(newValue);
      }
    });
  }
}

class _AlwaysAliveProviderSelector<Input, Output> = _ProviderSelector<Input,
    Output> with AlwaysAliveProviderListenable<Output>;

///
abstract class ProviderSubscription<State> {
  void close();

  State read();
}

class _ProviderSubscription<State> implements ProviderSubscription<State> {
  _ProviderSubscription._(
    this._listenedElement,
    this._listener,
  );

  final void Function(State) _listener;
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

class _SelectorSubscription<Input, Output>
    implements ProviderSubscription<Output> {
  _SelectorSubscription(this._internalSub, this._read);

  final ProviderSubscription<Input> _internalSub;
  final Output Function() _read;
  var _closed = false;

  @override
  void close() {
    _closed = true;
    _internalSub.close();
  }

  @override
  Output read() {
    if (_closed) {
      throw StateError(
        'called ProviderSubscription.read on a subscription that was closed',
      );
    }
    return _read();
  }
}

/// When a provider listens to another provider using `listen`
class _ProviderListener<T> {
  _ProviderListener._({
    required this.listenedElement,
    required this.dependentElement,
    required this.listener,
  });

  final void Function(T state) listener;
  final ProviderElementBase dependentElement;
  final ProviderElementBase<T> listenedElement;

  void close() {
    listenedElement
      .._subscribers.remove(this)
      ..mayNeedDispose();
  }
}

@Deprecated('Use ProviderRefBase instead.')
typedef ProviderReference = ProviderRefBase;

/// {@template riverpod.providerrefbase}
/// An object used by providers to interact with other providers and the life-cycles
/// of the application.
///
/// See also:
///
/// - [read] and [watch], two methods that allows a provider to consume other providers.
/// - [onDispose], a method that allows performing a task when the provider is destroyed.
/// {@endtemplate}
abstract class ProviderRefBase {
  /// Re-create the state of a provider and return the new state.
  State refresh<State>(ProviderBase<State> provider);

  /// The [ProviderContainer] that this provider is associated with.
  ProviderContainer get container;

  /// Adds a listener to perform an operation right before the provider is destroyed.
  ///
  /// This typically happen when a provider marked with `.autoDispose` is no-longer
  /// used, or when [ProviderContainer.dispose] is called.
  ///
  /// See also:
  ///
  /// - [Provider.autoDispose], a modifier which tell a provider that it should
  ///   destroy its state when no-longer listened.
  /// - [ProviderContainer.dispose], to destroy all providers associated with
  ///   a [ProviderContainer] at once.
  void onDispose(void Function() cb);

  /// Read the state associated with a provider, without listening to that provider.
  ///
  /// By calling [read] instead of [watch], this will not cause a provider's
  /// state to be recreated when the provider obtained changes.
  ///
  /// A typical use-case for this method is when passing it to the created
  /// object like so:
  ///
  /// ```dart
  /// final configsProvider = FutureProvider(...);
  /// final myServiceProvider = Provider((ref) {
  ///   return MyService(ref.read);
  /// });
  ///
  /// class MyService {
  ///   MyService(this.read);
  ///
  ///   final Reader read;
  ///
  ///   Future<User> fetchUser() {
  ///     // We read the current configurations, but do not care about
  ///     // rebuilding MyService when the configurations changes
  ///     final configs = read(configsProvider.future);
  ///
  ///     return dio.get(configs.host);
  ///   }
  /// }
  /// ```
  ///
  /// By passing [read] to an object, this allows our object to read other providers.
  /// But we do not want to re-create our object if any of the provider
  /// obtained changes. We only want to read their current value without doing
  /// anything else.
  ///
  /// If possible, avoid using [read] and prefer [watch], which is generally
  /// safer to use.
  T read<T>(ProviderBase<T> provider);

  /// Obtains the state of a provider and cause the state to be re-evaluated
  /// when that provider emits a new value.
  ///
  /// Using [watch] allows supporting the scenario where we want to re-create
  /// our state when one of the object we are listening to changed.
  ///
  /// This method should be your go-to way to make a provider read another
  /// provider – even if the value exposed by that other provider never changes.
  ///
  /// ## Use-case example: Sorting a todo-list
  ///
  /// Consider a todo-list application. We may want to implement a sort feature,
  /// to see the uncompleted todos first.\
  /// We will want to create a sorted list of todos based on the
  /// combination of the unsorted list and a sort method (ascendant, descendant, ...),
  /// both of which may change over time.
  ///
  /// In this situation, what we do not want to do is to sort our list
  /// directly inside the `build` method of our UI, as sorting a list can be
  /// expensive.
  /// But maintaining a cache manually is difficult and error prone.
  ///
  /// To solve this problem, we could create a separate [Provider] that will
  /// expose the sorted list, and use [watch] to automatically re-evaluate
  /// the list **only** when needed.
  ///
  /// In code, this may look like:
  ///
  /// ```dart
  /// final sortProvider = StateProvider((_) => Sort.byName);
  /// final unsortedTodosProvider = StateProvider((_) => <Todo>[]);
  ///
  /// final sortedTodosProvider = Provider((ref) {
  ///   // listen to both the sort enum and the unfiltered list of todos
  ///   final sort = ref.watch(sortProvider);
  ///   final todos = ref.watch(unsortedTodosProvider);
  ///
  ///   // Creates a new sorted list from the combination of the unfiltered
  ///   // list and the filter type.
  ///   return [...todos].sort((a, b) { ... });
  /// });
  /// ```
  ///
  /// In this code, by using [Provider] + [watch]:
  ///
  /// - if either `sortProvider` or `unsortedTodosProvider` changes, then
  ///   `sortedTodosProvider` will automatically be recomputed.
  /// - if multiple widgets depends on `sortedTodosProvider` the list will be
  ///   sorted only once.
  /// - if nothing is listening to `sortedTodosProvider`, then no sort is performed.
  T watch<T>(AlwaysAliveProviderListenable<T> provider);

  /// Listen to a provider and call `listener` whenever its value changes.
  ///
  /// Listeners will automatically be removed when the provider rebuilds (such
  /// as when a provider listeneed with [watch] changes).
  ///
  /// Returns a function that allows cancelling the subscription early.
  ///
  /// - `fireImmediately` can be optionally passed to tell Riverpod to immediately
  ///    call the listener with the current value.
  ///    Defaults to false.
  void Function() listen<T>(
    AlwaysAliveProviderListenable<T> provider,
    void Function(T value) listener, {
    bool fireImmediately,
  });
}

/// An internal class that handles the state of a provider.
///
/// Do not use.
abstract class ProviderElementBase<State> implements ProviderRefBase {
  /// Do not use.
  ProviderElementBase(this._provider);

  static ProviderElementBase? _debugCurrentlyBuildingElement;

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
  // TODO(rrousselGit) test _dependents case
  // TODO(rrousselGit) test _subscribers case
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
  final _subscriptions = <_ProviderListener<Object?>>[];

  /// The list of listeners added using [listen] from another provider.
  ///
  /// Storing ProviderListener instead of the provider Element as a provider
  /// can listen another provider multiple times with different listeners.
  final _subscribers = <_ProviderListener<State>>[];

  var _dependencies = HashMap<ProviderElementBase, Object>();
  HashMap<ProviderElementBase, Object>? _previousDependencies;
  DoubleLinkedQueue<void Function()>? _onDisposeListeners;

  bool _mustRecomputeState = false;
  bool _dependencyMayHaveChanged = false;

  bool _mounted = false;
  @visibleForTesting
  bool get mounted => _mounted;

  bool _didBuild = false;

  ProviderException? _exception;

  /* STATE */
  late State _state;

  // Using default values to differentiate between `notifyListeners()` and `notifyListeners(newValue: null)`
  // It is safe to type `newValue` as Object? because the method is hidden
  // under a type-safe interface that types it as `State newValue` instead.
  set state(State newState) {
    late State previousState;
    if (_didBuild) previousState = _state;

    _state = newState;
    if (_didBuild) notifyListeners(previousState: previousState);
  }

  State get state => _state;

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

  void _maybeRebuildState() {
    if (_mustRecomputeState) {
      _previousDependencies = _dependencies;
      _dependencies = HashMap();

      final previousState = state;

      _buildState();

      if (provider.recreateShouldNotify(previousState, _state)) {
        notifyListeners(previousState: previousState);
      }

      // Unsubscribe to everything that a provider no-longer depends on.
      for (final sub in _previousDependencies!.entries) {
        // TODO(rrousselGit) refactor
        sub.key._dependents.remove(this);
      }
      _previousDependencies = null;
      _mustRecomputeState = false;
    }
  }

  void notifyListeners({Object? previousState = const _Default()}) {
    assert(() {
      container.debugCanModifyProviders?.call();
      return true;
    }(), '');

    final newValue = _state;
    final listeners = _listeners.toList(growable: false);
    final subscribers = _subscribers.toList(growable: false);
    for (var i = 0; i < listeners.length; i++) {
      Zone.current.runUnaryGuarded(listeners[i]._listener, newValue);
    }
    for (var i = 0; i < subscribers.length; i++) {
      Zone.current.runUnaryGuarded(subscribers[i].listener, newValue);
    }

    for (var i = 0; i < _dependents.length; i++) {
      _dependents[i]._didChangeDependency();
    }

    if (previousState != const _Default()) {
      for (final observer in _container._observers) {
        Zone.current.runGuarded(
          () => observer.didUpdateProvider(
            provider,
            previousState,
            state,
            _container,
          ),
        );
      }
    }
  }

  void _didChangeDependency() {
    if (_mustRecomputeState) return;

    markMustRecomputeState();

    // We don't call this._markDependencyMayHaveChanged here because we voluntarily
    // do not want to set the _dependencyMayHaveChanged flag to true.
    // Since the dependency is known to have changed, there is no reason to try
    // and "flush" it, as it will already get rebuilt.
    visitChildren((element) => element._markDependencyMayHaveChanged());
  }

  void _markDependencyMayHaveChanged() {
    if (_dependencyMayHaveChanged) return;

    _dependencyMayHaveChanged = true;

    visitChildren((element) => element._markDependencyMayHaveChanged());
  }

  bool _debugAssertCanDependOn(ProviderBase provider) {
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

  @override
  T refresh<T>(ProviderBase<T> provider) {
    return _container.refresh(provider);
  }

  @override
  T read<T>(ProviderBase<T> provider) {
    assert(_debugAssertCanDependOn(provider), '');
    return _container.read(provider);
  }

  ProviderSubscription<State> addListener(
    ProviderBase<State> provider,
    void Function(State value) listener, {
    required bool fireImmediately,
  }) {
    // TODO(rrousselGit) add fireImmediately parameter
    // TODO(rrousselGit) add onError parameter
    // TODO(rrousselGit) test that if the provider threw immediately, the listen call completes corretly
    if (fireImmediately) {
      listener(getExposedValue());
    }

    final sub = _ProviderSubscription<State>._(this, listener);

    _listeners.add(sub);

    return sub;
  }

  @override
  T watch<T>(ProviderListenable<T> listenable) {
    if (listenable is _ProviderSelector) {
      var initialized = false;
      late T firstValue;

      listen<T>(
        listenable,
        (value) {
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

  /// Returns the currently exposed by a provider
  ///
  /// May throw if the provider threw when creating the exposed value.
  State getExposedValue() {
    flush();

    if (_exception != null) {
      throw _exception!;
    }
    return _state;
  }

  @protected
  void _buildState() {
    ProviderElementBase? debugPreviouslyBuildingElement;
    assert(() {
      debugPreviouslyBuildingElement = _debugCurrentlyBuildingElement;
      _debugCurrentlyBuildingElement = this;
      return true;
    }(), '');

    try {
      _didBuild = false;
      _state = _provider.create(this);
    } catch (err, stack) {
      _exception = ProviderException._(err, stack, _provider);
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
    // TODO test

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
    assert(_mounted, '$provider was disposed twice');
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

  @override
  void Function() listen<T>(
    ProviderListenable<T> listenable,
    void Function(T value) listener, {
    bool fireImmediately = false,
  }) {
    if (listenable is _ProviderSelector<Object?, T>) {
      return listenable._elementListen(
        this,
        listener,
        fireImmediately: fireImmediately,
      );
    }

    final provider = listenable as ProviderBase<T>;
    // TODO remove by passing the a debug flag to `listen`
    final element = container.readProviderElement(provider);
    // TODO test flush
    element.flush();

    if (fireImmediately) {
      listener(element.getExposedValue());
    }

    // TODO(rrousselGit) test
    // TODO(rrousselGit) onError

    final sub = _ProviderListener._(
      listenedElement: element,
      dependentElement: this,
      listener: listener,
    );

    element._subscribers.add(sub);
    _subscriptions.add(sub);

    return () {
      _subscriptions.remove(sub);
      // this will remove element._subscribers
      sub.close();
    };
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
  final StackTrace stackTrace;

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

@protected
mixin ProviderOverridesMixin<State> on AlwaysAliveProviderBase<State> {
  /// Overrides the behavior of a provider with a value.
  ///
  /// {@macro riverpod.overideWith}
  Override overrideWithValue(State value);

  /// Overrides the behavior of this provider with another provider.
  ///
  /// {@template riverpod.overideWith}
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
  ///         // Replace the implementation of MyService with a fake implementation
  ///         Provider((ref) => MyFakeService())
  ///       ),
  ///     ],
  ///     child: MyApp(),
  ///   ),
  /// );
  /// ```
  /// {@endtemplate}
  // Cannot be overridden by AutoDisposeProviders
  Override overrideWithProvider(
    AlwaysAliveProviderBase<State> provider,
  );
}
