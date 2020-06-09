import 'package:collection/collection.dart';

import 'framework/framework.dart';
import 'internals.dart';

/// A function used by [Computed] to read other providers.
///
/// By calling this function, it "binds" the [Computed] to the provider obtained.
typedef Reader = Res Function<Res>(ProviderBase<ProviderSubscriptionBase, Res>);

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
class Computed<T> extends ProviderBase<ProviderSubscriptionBase, T> {
  /// Creates a [Computed] and allows specifying a [name].
  Computed(this._selector, {String name}) : super(name);

  final T Function(Reader read) _selector;

  @override
  _ComputedState<T> createState() {
    return _ComputedState<T>();
  }
}

class _ComputedState<T>
    extends ProviderStateBase<ProviderSubscriptionBase, T, Computed<T>> {
  final _subscritionsCache = <ProviderBase, _Dependency>{};
  var _shouldCompute = false;
  bool _debugSelecting;

  @override
  ProviderSubscriptionBase createProviderSubscription() {
    return ProviderBaseSubscriptionImpl();
  }

  @override
  bool shouldNotifyListeners() {
    for (final sub in _subscritionsCache.values) {
      sub.subscription.flush();
    }
    return _shouldCompute;
  }

  @override
  T compute() {
    assert(() {
      _debugSelecting = true;
      return true;
    }(), '');
    try {
      // TODO what if there's an exception inside selector?
      return provider._selector(_reader);
    } finally {
      assert(() {
        _debugSelecting = false;
        return true;
      }(), '');
    }
  }

  Res _reader<Res>(ProviderBase<ProviderSubscriptionBase, Res> target) {
    assert(
      _debugSelecting,
      'Cannot use `read` outside of the body of the Computed callback',
    );
    return _subscritionsCache.putIfAbsent(target, () {
      final state = owner.readProviderState(target);
      redepthAfter(state);

      final dep = _Dependency();
      dep.subscription = state.addLazyListener(
        mayHaveChanged: markMayHaveChanged,
        onChange: (value) {
          dep._state = value;
          _shouldCompute = true;
        },
      );
      return dep;
    })._state as Res;
  }

  @override
  void dispose() {
    for (final subscription in _subscritionsCache.values) {
      subscription.subscription.close();
    }
    super.dispose();
  }
}

class _Dependency {
  LazySubscription subscription;
  Object _state;
}
