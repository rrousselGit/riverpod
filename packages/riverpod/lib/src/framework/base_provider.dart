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
/// - [ProviderReference], which exposes the methods to read other providers.
/// - [Provider], a provier that uses [Create] to expose an immutable value.
typedef Create<T, Ref extends ProviderReference> = T Function(Ref ref);

/// A function that reads the state of a provider.
typedef Reader = T Function<T>(RootProvider<Object, T> provider);

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
String describeIdentity(Object object) {
  return '${object.runtimeType}#${shortHash(object)}';
}

// Copied from Flutter
/// [Object.hashCode]'s 20 least-significant bits.
String shortHash(Object object) {
  return object.hashCode.toUnsigned(20).toRadixString(16).padLeft(5, '0');
}

/// A base class for all providers, used to consume a provider.
///
/// It is used by [ProviderContainer.listen] and `useProvider` to listen to
/// both a provider and `provider.select`.
///
/// Do not implement or extend.
abstract class ProviderListenable<Listened> {}

/// A base class for providers that never disposes themselves.
///
/// This is the default base class for providers, unless a provider was marked
/// with the `.autoDispose` modifier, like: `Provider.autoDispose(...)`
abstract class AlwaysAliveProviderBase<Created, Listened>
    extends RootProvider<Created, Listened> {
  /// Creates an [AlwaysAliveProviderBase].
  AlwaysAliveProviderBase(
    Created Function(ProviderReference ref) create,
    String name,
  ) : super(create, name);

  @override
  ProviderElement<Created, Listened> createElement() {
    return ProviderElement(this);
  }

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
  // Cannot be overriden by AutoDisposeProviders
  ProviderOverride overrideWithProvider(
    AlwaysAliveProviderBase<Created, Listened> provider,
  ) {
    return ProviderOverride(provider, this);
  }
}

/// A base class for _all_ providers.
abstract class ProviderBase<Created, Listened>
    implements ProviderListenable<Listened> {
  /// A base class for _all_ providers.
  ProviderBase(this._create, this.name);

  final Created Function(ProviderReference ref) _create;

  /// {@template riverpod.name}
  /// A custom label for providers.
  ///
  /// This is picked-up by devtools and [toString] to show better messages.
  /// {@endtemplate}
  final String name;

  Family _from;

  /// If this provider was created with the `.family` modifier, [from] is the `.family` instance.
  Family get from => _from;

  Object _argument;

  /// If this provider was created with the `.family` modifier, [argument] is
  /// variable used.
  Object get argument => _argument;

  /// An internal method that creates the state of a provider.
  ProviderStateBase<Created, Listened> createState();

  /// An internal method that defines how a provider behaves.
  ProviderElement<Created, Listened> createElement();

  @override
  String toString() {
    final content = {
      'name': name,
      'from': from,
      'argument': argument,
    }.entries.where((e) => e.value != null).map((e) => '${e.key}: ${e.value}');

    return '${describeIdentity(this)}$content';
  }
}

/// {@template riverpod.rootprovider}
/// A base class for non-scoped providers.
///
/// By making typing a parameter as [RootProvider] instead of [ProviderBase],
/// this excludes [ScopedProvider] – which may not be supported by your code
/// due to its particular behavior.
/// {@endtemplate}
abstract class RootProvider<Created, Listened>
    extends ProviderBase<Created, Listened> {
  /// {@macro riverpod.rootprovider}
  RootProvider(Created Function(ProviderReference ref) create, String name)
      : super(create, name);

  /// Partially listen to a provider.
  ///
  /// Note: This method of listening to an object is currently only supported
  /// by `useProvider` from `hooks_riverpod` and [ProviderContainer.listen].
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
  /// If we used `useProvider`/`Consumer` as we normally would, this would cause
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
  /// Widget build(BuildContext context) {
  ///   final age = useProvider(personProvider.select((p) => p.age));
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
  /// Widget build(BuildContext context) {
  ///   final isAdult = useProvider(personProvider.select((p) => p.age >= 18));
  ///   return Text('$isAdult');
  /// }
  /// ```
  ///
  /// This will further optimise our widget by rebuilding it only when "isAdult"
  /// changed instead of whenever the age changes.
  ProviderListenable<Selected> select<Selected>(
    Selected Function(Listened value) selector,
  ) {
    return ProviderSelector<Listened, Selected>(
      provider: this,
      selector: selector,
    );
  }

  /// Overrides the behavior of a provider with a value.
  ///
  /// {@macro riverpod.overideWith}
  // Works only on RootProvider<T, T> scenario by default
  // TODO support ChangeNotifier/StateNotifier
  Override overrideWithValue(Listened value) {
    return ProviderOverride(
      ValueProvider<Object, Listened>((ref) => value, value),
      this,
    );
  }
}

/// An internal class for `RootProvider.select`.
class ProviderSelector<Input, Output> implements ProviderListenable<Output> {
  /// An internal class for `RootProvider.select`.
  ProviderSelector({
    this.provider,
    this.selector,
  });

  /// The provider that was selected
  final RootProvider<Object, Input> provider;

  /// The selector applied
  final Output Function(Input) selector;

  SelectorSubscription<Input, Output> _listen(
    ProviderContainer container, {
    void Function(SelectorSubscription<Input, Output> sub) mayHaveChanged,
    void Function(SelectorSubscription<Input, Output> sub) didChange,
  }) {
    return SelectorSubscription(
      container: container,
      selector: selector,
      provider: provider,
      mayHaveChanged: mayHaveChanged,
      didChange: didChange,
    );
  }
}

/// An object used by providers to interact with other providers and the life-cycles
/// of the application.
///
/// See also:
///
/// - [read] and [watch], two methods that allows a provider to consume other providers.
/// - [mounted], an utility to know whether the provider is still "alive" or not.
/// - [onDispose], a method that allows performing a task when the provider is destroyed.
abstract class ProviderReference {
  /// An utility to know if a provider was destroyed or not.
  ///
  /// This is useful when dealing with asynchronous operations, as the provider
  /// may have potentially be destroyed before the end of the asyncronous operation.
  /// In that case, we may want to stop performing further tasks.
  ///
  /// Most providers are never disposed, so in most situations you do not have to
  /// care about this.
  bool get mounted;

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
  T read<T>(RootProvider<Object, T> provider);

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
  /// - if nothing is listening to `sortedTodosProvider`, then no sort if performed.
  T watch<T>(RootProvider<Object, T> provider);
}

class _Listener<Listened> extends LinkedListEntry<_Listener<Listened>> {
  _Listener({
    this.mayHaveChanged,
    this.didChange,
    @required this.element,
  }) : lastNotificationCount = element._notificationCount - 1;

  int lastNotificationCount;

  final void Function() mayHaveChanged;
  final void Function() didChange;
  final ProviderElement<Object, Listened> element;
}

/// An object that allows watching the state of a provider.
///
/// This object is created by [ProviderContainer.listen].
/// It allows reading the current value, closing the subscription, or knowing
/// if the value exposed changed since the last read.
class ProviderSubscription<Listened> {
  ProviderSubscription._(this._listener);

  final _Listener<Listened> _listener;

  /// Stops listening to the provider.
  ///
  /// Calling [close] may lead to the state of the listened provider to be
  /// destroyed, if that provider uses the `.autoDispose` modifier.
  void close() {
    if (_listener.list != null) {
      _listener.unlink();
      _listener.element.didRemoveListener();
    }
  }

  /// {@template riverpod.flush}
  /// Compute the provider (if it needs to be recomputed) and returns whether
  /// a new value was created or not.
  /// {@endtemplate}
  bool flush() {
    if (_listener.list == null) {
      throw StateError(
        'Cannot call ProviderSubscription.flush() after close was called',
      );
    }
    _listener.element.flush();
    return _listener.element._notificationCount >
        _listener.lastNotificationCount;
  }

  /// Obtains the value currently exposed by the provider.
  ///
  /// This implicitly calls [flush], which may cause a provider to be recomputed.
  Listened read() {
    if (_listener.list == null) {
      throw StateError(
        'Cannot call ProviderSubscription.read() after close was called',
      );
    }
    _listener.element.flush();
    _listener.lastNotificationCount = _listener.element._notificationCount;
    return _listener.element.getExposedValue();
  }
}

/// An internal class that handles the state of a provider.
///
/// Do not use.
class ProviderElement<Created, Listened> implements ProviderReference {
  /// Do not use.
  ProviderElement(this._provider) : state = _provider.createState();

  static ProviderElement _debugCurrentlyBuildingElement;

  ProviderBase<Created, Listened> _origin;

  /// The provider associated to this [ProviderElement], before applying overrides.
  ProviderBase<Created, Listened> get origin => _origin;

  ProviderBase<Created, Listened> _provider;

  /// The provider associated to this [ProviderElement], after applying overrides.
  ProviderBase<Created, Listened> get provider => _provider;

  final ProviderStateBase<Created, Listened> state;

  ProviderContainer _container;

  /// The [ProviderContainer] that owns this [ProviderElement].
  @override
  ProviderContainer get container => _container;

  Set<ProviderElement> _dependents;

  /// All the [ProviderElement]s that depend on this [ProviderElement].
  Set<ProviderElement> get dependents => {...?_dependents};

  /// Whether this [ProviderElement] is currently listened or not.
  ///
  /// This maps to listeners added with [listen].
  /// See also [didRemoveListener], called when [hasListeners] may have changed.
  bool get hasListeners => _listeners.isNotEmpty;

  final _listeners = LinkedList<_Listener<Listened>>();
  var _subscriptions = <ProviderElement, ProviderSubscription>{};
  Map<ProviderElement, ProviderSubscription> _previousSubscriptions;
  DoubleLinkedQueue<void Function()> _onDisposeListeners;

  int _notificationCount = 0;
  int _notifyDidChangeLastNotificationCount = 0;
  bool _dirty = true;
  // initialized to true so that the initial state creation don't notify listeners
  bool _dependencyMayHaveChanged = true;
  // equivalent to _dependencyMayHaveChanged that does not rely on
  // ProviderSubscription.flush, to force recomputed a state
  bool _dependencyDidChange = false;

  bool _mounted = false;
  @override
  bool get mounted => _mounted;
  bool _didMount = false;

  ProviderException _exception;

  @override
  T read<T>(RootProvider<Object, T> provider) {
    return _container.read(provider);
  }

  @override
  void onDispose(void Function() listener) {
    if (!_mounted) {
      throw StateError('Cannot call onDispose after a provider was dispose');
    }
    _onDisposeListeners ??= DoubleLinkedQueue();
    _onDisposeListeners.add(listener);
  }

  @override
  T watch<T>(ProviderBase<Object, T> provider) {
    final element = _container.readProviderElement(provider);
    final sub = _subscriptions.putIfAbsent(element, () {
      final previousSub = _previousSubscriptions?.remove(element);
      if (previousSub != null) {
        return previousSub;
      }
      element._dependents ??= {};
      element._dependents.add(this);
      return element.listen(mayHaveChanged: _markDependencyMayHaveChanged);
    }) as ProviderSubscription<T>;
    return sub.read();
  }

  void _markDependencyMayHaveChanged(ProviderSubscription sub) {
    if (!_dependencyMayHaveChanged) {
      _dependencyMayHaveChanged = true;
      notifyMayHaveChanged();
    }
  }

  /// Listen to this provider.
  ///
  /// See also:
  ///
  /// - [ProviderContainer.listen], which internally calls this method
  /// - [ProviderReference.watch], which makes a provider listen to another provider.
  ProviderSubscription<Listened> listen({
    void Function(ProviderSubscription<Listened> sub) mayHaveChanged,
    void Function(ProviderSubscription<Listened> sub) didChange,
  }) {
    ProviderSubscription<Listened> sub;
    final entry = _Listener<Listened>(
      mayHaveChanged: mayHaveChanged == null ? null : () => mayHaveChanged(sub),
      didChange: didChange == null ? null : () => didChange(sub),
      element: this,
    );
    _listeners.add(entry);

    return sub = ProviderSubscription._(entry);
  }

  /// {@macro riverpod.flush}
  void flush() {
    if (_dependencyMayHaveChanged || _dependencyDidChange) {
      _dependencyMayHaveChanged = false;
      // must be executed before _runStateCreate() so that errors during
      // creation are not silenced
      _exception = null;
      _runOnDispose();

      var hasAnyDependencyChanged = _dependencyDidChange;
      for (final sub in _subscriptions.values) {
        if (sub.flush()) {
          hasAnyDependencyChanged = true;
        }
      }
      if (hasAnyDependencyChanged) {
        _runStateCreate();
      }
      _dependencyDidChange = false;
    }
    _dirty = false;
    if (_notifyDidChangeLastNotificationCount != _notificationCount) {
      _notifyDidChangeLastNotificationCount = _notificationCount;
      _notifyDidChange();
    }
    assert(!_dirty, 'flush did not reset the dirty flag for $provider');
    assert(
      !_dependencyMayHaveChanged,
      'flush did not reset the _dependencyMayHaveChanged flag for $provider',
    );
  }

  /// Returns the currently exposed by a provider
  ///
  /// May throw if the provider threw when creating the exposed value.
  Listened getExposedValue() {
    assert(
      !_dependencyMayHaveChanged,
      'Called getExposedValue without calling flush before',
    );
    if (_exception != null) {
      throw _exception;
    }
    return state._exposedValue;
  }

  /// Notify that the state associated to this provider have changes.
  /// This will cause dependent widgets and providers to rebuild.
  @protected
  void markDidChange() {
    if (!_didMount) {
      return;
    }
    _notificationCount++;
    notifyMayHaveChanged();
  }

  /// Notify that this provider **may** have changed.
  ///
  /// This does not guarantee that the provider _did_ change, only that it is
  /// possible that it did.
  @protected
  void notifyMayHaveChanged() {
    assert(() {
      if (_debugCurrentlyBuildingElement == null ||
          _debugCurrentlyBuildingElement == this) {
        return true;
      }
      final parentsQueue = DoubleLinkedQueue<ProviderElement>.from(
        _subscriptions.keys,
      );

      while (parentsQueue.isNotEmpty) {
        final parent = parentsQueue.removeFirst();
        if (parent == _debugCurrentlyBuildingElement) {
          return true;
        }
        parentsQueue.addAll(parent._subscriptions.keys);
      }

      throw AssertionError('''
The provider $provider was marked as needing to be recomputed while creating ${_debugCurrentlyBuildingElement.provider},
but $provider does not depend on ${_debugCurrentlyBuildingElement.provider}.
''');
    }(), '');
    if (!_mounted) {
      throw StateError('Cannot call onDispose after a provider was dispose');
    }
    if (_dirty) {
      return;
    }
    _dirty = true;
    for (final listener in _listeners) {
      if (listener.mayHaveChanged != null) {
        _runGuarded(listener.mayHaveChanged);
      }
    }
    if (_didMount) {
      for (final observer in _container._observers) {
        _runUnaryGuarded(
          observer.mayHaveChanged,
          _origin,
        );
      }
    }
  }

  @protected
  void _notifyDidChange() {
    for (final listener in _listeners) {
      if (listener.didChange != null) {
        _runGuarded(listener.didChange);
      }
    }
    for (final observer in _container._observers) {
      _runBinaryGuarded(
        observer.didUpdateProvider,
        _origin,
        state._exposedValue,
      );
    }
  }

  /// Life-cycle for when a listener is removed.
  ///
  /// See also:
  ///
  /// - [AutoDisposeProviderElement], which overrides this method to destroy the
  ///   state of a provider when no-longer used.
  @protected
  @visibleForOverriding
  void didRemoveListener() {}

  /// Called the first time a provider is obtained.
  @protected
  @mustCallSuper
  void mount() {
    _mounted = true;
    state._element = this;
    _runStateCreate();
    _didMount = true;
    _dirty = false;
    _dependencyMayHaveChanged = false;
  }

  // ignore: use_setters_to_change_properties
  /// Called when the override of a provider changes.
  ///
  /// See also:
  /// - [RootProvider.overrideWithValue], which relies on [update] to handle
  ///   the scenario where the value changed.
  @protected
  @mustCallSuper
  void update(ProviderBase<Created, Listened> newProvider) {
    _provider = newProvider;
  }

  /// Called on [ProviderContainer.dispose].
  @protected
  @mustCallSuper
  void dispose() {
    _mounted = false;
    _runOnDispose();

    for (final sub in _subscriptions.entries) {
      sub.key._dependents.remove(this);
      sub.value.close();
    }

    for (final observer in _container._observers) {
      _runUnaryGuarded(
        observer.didDisposeProvider,
        _origin,
      );
    }

    _listeners.clear();
    state.dispose();
  }

  /// Forces the state of a provider to be re-created, even if none of its
  /// dependencies changed.
  void markMustRecomputeState() {
    _dependencyDidChange = true;
    notifyMayHaveChanged();
  }

  @protected
  void _runOnDispose() {
    _onDisposeListeners?.forEach(_runGuarded);
    _onDisposeListeners = null;
  }

  @protected
  void _runStateCreate() {
    final previous = state._createdValue;
    _previousSubscriptions = _subscriptions;
    _subscriptions = {};
    ProviderElement previouslyBuildingElement;
    assert(() {
      previouslyBuildingElement = _debugCurrentlyBuildingElement;
      _debugCurrentlyBuildingElement = this;
      return true;
    }(), '');
    try {
      state._createdValue = _provider._create(this);
      state.valueChanged(previous: previous);
    } catch (err, stack) {
      if (!state.handleError(err, stack)) {
        _exception = ProviderException._(err, stack, _provider);
      }
    } finally {
      assert(() {
        _debugCurrentlyBuildingElement = previouslyBuildingElement;
        return true;
      }(), '');
      if (_previousSubscriptions != null) {
        for (final sub in _previousSubscriptions.entries) {
          sub.key._dependents.remove(this);
          sub.value.close();
        }
      }
      _previousSubscriptions = null;
    }
  }
}

/// The internal state of a provider
abstract class ProviderStateBase<Created, Listened> {
  ProviderElement<Created, Listened> _element;

  /// The [ProviderReference] associated with this provider.
  ProviderReference get ref => _element;

  Created _createdValue;

  /// The last value that was created by a provider.
  ///
  /// May change over time, in which case [valueChanged] will be called with the
  /// previous value.
  Created get createdValue => _createdValue;

  Listened _exposedValue;

  /// The value currently exposed by the provider.
  ///
  /// Modifying this value after the first time will notify listeners
  /// that the exposed value changed.
  ///
  /// Must be set during [valueChanged].
  Listened get exposedValue => _exposedValue;
  set exposedValue(Listened exposedValue) {
    _exposedValue = exposedValue;
    _element.markDidChange();
  }

  /// Creates the value exposed by a provider from the value created.
  ///
  /// May be called again when one of the dependency listened by the provider
  /// changed, in which case the previous [createdValue] is passed as `previous`.
  ///
  /// On first call, **must** set [exposedValue].
  @protected
  void valueChanged({Created previous});

  /// Optionally handles errors inside the `create` callback.
  ///
  /// This method should return `true` if it handled the error successfully,
  /// otherwise `false`.
  ///
  /// Always returns `false` by default.
  @protected
  bool handleError(Object error, StackTrace stackTrace) {
    return false;
  }

  /// Release the resources associated with this state.
  @protected
  void dispose() {}
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
