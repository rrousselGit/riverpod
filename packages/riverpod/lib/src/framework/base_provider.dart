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
/// - [Provider], a provider that uses [Create] to expose an immutable value.
typedef Create<T, Ref extends ProviderReference> = T Function(Ref ref);

/// A function that reads the state of a provider.
typedef Reader = T Function<T>(RootProvider<Object?, T> provider);

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
/// It is used by [ProviderContainer.listen] and `ref.watch(` to listen to
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
  AlwaysAliveProviderBase(String? name) : super(name);

  @override
  ProviderElement<Created, Listened> createElement() {
    return ProviderElement(this);
  }
}

/// A base class for _all_ providers.
abstract class ProviderBase<Created, Listened>
    implements ProviderListenable<Listened> {
  /// A base class for _all_ providers.
  ProviderBase(this.name) {
    assert(() {
      debugId = '${_debugNextId++}';
      return true;
    }(), '');
  }

  Created create(ProviderReference ref);

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

  /// An internal method that creates the state of a provider.
  ProviderStateBase<Created, Listened> createState();

  /// An internal method that defines how a provider behaves.
  ProviderElement<Created, Listened> createElement();

  /// A unique identifier for this provider, used by devtools to differentiate providers
  ///
  /// Available only during development.
  late final String debugId;

  @override
  String toString() {
    final content = {
      'name': name,
      'from': from,
      'argument': argument,
    }.entries.where((e) => e.value != null).map((e) => '${e.key}: ${e.value}');

    return '${describeIdentity(this)}$content';
  }

  // Custom implementation of hash code optimized for reading providers.
  //
  // The value is designed to fit within the SMI representation. This makes
  // the cached value use less memory (one field and no extra heap objects) and
  // cheap to compare (no indirection).
  //
  // See also:
  //
  //  * https://dart.dev/articles/dart-vm/numeric-computation, which
  //    explains how numbers are represented in Dart.
  @nonVirtual
  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes, hash_and_equals
  int get hashCode => _cachedHash;
  final int _cachedHash = _nextHashCode = (_nextHashCode + 1) % 0xffffff;
  static int _nextHashCode = 1;
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
  RootProvider(String? name) : super(name);

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
  ///     _notifyListeners();
  ///   }
  ///
  ///   String _name = '';
  ///   String get name => _name;
  ///   set name(String name) {
  ///     _name = name;
  ///     _notifyListeners();
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
  /// Widget build(BuildContext context, WidgetReference ref) {
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
  /// Widget build(BuildContext context, WidgetReference ref) {
  ///   final isAdult = ref.watch(personProvider.select((p) => p.age >= 18));
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
}

/// An internal class for `RootProvider.select`.
@sealed
class ProviderSelector<Input, Output> implements ProviderListenable<Output> {
  /// An internal class for `RootProvider.select`.
  ProviderSelector({
    required this.provider,
    required this.selector,
  });

  /// The provider that was selected
  final RootProvider<Object?, Input> provider;

  /// The selector applied
  final Output Function(Input) selector;
}

class ProviderSubscription<T> {
  ProviderSubscription._(
    this._element,
    this._listener,
  );

  bool _debugDisposed = false;

  final void Function(T) _listener;
  final ProviderElement<Object?, T> _element;

  void close() {
    assert(!_debugDisposed, 'called `close` on an already closed subscription');
    assert(() {
      _debugDisposed = true;
      return true;
    }(), '');

    _element._listeners.remove(_listener);
    _element.mayNeedDispose();
  }

  T read() => _element.getExposedValue();
}

/// An object used by providers to interact with other providers and the life-cycles
/// of the application.
///
/// See also:
///
/// - [read] and [watch], two methods that allows a provider to consume other providers.
/// - [mounted], an utility to know whether the provider is still "alive" or not.
/// - [onDispose], a method that allows performing a task when the provider is destroyed.
@sealed
abstract class ProviderReference {
  /// An utility to know if a provider was destroyed or not.
  ///
  /// This is useful when dealing with asynchronous operations, as the provider
  /// may have potentially be destroyed before the end of the asynchronous operation.
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
  T read<T>(RootProvider<Object?, T> provider);

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
  T watch<T>(AlwaysAliveProviderBase<Object?, T> provider);
}

/// An internal class that handles the state of a provider.
///
/// Do not use.
class ProviderElement<Created, Listened> implements ProviderReference {
  /// Do not use.
  ProviderElement(this._provider) : state = _provider.createState();

  static ProviderElement? _debugCurrentlyBuildingElement;

  /// The provider associated to this [ProviderElement], before applying overrides.
  ProviderBase<Created, Listened> get origin => _origin;
  late ProviderBase<Created, Listened> _origin;

  /// The provider associated to this [ProviderElement], after applying overrides.
  ProviderBase<Created, Listened> get provider => _provider;
  ProviderBase<Created, Listened> _provider;

  final ProviderStateBase<Created, Listened> state;

  /// The [ProviderContainer] that owns this [ProviderElement].
  @override
  ProviderContainer get container => _container;
  late ProviderContainer _container;

  /// Whether this [ProviderElement] is currently listened or not.
  ///
  /// This maps to listeners added with [listen].
  /// See also [mayNeedDispose], called when [hasListeners] may have changed.
  // TODO(rrousselGit) test _dependents case
  bool get hasListeners => _listeners.isNotEmpty || _dependents.isNotEmpty;

  // TODO(rrousselGit) refactor to match ChangeNotifier
  List<void Function(Listened value)> _listeners = [];
  List<ProviderElement> _dependents = [];

  // TODO(rrousselGit) remove
  List<void Function(Listened value)> get listeners => _listeners;
  // TODO(rrousselGit) remove
  List<ProviderElement> get dependents => _dependents;

  HashMap<ProviderElement, Object> _dependencies =
      HashMap<ProviderElement, Object>();
  HashMap<ProviderElement, Object>? _previousDependencies;
  DoubleLinkedQueue<void Function()>? _onDisposeListeners;

  bool _mustRecomputeState = false;

  @override
  bool get mounted => _mounted;
  bool _mounted = false;

  ProviderException? _exception;

  /// Called the first time a provider is obtained.
  @protected
  @mustCallSuper
  void mount() {
    _mounted = true;
    state._element = this;
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
  void update(ProviderBase<Created, Listened> newProvider) {
    _provider = newProvider;
  }

  void markMustRecomputeState() {
    if (_mustRecomputeState) return;

    _mustRecomputeState = true;
    _runOnDispose();
    _container._scheduler.scheduleProviderRefresh(this);
  }

  void _maybeRebuildState() {
    if (_mustRecomputeState) {
      _previousDependencies = _dependencies;
      _dependencies = HashMap();

      _buildState();

      // Unsubscribe to everything that a provider no-longer depends on.
      for (final sub in _previousDependencies!.entries) {
        // TODO(rrousselGit) refactor
        sub.key._dependents.remove(this);
      }
      _previousDependencies = null;
      _mustRecomputeState = false;
    }
  }

  void _notifyListeners() {
    final newValue = state._exposedValue as Listened;
    for (final listener in _listeners) {
      listener(newValue);
    }
    for (final dependent in _dependents) {
      dependent._didChangeDependency();
    }
  }

  void _didChangeDependency() {
    if (_mustRecomputeState) return;

    markMustRecomputeState();
  }

  bool _debugAssertCanDependOn(ProviderBase provider) {
    assert(() {
      final queue = Queue<ProviderElement>.from(_dependents);

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
  T read<T>(RootProvider<Object?, T> provider) {
    assert(_debugAssertCanDependOn(provider), '');
    return _container.read(provider);
  }

  @override
  T watch<T>(ProviderBase<Object?, T> provider) {
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
  Listened getExposedValue() {
    _maybeRebuildState();

    if (_exception != null) {
      throw _exception!;
    }
    return state._exposedValue as Listened;
  }

  @protected
  void _buildState() {
    final previous = state._createdValue;
    ProviderElement? debugPreviouslyBuildingElement;
    assert(() {
      debugPreviouslyBuildingElement = _debugCurrentlyBuildingElement;
      _debugCurrentlyBuildingElement = this;
      return true;
    }(), '');

    try {
      state._createdValue = _provider.create(this);
      state.valueChanged(previous: previous);
    } catch (err, stack) {
      if (!state.handleError(err, stack)) {
        _exception = ProviderException._(err, stack, _provider);
      }
    } finally {
      assert(() {
        _debugCurrentlyBuildingElement = debugPreviouslyBuildingElement;
        return true;
      }(), '');
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
    state.dispose();

    for (final sub in _dependencies.entries) {
      sub.key._dependents.remove(this);
      sub.key.mayNeedDispose();
    }
    _dependencies.clear();

    for (final observer in _container._observers) {
      _runUnaryGuarded(
        observer.didDisposeProvider,
        _origin,
      );
    }

    _listeners.clear();
  }

  /// Life-cycle for when a listener is removed.
  ///
  /// See also:
  ///
  /// - [AutoDisposeProviderElement], which overrides this method to destroy the
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
    _onDisposeListeners?.forEach(_runGuarded);
    _onDisposeListeners = null;
  }
}

/// The internal state of a provider
abstract class ProviderStateBase<Created, Listened> {
  /// The [ProviderReference] associated with this provider.
  ProviderReference get ref => _element;
  late ProviderElement<Created, Listened> _element;

  /// The last value that was created by a provider.
  ///
  /// May change over time, in which case [valueChanged] will be called with the
  /// previous value.
  Created get createdValue => _createdValue as Created;
  Created? _createdValue;

  /// The value currently exposed by the provider.
  ///
  /// Modifying this value after the first time will notify listeners
  /// that the exposed value changed.
  ///
  /// Must be set during [valueChanged].
  Listened? get exposedValue => _exposedValue;
  Listened? _exposedValue;

  set exposedValue(Listened? exposedValue) {
    // TODO(rrousselGit) remove this assert
    assert(
      exposedValue is Listened,
      'A provider tried to assign `null` to a non-nullable `exposedValue`',
    );
    _exposedValue = exposedValue;
    _element._notifyListeners();
  }

  /// Creates the value exposed by a provider from the value created.
  ///
  /// May be called again when one of the dependency listened by the provider
  /// changed, in which case the previous [createdValue] is passed as `previous`.
  ///
  /// On first call, **must** set [exposedValue].
  @protected
  void valueChanged({Created? previous});

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

@protected
mixin ProviderOverridesMixin<Created, Listened>
    on AlwaysAliveProviderBase<Created, Listened> {
  /// Overrides the behavior of a provider with a value.
  ///
  /// {@macro riverpod.overideWith}
  Override overrideWithValue(Listened value) {
    return ProviderOverride(
      ValueProvider<Object?, Listened>((ref) => value, value),
      this,
    );
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
  // Cannot be overridden by AutoDisposeProviders
  ProviderOverride overrideWithProvider(
    AlwaysAliveProviderBase<Object?, Listened> provider,
  ) {
    return ProviderOverride(provider, this);
  }
}

@protected
mixin AutoDisposeProviderOverridesMixin<Created, Listened>
    on AutoDisposeProviderBase<Created, Listened> {
  /// Overrides the behavior of a provider with a value.
  ///
  /// {@macro riverpod.overideWith}
  Override overrideWithValue(Listened value) {
    return ProviderOverride(
      ValueProvider<Object?, Listened>((ref) => value, value),
      this,
    );
  }

  /// Overrides the behavior of this provider with another provider.
  ///
  /// {@macro riverpod.overideWith}
  ProviderOverride overrideWithProvider(
    AutoDisposeProviderBase<Object?, Listened> provider,
  ) {
    return ProviderOverride(provider, this);
  }
}
