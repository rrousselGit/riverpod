part of 'framework.dart';

/// A function used by [Computed] to read other providers.
///
/// By calling this function, it "binds" the [Computed] to the provider obtained.
typedef Reader = Res Function<Res>(ProviderBase<ProviderDependencyBase, Res>);

/// A provider that combines other providers into an immutable value and
/// cache its result.
///
/// [Computed] is typically used like so:
///
/// ```dart
/// final userProvider = StreamProvider<User>(...);
/// final todoListProvider = StateNotifierProvider<TodoList>(...);
///
/// final greetingProvider = Computed((read) {
///   // Uses `read` to obtain the user from `userProvider`.
///   AsyncData<User> user = read(userProvider).data;
///   // If the user is loading/in error, show a fallback string
///   if (user == null) {
///     return '...';
///   }
///   // Obtains TodoList from todoListProvider
///   TodoList todoList = read(todoListProvider);
///
///   // combine TodoList and the user together to make a heading
///   return 'Hello ${user.value.name}! You gave ${todoList.count} todos';
/// });
/// ```
///
/// Such usage of [Computed] will automatically update the created value
/// whenever either the user changes or the list of todos is updated.
///
/// Using [Computed] brings two benefits:
///
/// - The value is cached.
///   Even if we read [Computed] multiple times, the function will be evaluated
///   only once (unless a dependency changed, like a new user is emitted or todos are added).
///
/// - If the function is re-evaluated but the result did not change,
///   then dependents are not notified.
///
///   In the context of Flutter, this means that Widgets can safely use
///   [Computed] to filter rebuilds.
///
/// **DON'T* trigger side-effects such as http requests inside [Computed].
/// [Computed] does not guanrantee that the function won't be re-evaluated
/// even if the inputs didn't change.
class Computed<T> extends AutoDisposeProviderBase<ProviderDependencyBase, T> {
  /// Creates a [Computed] and allows specifying a [name].
  Computed(this._selector, {String name}) : super(name);

  final T Function(Reader read) _selector;

  @override
  _ComputedState<T> createState() {
    return _ComputedState<T>();
  }
}

class _ComputedState<T> extends AutoDisposeProviderStateBase<
    ProviderDependencyBase, T, Computed<T>> {
  var _dependencies = <ProviderBase, _Dependency>{};
  Map<ProviderBase, _Dependency> _oldDependencies;
  bool _debugSelecting;

  T _state;
  @override
  T get state => _state;

  @override
  ProviderDependencyBase createProviderDependency() {
    return ProviderBaseDependencyImpl();
  }

  @override
  void initState() {
    // force initial computation
    _state = _compute();
  }

  @override
  void flush() {
    var dependencyDidUpdate = false;
    for (final dep in _dependencies.values) {
      if (dep.subscription.flush()) {
        dependencyDidUpdate = true;
      }
    }
    if (dependencyDidUpdate) {
      final newState = _compute();
      if (!const DeepCollectionEquality().equals(_state, newState)) {
        _state = newState;
        notifyChanged();
      }
    }
  }

  T _compute() {
    assert(() {
      _debugSelecting = true;
      return true;
    }(), '');
    try {
      notifyListenersLock = this;
      _oldDependencies = _dependencies;
      _dependencies = {};
      // TODO what if there's an exception inside selector?
      return provider._selector(_reader);
    } finally {
      notifyListenersLock = null;
      assert(() {
        _debugSelecting = false;
        return true;
      }(), '');
      for (final dep in _oldDependencies.values) {
        dep.subscription.close();
      }
      _oldDependencies = null;
    }
  }

  Res _reader<Res>(ProviderBase<ProviderDependencyBase, Res> target) {
    assert(
      _debugSelecting,
      'Cannot use `read` outside of the body of the Computed callback',
    );
    return _dependencies.putIfAbsent(target, () {
      final oldDependency = _oldDependencies?.remove(target);

      if (oldDependency != null) {
        return oldDependency;
      }

      final state = owner._readProviderState(target);

      final dep = _Dependency();
      dep.subscription = state.addLazyListener(
        mayHaveChanged: markMayHaveChanged,
        onChange: (value) => dep._state = value,
      );
      return dep;
    })._state as Res;
  }

  @override
  void dispose() {
    for (final subscription in _dependencies.values) {
      subscription.subscription.close();
    }
    super.dispose();
  }
}

class _Dependency {
  ProviderSubscription subscription;
  Object _state;
}

/// Creates a group of [Computed] that depends on external parameters
class ComputedFamily<Result, A> extends Family<Computed<Result>, A> {
  /// Creates a group of [Computed] that depends on external parameters
  ComputedFamily(Result Function(Reader read, A a) create)
      : super((a) => Computed((read) => create(read, a)));
}
