import 'dart:async';
import 'dart:collection';
import 'dart:math';

import 'package:meta/meta.dart';

import '../common.dart';
import '../computed.dart';
import '../provider.dart';

part 'base_provider.dart';

typedef OnError = void Function(dynamic error, StackTrace stackTrace);

// ignore: avoid_private_typedef_functions
typedef _FallbackProviderStateReader = ProviderBaseState<
        ProviderBaseSubscription, T, ProviderBase<ProviderBaseSubscription, T>>
    Function<T>(
  ProviderBase<ProviderBaseSubscription, T>,
);

final _refProvider = Provider((c) => c);

class _ProviderStateReader {
  _ProviderStateReader(this._origin, this._owner);

  final ProviderBase _origin;
  final ProviderStateOwner _owner;
  ProviderBaseState _providerState;

  ProviderBaseState read() {
    if (_providerState != null) {
      if (_providerState._error != null) {
        // ignore: only_throw_errors, this is what was throws by initState so it is valid to rethrow it
        throw _providerState._error;
      }
      return _providerState;
    }
    final override = _owner._overrideForProvider[_origin] ?? _origin;

    _providerState = override.createState()
      .._origin = _origin
      .._provider = override
      .._owner = _owner;

    assert(
      _providerState._dependenciesState.isEmpty,
      'Cannot add dependencies before `initState`',
    );
    // Insert the new state in the beginning of the sorted by depth list,
    // because the provider doesn't have any depth yet.
    // The insertion must be done before initState so that dependOn calls
    // inside initState works.
    _owner._providerStatesSortedByDepth.addFirst(
      _providerState._stateEntryInSortedStateList,
    );
    try {
      // the state position in _providerStatesSortedByDepth will get updated as
      // dependOn is called.
      _providerState.initState();
    } catch (err) {
      _providerState._error = err;
      rethrow;
    } finally {
      // ignore calls to markNeedNotifyListeners inside initState
      _providerState._dirty = false;
    }

    if (_owner._observers != null) {
      for (final observer in _owner._observers) {
        _runBinaryGuarded(
          observer.didAddProvider,
          _origin,
          _providerState.state,
        );
      }
    }

    return _providerState;
  }
}

void _runGuarded(void Function() cb) {
  try {
    cb();
  } catch (err, stack) {
    Zone.current.handleUncaughtError(err, stack);
  }
}

void _runUnaryGuarded<T>(void Function(T) cb, T value) {
  try {
    cb(value);
  } catch (err, stack) {
    Zone.current.handleUncaughtError(err, stack);
  }
}

void _runBinaryGuarded<A, B>(void Function(A, B) cb, A value, B value2) {
  try {
    cb(value, value2);
  } catch (err, stack) {
    Zone.current.handleUncaughtError(err, stack);
  }
}

/// Do not implement, only extend
abstract class ProviderStateOwnerObserver {
  void didAddProvider(ProviderBase provider, Object value) {}

  void didUpdateProviders(Map<ProviderBase, Object> changes) {}

  void didDisposeProvider(ProviderBase provider) {}
}

class ProviderStateOwner {
  ProviderStateOwner({
    ProviderStateOwner parent,
    List<ProviderOverride> overrides = const [],
    VoidCallback markNeedsUpdate,
    List<ProviderStateOwnerObserver> observers,
  })  : _markNeedsUpdate = markNeedsUpdate,
        _observers = observers {
    assert(() {
      _debugOverrides = overrides;
      return true;
    }(), '');

    _fallback = parent?._fallback;
    _fallback ??= <T>(provider) {
      // It's fine to add new keys to _stateReaders inside fallback
      // as in this situation, there is no "parent" owner.s
      return _stateReaders.putIfAbsent(provider, () {
        return _ProviderStateReader(provider, this);
      }).read() as ProviderBaseState<ProviderBaseSubscription, T,
          ProviderBase<ProviderBaseSubscription, T>>;
    };

    for (final override in overrides) {
      _overrideForProvider[override._origin] = override._provider;
    }

    _stateReaders = {
      ...?parent?._stateReaders,
      _refProvider: _ProviderStateReader(_refProvider, this),
      for (final override in overrides)
        override._origin: _ProviderStateReader(
          override._origin,
          this,
        ),
    };
  }

  final List<ProviderStateOwnerObserver> _observers;
  final VoidCallback _markNeedsUpdate;
  List<ProviderOverride> _debugOverrides;
  final _overrideForProvider = <ProviderBase, ProviderBase>{};
  final _providerStatesSortedByDepth =
      LinkedList<_LinkedListEntry<ProviderBaseState>>();
  Map<ProviderBase, _ProviderStateReader> _stateReaders;
  bool _disposed = false;

  /// The state of `Computed` providers
  ///
  /// It is not stored inside [_stateReaders] as `Computed` are always
  /// in the deepest [ProviderStateOwner] possible.
  Map<Computed, _ProviderStateReader> _computedStateReaders;
  _FallbackProviderStateReader _fallback;
  var _updateScheduled = false;

  /// All the providers that changed and their new value
  ///
  /// This property is an implementation detail of [ProviderStateOwnerObserver.didUpdateProviders].
  Map<ProviderBase, Object> _providerChanges;

  ProviderReference get ref => _refProvider.readOwner(this);

  Map<ProviderBase, Object> get debugProviderStates {
    Map<ProviderBase, Object> res;
    assert(() {
      res = {
        for (final entry in _stateReaders.entries)
          if (entry.value._providerState != null)
            entry.key: entry.value._providerState.state,
      };

      return true;
    }(), '');
    return res;
  }

  void update([List<ProviderOverride> overrides]) {
    if (_disposed) {
      throw StateError(
        'Called update on a ProviderStateOwner that was already disposed',
      );
    }
    if (overrides != null) {
      assert(() {
        final oldOverrides = _debugOverrides;
        _debugOverrides = overrides;

        if (overrides.length != oldOverrides.length) {
          throw UnsupportedError(
            'Adding or removing provider overrides is not supported',
          );
        }

        for (var i = 0; i < overrides.length; i++) {
          final previous = oldOverrides[i];
          final next = overrides[i];

          if (previous._provider.runtimeType != next._provider.runtimeType) {
            throw UnsupportedError('''
Replaced the override at index $i of type ${previous._provider.runtimeType} with an override of type ${next._provider.runtimeType}, which is different.
Changing the kind of override or reordering overrides is not supported.
''');
          }

          if (previous._origin != next._origin) {
            throw UnsupportedError(
              'The provider overriden at the index $i changed, which is unsupported.',
            );
          }
        }

        return true;
      }(), '');

      for (final override in overrides) {
        _overrideForProvider[override._origin] = override._provider;

        assert(
          override._origin is! Computed && override._provider is! Computed,
          'Cannot override Computed',
        );
        // no need to check _computedStateReaders as they are not overridable
        final state = _stateReaders[override._origin]
            // _providerState instead of read() to not compute the state
            ._providerState;
        if (state == null) {
          continue;
        }
        final oldProvider = state._provider;
        state._provider = override._provider;
        _runUnaryGuarded(state.didUpdateProvider, oldProvider);
      }
    }

    _notifyListeners();
  }

  void dispose() {
    if (_disposed) {
      throw StateError(
        'Called disposed on a ProviderStateOwner that was already disposed',
      );
    }
    _disposed = true;

    // TODO: reverse?
    for (final entry in _providerStatesSortedByDepth) {
      _runGuarded(entry.value.dispose);
    }
  }

  void _scheduleNotification() {
    if (_disposed) {
      throw StateError(
        'Tried to emit updates from a ProviderStateOwner that was already disposed',
      );
    }
    if (!_updateScheduled) {
      _updateScheduled = true;
      _markNeedsUpdate?.call();
    }
  }

  void _notifyListeners() {
    // TODO: can't dirty nodes that were already traversed
    for (final entry in _providerStatesSortedByDepth) {
      if (entry.value._dirty) {
        entry.value
          .._dirty = false
          ..notifyListeners();
      }
    }
    if (_providerChanges != null) {
      if (_observers != null) {
        final changes = UnmodifiableMapView(_providerChanges);
        for (final observer in _observers) {
          _runUnaryGuarded(
            observer.didUpdateProviders,
            changes,
          );
        }
      }
      _providerChanges = null;
    }
    _updateScheduled = false;
  }

  void _reportChanged(ProviderBase origin, Object state) {
    if (_observers != null && _observers.isNotEmpty) {
      _providerChanges ??= {};
      _providerChanges[origin] = state;
    }
  }

  ProviderBaseState<CombiningValue, ListeningValue,
          ProviderBase<CombiningValue, ListeningValue>>
      _readProviderState<CombiningValue extends ProviderBaseSubscription,
          ListeningValue>(
    ProviderBase<CombiningValue, ListeningValue> provider,
  ) {
    if (_disposed) {
      throw StateError(
        'Tried to read a provider from a ProviderStateOwner that was already disposed',
      );
    }
    if (provider is Computed) {
      _computedStateReaders ??= {};
      return _computedStateReaders.putIfAbsent(provider as Computed, () {
        return _ProviderStateReader(provider, this);
      }).read() as ProviderBaseState<CombiningValue, ListeningValue,
          ProviderBase<CombiningValue, ListeningValue>>;
    } else {
      return (_stateReaders[provider]?.read() ?? _fallback(provider))
          as ProviderBaseState<CombiningValue, ListeningValue,
              ProviderBase<CombiningValue, ListeningValue>>;
    }
  }
}

@visibleForTesting
extension DebugProviderStateOwner on ProviderStateOwner {
  @visibleForTesting
  List<ProviderBaseState> get debugProviderStatedSortedByDepth {
    List<ProviderBaseState> result;
    assert(() {
      result = _providerStatesSortedByDepth.map((e) => e.value).toList();
      return true;
    }(), '');
    return result;
  }

  void scheduleNotification() => _scheduleNotification();
}

@visibleForTesting
extension ReadProviderState on ProviderStateOwner {
  ProviderBaseState<CombiningValue, ListeningValue,
          ProviderBase<CombiningValue, ListeningValue>>
      readProviderState<CombiningValue extends ProviderBaseSubscription,
          ListeningValue>(
    ProviderBase<CombiningValue, ListeningValue> provider,
  ) {
    return _readProviderState(provider);
  }
}

class ProviderOverride {
  ProviderOverride._(this._provider, this._origin);

  final ProviderBase _origin;
  final ProviderBase _provider;
}

abstract class ProviderBaseSubscription {
  @protected
  void dispose() {}
}

class ProviderBaseSubscriptionImpl extends ProviderBaseSubscription {}

/// A provider is somehow dependending on itself
class CircularDependencyError extends Error {
  CircularDependencyError._();
}

class ProviderReference {
  ProviderReference(this._providerState);

  final ProviderBaseState _providerState;

  bool get mounted => _providerState.mounted;

  void onDispose(VoidCallback cb) {
    _providerState.onDispose(cb);
  }

  T dependOn<T extends ProviderBaseSubscription>(
    ProviderBase<T, Object> provider,
  ) {
    return _providerState.dependOn(provider);
  }
}
