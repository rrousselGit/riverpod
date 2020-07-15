import 'dart:async';
import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:meta/meta.dart';

import '../common.dart';
import '../internals.dart';
import '../provider/provider.dart';

part 'computed.dart';
part 'base_provider.dart';
part 'family.dart';
part 'auto_dispose.dart';

// ignore: avoid_private_typedef_functions
typedef _FallbackProviderStateReader = ProviderStateBase<ProviderDependencyBase,
        T, ProviderBase<ProviderDependencyBase, T>>
    Function<T>(
  ProviderBase<ProviderDependencyBase, T>,
);

class _LinkedListEntry<T> extends LinkedListEntry<_LinkedListEntry<T>> {
  _LinkedListEntry(this.value);
  final T value;
}

/// A utility to read (an potentially initialize) the state of a provider.
class _ProviderStateReader {
  _ProviderStateReader(this._origin, this._owner);

  final ProviderBase _origin;
  final ProviderContainer _owner;
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

    // An initState may be called inside another initState, so we can't reset
    // the flag to null and instead reset the flag to the previously building state.
    final previousLock = notifyListenersLock;
    notifyListenersLock = _providerState;
    try {
      // the state position in _providerStatesSortedByDepth will get updated as
      // read is called.
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

/// A flag for checking against invalid operations inside [ProviderStateBase.markMayHaveChanged].
///
/// This prevents modifying providers that already notified their listener in
/// the current frame.
///
/// Negative when nothing is locked.
@visibleForTesting
int debugNotifyListenersDepthLock = -1;

/// An object that listens to the changes of a [ProviderContainer].
///
/// This can be used for logging, making devtools, or saving the state
/// for offline support.
abstract class ProviderObserver {
  /// A provider was initialized, and the value created is [value].
  void didAddProvider(ProviderBase provider, Object value) {}

  /// Called my providers when they emit a notification.
  void didUpdateProvider(ProviderBase provider, Object newValue) {}

  /// A provider was disposed
  void didDisposeProvider(ProviderBase provider) {}
}

/// Implementation detail for [ProviderContainer.ref].
final _refProvider = Provider((c) => c);

/// The object that manages the state of all providers.
///
/// If you are using Flutter, you do not need to care about this object as
/// `ProviderScope` manages it for you.
///
/// The state of a provider is not stored inside the provider, but instead
/// inside [ProviderContainer].
///
/// By using [ProviderContainer], it is possible to override the behavior
/// of a provider, by specifying `overrides`.
///
/// See also:
///
/// - [Provider], a basic implementation of a provider.
class ProviderContainer {
  /// Creates a [ProviderContainer] and allows specifying provider overrides.
  ProviderContainer({
    ProviderContainer parent,
    List<Override> overrides = const [],
    List<ProviderObserver> observers,
  })  : _debugOverrides = overrides,
        _observers = observers {
    _fallback = parent?._fallback;
    _fallback ??= <T>(provider) {
      // It's fine to add new keys to _stateReaders inside fallback
      // as in this situation, there is no "parent" owner.s
      return _stateReaders.putIfAbsent(provider, () {
        return _ProviderStateReader(provider, this);
      }).read() as ProviderStateBase<ProviderDependencyBase, T,
          ProviderBase<ProviderDependencyBase, T>>;
    };

    final overridenFamilies = <Family>{};
    final overridenProviders = <ProviderBase>{};

    for (final override in overrides) {
      if (override is ProviderOverride) {
        _overrideForProvider[override._origin] = override._provider;
        overridenProviders.add(override._origin);
      } else if (override is FamilyOverride) {
        _overrideForFamily[override._family] = override;
        overridenFamilies.add(override._family);
      }
    }

    bool isLocallyOverriden(ProviderBase provider) {
      if (overridenFamilies.contains(provider._family)) {
        return true;
      }
      if (overridenProviders.contains(provider)) {
        return true;
      }
      // TODO find a way to simplify this
      if (provider is StateNotifierStateProvider &&
          overridenProviders.contains(provider.notifierProvider)) {
        return true;
      }
      if (provider is AutoDisposeStateNotifierStateProvider &&
          overridenProviders.contains(provider.notifierProvider)) {
        return true;
      }
      return false;
    }

    _stateReaders = {
      /// Imports [_ProviderStateReader]s from the parent, but exclude locally
      /// overriden families.
      if (parent != null)
        for (final entry in parent._stateReaders.entries)
          if (!isLocallyOverriden(entry.key)) entry.key: entry.value,
      _refProvider: _ProviderStateReader(_refProvider, this),
      for (final override in overrides)
        // Only applies provider overrides. Family overrides are applied on read
        if (override is ProviderOverride)
          override._origin: _ProviderStateReader(
            override._origin,
            this,
          ),
    };
  }

  final List<ProviderObserver> _observers;

  /// The currently overriden providers.
  ///
  /// New keys cannot be added after creation, unless this [ProviderContainer]
  /// does not have a `parent`.
  /// Upating existing keys is possible.
  final _overrideForProvider = <ProviderBase, ProviderBase>{};

  final _overrideForFamily = <Family, FamilyOverride>{};

  /// The state of all providers. Reading a provider is O(1).
  Map<ProviderBase, _ProviderStateReader> _stateReaders;

  /// The state of `Computed` providers
  ///
  /// It is not stored inside [_stateReaders] as `Computed` are always
  /// in the deepest [ProviderContainer] possible.
  Map<Computed, _ProviderStateReader> _computedStateReaders;

  /// When attempting to read a provider, a provider may not be registered
  /// inside [_stateReaders] with a [_ProviderStateReader].
  /// In that situation, [_fallback] is called and will handle register the
  /// provider accordingly.
  ///
  /// This is typically done only when [ProviderContainer] has not `parent`.
  _FallbackProviderStateReader _fallback;

  /// Whether [dispose] was called or not.
  ///
  /// This disables the different methods of [ProviderContainer], resulting in
  /// a [StateError] when attempting to use them.
  bool _disposed = false;

  List<Override> _debugOverrides;

  /// An utility to easily obtain a [ProviderReference] from a [ProviderContainer].
  ///
  /// This is equivalent to:
  ///
  /// ```dart
  /// final refProvider = Provider((ref) => ref);
  /// final owner = ProviderStateOwnrr(parent: ..., overrides: [refProvider]);
  ///
  /// final re = refProvider.readOwner(owner);
  /// ```
  ProviderReference get ref => _refProvider.readOwner(this);

  /// Updates the list of provider overrides.
  ///
  /// It is not possible, to remove or add new overrides.
  ///
  /// What this means is, if [ProviderContainer] was created with 3 overrides,
  /// calls to [updateOverrides] that tries to change the list of overrides must
  /// override these 3 exact providers again, in the same order.
  ///
  /// As an example, consider:
  ///
  /// ```dart
  /// final provider1 = FutureProvider((_) async => 'Hello');
  /// final provider2 = Provider((_) => 'world');
  ///
  /// final owner = ProviderContainer(
  ///   overrides: [
  ///     provider1.debugOverrideWithValue(const AsyncValue.loading())
  ///     provider2.overrideAs(Provider((_) => 'London')),
  ///   ],
  /// );
  /// ```
  ///
  /// Then we can call update with different overrides:
  ///
  /// ```dart
  /// owner.updateOverrides([
  ///   provider1.debugOverrideWithValue(const AsyncValue.data('Hi'))
  ///   provider2.overrideAs(Provider((_) => 'London')),
  /// ]);
  /// ```
  ///
  /// But we cannot call [updateOverrides] with different overrides:
  ///
  /// ```dart
  /// // Invalid, provider2 was overriden before but is not anymore
  /// owner.updateOverrides([
  ///   provider1.debugOverrideWithValue(const AsyncValue.data('Hi'))
  /// ]);
  ///
  /// // Invalid, provider3 was not overriden before, but now is
  /// owner.updateOverrides([
  ///   provider1.debugOverrideWithValue(const AsyncValue.data('Hi'))
  ///   provider2.overrideAs(Provider((_) => 'London')),
  ///   provider3.overrideAs(...),
  /// ]);
  ///
  /// // Invalid the order of the overrides
  /// owner.updateOverrides([
  ///   provider2.overrideAs(Provider((_) => 'London')),
  ///   provider1.debugOverrideWithValue(const AsyncValue.data('Hi'))
  /// ]);
  /// ```
  void updateOverrides(List<Override> overrides) {
    assert(() {
      if (_disposed) {
        throw StateError(
          'Called updateOverrides on a ProviderContainer that was already disposed',
        );
      }
      if (overrides != null && _debugOverrides != overrides) {
        if (overrides.length != _debugOverrides.length) {
          throw UnsupportedError(
            'Adding or removing provider overrides is not supported',
          );
        }

        for (var i = 0; i < overrides.length; i++) {
          final next = overrides[i];
          final previous = _debugOverrides[i];

          if (previous.runtimeType != next.runtimeType) {
            throw UnsupportedError('''
Replaced the override at index $i of type ${previous.runtimeType} with an override of type ${next.runtimeType}, which is different.
Changing the kind of override or reordering overrides is not supported.
''');
          }

          if (next is ProviderOverride && previous is ProviderOverride) {
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
          // No need to assert anything for family overrides as they can't "didUpdateProvider".
        }
      }
      _debugOverrides = overrides;
      return true;
    }(), '');

    for (final override in overrides) {
      if (override is ProviderOverride) {
        _overrideForProvider[override._origin] = override._provider;

        assert(
          override._origin is! Computed && override._provider is! Computed,
          'Cannot override Computed',
        );
        // no need to check _computedStateReaders as they are not overridable.
        // _stateReaders[override._origin] cannot be null for overriden providers.
        final state = _stateReaders[override._origin]
            // _providerState instead of read() to not compute the state
            // if it wasn't loaded yet.
            ._providerState;
        if (state == null) {
          continue;
        }
        final oldProvider = state._provider;
        state._provider = override._provider;
        _runUnaryGuarded(state.didUpdateProvider, oldProvider);
      } else if (override is FamilyOverride) {
        _overrideForFamily[override._family] = override;
      }
    }
  }

  /// Used by [ProviderStateBase.notifyChanged] to let [ProviderContainer]
  /// know that a provider changed.
  ///
  /// This is then used to notify [ProviderObserver]s of the changes.
  void _reportChanged(ProviderBase origin, Object newState) {
    if (_observers != null) {
      for (final observer in _observers) {
        _runBinaryGuarded(
          observer.didUpdateProvider,
          origin,
          newState,
        );
      }
    }
  }

  /// Reads the state of a provider, potentially creating it in the processs.
  ///
  /// It may throw if the provider requested threw when it was built.
  ProviderStateBase<Dependency, ListeningValue,
          ProviderBase<Dependency, ListeningValue>>
      _readProviderState<Dependency extends ProviderDependencyBase,
          ListeningValue>(
    final ProviderBase<Dependency, ListeningValue> provider,
  ) {
    if (_disposed) {
      throw StateError(
        'Tried to read a provider from a ProviderContainer that was already disposed',
      );
    }
    var reader = _stateReaders[provider];

    if (reader == null) {
      // Doesn't have a reader yet – let's create it.
      if (provider is Computed) {
        _computedStateReaders ??= {};
        reader = _computedStateReaders.putIfAbsent(provider as Computed, () {
          return _ProviderStateReader(provider, this);
        });
      } else if (provider._family != null &&
          _overrideForFamily[provider._family] != null) {
        final familyOverride = _overrideForFamily[provider._family];

        if (familyOverride != null) {
          _overrideForProvider[provider] =
              familyOverride._createOverride(provider.parameter);
        }

        reader = _stateReaders[provider] = _ProviderStateReader(provider, this);
      } else if (provider is StateNotifierStateProvider) {
        // TODO find a way to simplify this
        final controller =
            (provider as StateNotifierStateProvider).notifierProvider;
        if (_stateReaders[controller] != null ||
            (controller._family != null &&
                _overrideForFamily[controller._family] != null)) {
          reader =
              _stateReaders[provider] = _ProviderStateReader(provider, this);
        }
      } else if (provider is AutoDisposeStateNotifierStateProvider) {
        final controller = (provider as AutoDisposeStateNotifierStateProvider)
            .notifierProvider;
        if (_stateReaders[controller] != null ||
            (controller._family != null &&
                _overrideForFamily[controller._family] != null)) {
          reader =
              _stateReaders[provider] = _ProviderStateReader(provider, this);
        }
      }
    }

    final state = reader?.read() ?? _fallback(provider);

    state._performFlush();

    return state as ProviderStateBase<Dependency, ListeningValue,
        ProviderBase<Dependency, ListeningValue>>;
  }

  /// Release all the resources associated with this [ProviderContainer].
  ///
  /// This will destroy the state of all providers associated to this
  /// [ProviderContainer] and call [ProviderReference.onDispose] listeners.
  void dispose() {
    if (_disposed) {
      throw StateError(
        'Called disposed on a ProviderContainer that was already disposed',
      );
    }
    _disposed = true;

    assert(notifyListenersLock == null, '');

    for (final state in _visitStatesInReverseOrder()) {
      notifyListenersLock = state;
      try {
        state.dispose();
      } finally {
        notifyListenersLock = null;
      }
    }
  }

  /// Visit all nodes of the graph at most once from nodes with no dependents to roots.
  ///
  /// This is fairly expensive, up to O(N^2)
  Iterable<ProviderStateBase> _visitStatesInReverseOrder() sync* {
    final visitedStates = <ProviderStateBase>{};
    Iterable<ProviderStateBase> recurs(ProviderStateBase state) sync* {
      if (state._owner != this || visitedStates.contains(state)) {
        return;
      }
      visitedStates.add(state);

      final dependents = [...state._dependents];

      for (final dependent in dependents) {
        yield* recurs(dependent);
      }

      yield state;
    }

    if (_computedStateReaders != null) {
      for (final entry in _computedStateReaders.values) {
        // A computed state may be null if it was listened then disposed
        if (entry._providerState != null) {
          yield* recurs(entry._providerState);
        }
      }
    }
    for (final entry in _stateReaders.values) {
      if (entry._providerState != null) {
        yield* recurs(entry._providerState);
      }
    }
  }
}

/// Do not use: Utilities for internally creating providers and testing them
@visibleForTesting
extension ProviderStateOwnerInternals on ProviderContainer {
  /// All the states of the providers associated to a [ProviderContainer], sorted
  /// in order of dependency.
  @visibleForTesting
  List<ProviderStateBase> get debugProviderStates {
    List<ProviderStateBase> result;
    assert(() {
      result = _visitStatesInReverseOrder().toList().reversed.toList();
      return true;
    }(), '');
    return result;
  }

  /// Reads a provider and returns its state.
  ProviderStateBase<Dependency, ListeningValue,
          ProviderBase<Dependency, ListeningValue>>
      readProviderState<Dependency extends ProviderDependencyBase,
          ListeningValue>(
    ProviderBase<Dependency, ListeningValue> provider,
  ) {
    return _readProviderState(provider);
  }

  /// The value exposed by all providers.
  Map<ProviderBase, Object> get debugProviderValues {
    Map<ProviderBase, Object> res;
    assert(() {
      res = {
        for (final entry in _stateReaders.entries)
          if (entry.value._providerState != null)
            entry.key: entry.value._providerState.state,
        if (_computedStateReaders != null)
          for (final entry in _computedStateReaders.entries)
            if (entry.value._providerState != null)
              entry.key: entry.value._providerState.state,
      };

      return true;
    }(), '');
    return res;
  }
}

/// An object used by [ProviderContainer] to override the behavior of a provider
/// for a part of the application.
///
/// Do not implement/extend this class.
///
/// See also:
///
/// - [ProviderContainer], which uses this object.
/// - [AlwaysAliveProviderBase.overrideAs], which creates a [ProviderOverride].
class ProviderOverride implements Override {
  ProviderOverride._(this._provider, this._origin);

  final ProviderBase _origin;
  final ProviderBase _provider;
}

/// An object used by [ProviderContainer]/`ProviderScope` to override the behavior
/// of a provider/family for part of the application.
///
/// Do not extend or implement.
class Override {}

/// A base class for objects returned by [ProviderReference.dependOn].
abstract class ProviderDependencyBase {}

/// An empty implementation of [ProviderDependencyBase].
class ProviderBaseDependencyImpl extends ProviderDependencyBase {}

/// An error thrown when a call to [ProviderReference.dependOn] leads
/// to a provider depending on itself.
///
/// Circular dependencies are both not supported for performance reasons
/// and maintainability reasons.
/// Consider reading about unidirectional data-flow to learn about the
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
/// - [ProviderContainer.ref], an easy way of obtaining a [ProviderReference].
class ProviderReference {
  /// DO NOT USE, for internal usages only.
  @visibleForTesting
  ProviderReference(this._providerState);

  final ProviderStateBase _providerState;

  /// An utility to know if a provider was destroyed or not.
  ///
  /// This is useful when dealing with asynchronous operations, as the provider
  /// may have potentially be destroyed before the end of the asyncronous operation.
  /// In that case, we may want to stop performing further tasks.
  ///
  /// Most providers are never disposed, so in most situations you do not have to
  /// care about this.
  bool get mounted => _providerState.mounted;

  /// Adds a listener to perform an operation right before the provider is destroyed.
  ///
  /// This typically happen when a `ProviderScope` is removed from the widget tree
  /// when using Flutter.
  ///
  /// See also:
  ///
  /// - [ProviderContainer.dispose], which will destroy providers.
  void onDispose(VoidCallback cb) {
    _providerState.onDispose(cb);
  }

  /// Obtain another provider.
  ///
  /// It is safe to call [dependOn] multiple times with the same provider
  /// as parameter and is inexpensive to do so.
  ///
  /// Calling this method is O(1).
  ///
  /// See also:
  ///
  /// - [Provider], explains in further detail how to use this method.
  T dependOn<T extends ProviderDependencyBase>(
    ProviderBase<T, Object> provider,
  ) {
    return _providerState.read(provider);
  }

  /// Reads the value of a provider.
  ///
  /// This is syntax sugar for `ref.dependOn(provider).value`, avoiding
  /// having to read `.value` on providers that expose such property.
  ///
  /// See also:
  ///
  /// - [dependOn], which reads a provider and returns a [ProviderDependencyBase]
  ///   instead of a value directly.
  T read<T>(ProviderBase<ProviderDependency<T>, Object> provider) {
    return dependOn(provider).value;
  }
}
