import 'dart:async';
import 'dart:collection';
import 'dart:math';

import 'package:meta/meta.dart';

import '../common.dart';
import '../computed.dart';
import '../internals.dart';
import '../provider.dart';

part 'base_provider.dart';

// ignore: avoid_private_typedef_functions
typedef _FallbackProviderStateReader = ProviderStateBase<
        ProviderSubscriptionBase, T, ProviderBase<ProviderSubscriptionBase, T>>
    Function<T>(
  ProviderBase<ProviderSubscriptionBase, T>,
);

class _LinkedListEntry<T> extends LinkedListEntry<_LinkedListEntry<T>> {
  _LinkedListEntry(this.value);
  final T value;
}

class _ProviderStateReader {
  _ProviderStateReader(this._origin, this._owner);

  final ProviderBase _origin;
  final ProviderStateOwner _owner;
  ProviderStateBase _providerState;

  ProviderStateBase read() {
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
      _providerState._providerStateDependencies.isEmpty,
      'Cannot add dependencies before `initState`',
    );
    // Insert the new state in the beginning of the sorted by depth list,
    // because the provider doesn't have any depth yet.
    // The insertion must be done before initState so that dependOn calls
    // inside initState works.
    _owner._providerStatesSortedByDepth.addFirst(
      _providerState._stateEntryInSortedStateList,
    );

    // An initState may be called inside another initState, so we can't reset
    // the flag to null and instead reset the flag to the previously building state.
    final previousLock = notifyListenersLock;
    notifyListenersLock = _providerState;
    try {
      // the state position in _providerStatesSortedByDepth will get updated as
      // dependOn is called.
      _providerState.initState();
    } catch (err) {
      _providerState._error = err;
      rethrow;
    } finally {
      notifyListenersLock = previousLock;
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

/// A flag for checking against invalid operations inside
/// [ProviderStateBase.initState] and [ProviderStateBase.dispose].
///
/// This prevents modifying other providers while inside these life-cycles.
@visibleForTesting
ProviderStateBase notifyListenersLock;

/// A flag for checking against invalid operations inside [ProviderStateBase.notifyListeners].
///
/// This prevents modifying providers that already notified their listener in
/// the current frame.
@visibleForTesting
int notifyListenersDepthLock = -1;

/// Do not implement, only extend
abstract class ProviderStateOwnerObserver {
  void didAddProvider(ProviderBase provider, Object value) {}

  void didUpdateProviders(Map<ProviderBase, Object> changes) {}

  void didDisposeProvider(ProviderBase provider) {}
}

/// Implementation detail for [ProviderStateOwner.ref].
final _refProvider = Provider((c) => c);

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
      }).read() as ProviderStateBase<ProviderSubscriptionBase, T,
          ProviderBase<ProviderSubscriptionBase, T>>;
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
      LinkedList<_LinkedListEntry<ProviderStateBase>>();
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

  // TODO: should _redepth be optimized for this use-case? As `ref` can safely always
  // be the last provider in the list of providers per depth
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

    assert(notifyListenersLock == null, '');
    // TODO: reverse?
    for (final entry in _providerStatesSortedByDepth) {
      notifyListenersLock = entry.value;
      _runGuarded(entry.value.dispose);
      notifyListenersLock = null;
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
    for (final entry in _providerStatesSortedByDepth) {
      if (entry.value._dirty) {
        entry.value._dirty = false;
        notifyListenersDepthLock = entry.value.depth;
        try {
          entry.value.notifyListeners();
        } finally {
          notifyListenersDepthLock = -1;
        }
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

  ProviderStateBase<Subscription, ListeningValue,
          ProviderBase<Subscription, ListeningValue>>
      _readProviderState<Subscription extends ProviderSubscriptionBase,
          ListeningValue>(
    ProviderBase<Subscription, ListeningValue> provider,
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
      }).read() as ProviderStateBase<Subscription, ListeningValue,
          ProviderBase<Subscription, ListeningValue>>;
    } else {
      return (_stateReaders[provider]?.read() ?? _fallback(provider))
          as ProviderStateBase<Subscription, ListeningValue,
              ProviderBase<Subscription, ListeningValue>>;
    }
  }
}

@visibleForTesting
extension ProviderStateOwnerInternals on ProviderStateOwner {
  @visibleForTesting
  List<ProviderStateBase> get debugProviderStateSortedByDepth {
    List<ProviderStateBase> result;
    assert(() {
      result = _providerStatesSortedByDepth.map((e) => e.value).toList();
      return true;
    }(), '');
    return result;
  }

  void scheduleNotification() => _scheduleNotification();

  ProviderStateBase<Subscription, ListeningValue,
          ProviderBase<Subscription, ListeningValue>>
      readProviderState<Subscription extends ProviderSubscriptionBase,
          ListeningValue>(
    ProviderBase<Subscription, ListeningValue> provider,
  ) {
    return _readProviderState(provider);
  }
}

/// An object used by [ProviderStateOwner] to override the behavior of a provider
/// for a part of the application.
///
/// Do not implement/extend this class.
///
/// See also:
///
/// - [ProviderStateOwner], which uses this object.
/// - [AlwaysAliveProvider.overrideForSubtree], which creates a [ProviderOverride].
class ProviderOverride {
  ProviderOverride._(this._provider, this._origin);

  final ProviderBase _origin;
  final ProviderBase _provider;
}

abstract class ProviderSubscriptionBase {
  @protected
  void dispose() {}
}

class ProviderBaseSubscriptionImpl extends ProviderSubscriptionBase {}

/// An error thrown when a call to [ProviderReference.dependOn] leads
/// to a provider depending on itself.
///
/// Circular dependencies are both not supported for performance reasons
/// and maintainability reasons.
/// Consider reading about uni-directional data-flow to learn about the
/// benefits of avoiding circular dependencies.
class CircularDependencyError extends Error {
  CircularDependencyError._();
}

/// An object used by providers to interact with other providers and the life-cycles
/// of the application.
///
/// See also:
/// - [dependOn], a method that allows a provider to consume other providers.
/// - [mounted], an utility to know whether the provider is still "alive" or not.
/// - [onDispose], a method that allows performing a task when the provider is destroyed.
/// - [Provider], an example of a provider that uses [ProviderReference].
/// - [ProviderStateOwner.ref], an easy way of obtaining a [ProviderReference].
class ProviderReference {
  // DO NOT USE, for internal usages only.
  ProviderReference(this._providerState);

  final ProviderStateBase _providerState;

  /// An utility to know if a provider was destroyed or not.
  ///
  /// This is useful when dealing with asynchronous operations, as the provider
  /// may have potentially be destroyed before the end of the asyncronous operation.
  /// In that case, we may want to stop performing further tasks.
  bool get mounted => _providerState.mounted;

  /// Adds a listener to perform an operation right before the provider is destroyed.
  ///
  /// See also:
  ///
  /// - [ProviderStateOwner.dispose], which will destroy providers.
  void onDispose(VoidCallback cb) {
    _providerState.onDispose(cb);
  }

  /// Obtain another provider.
  ///
  /// The first time this method is called for a given provider can be expensive,
  /// as it involves modifying the internal graph of providers (which is O(N))
  /// and potentially mounting the provider if it wasn't before.
  ///
  /// It is safe to call [dependOn] multiple times with the same provider
  /// as parameter and is inexpensive to do so.
  ///
  /// See also:
  ///
  /// - [Provider], explains in further detail how to use this method.
  T dependOn<T extends ProviderSubscriptionBase>(
    ProviderBase<T, Object> provider,
  ) {
    return _providerState.dependOn(provider);
  }
}
