import 'package:collection/collection.dart';

import 'framework/framework.dart';
import 'internals.dart';

typedef Reader = Res Function<Res>(ProviderBase<ProviderBaseSubscription, Res>);

/// Does not notify dependents if the value returned didn't change.
///
/// DON'T do trigger side-effects such as http requests inside [Computed].
/// [Computed] does not guanrantee that the function won't be re-evaluated
/// even if the inputs didn't change.
class Computed<T> extends ProviderBase<ProviderBaseSubscription, T> {
  Computed(this._selector);

  final T Function(Reader read) _selector;

  @override
  _ComputedState<T> createState() {
    return _ComputedState<T>();
  }
}

class _ComputedState<T>
    extends ProviderBaseState<ProviderBaseSubscription, T, Computed<T>> {
  final _subscritionsCache = <ProviderBase, _Subscription>{};
  var _shouldCompute = true;
  bool _debugSelecting;

  @override
  T state;

  @override
  ProviderBaseSubscription createProviderSubscription() {
    return ProviderBaseSubscriptionImpl();
  }

  @override
  void initState() {
    assert(() {
      _debugSelecting = true;
      return true;
    }(), '');
    try {
      state = provider._selector(_reader);
    } finally {
      assert(() {
        _debugSelecting = false;
        return true;
      }(), '');
    }
  }

  @override
  void notifyListeners() {
    if (_shouldCompute) {
      _shouldCompute = false;

      assert(() {
        _debugSelecting = true;
        return true;
      }(), '');
      T newState;
      try {
        newState = provider._selector(_reader);
      } finally {
        assert(() {
          _debugSelecting = false;
          return true;
        }(), '');
      }
      if (!const DeepCollectionEquality().equals(newState, state)) {
        state = newState;
        super.notifyListeners();
      }
    }
  }

  Res _reader<Res>(ProviderBase<ProviderBaseSubscription, Res> target) {
    assert(
      _debugSelecting,
      'Cannot `read` outside of the body of the Computed callback',
    );
    return _subscritionsCache.putIfAbsent(target, () {
      final state = owner.readProviderState(target);
      redepthAfter(state);

      final sub = _Subscription();
      sub._removeListener = state.$addListener(
        (value) {
          sub._state = value;
          _shouldCompute = true;
          markNeedsNotifyListeners();
        },
      );
      return sub;
    })._state as Res;
  }

  @override
  void dispose() {
    for (final subscription in _subscritionsCache.values) {
      subscription._removeListener();
    }
    super.dispose();
  }
}

class _Subscription {
  VoidCallback _removeListener;
  Object _state;
}
