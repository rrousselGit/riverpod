part of '../framework.dart';

void _runGuarded(void Function() cb) {
  try {
    cb();
  } catch (err, stack) {
    Zone.current.handleUncaughtError(err, stack);
  }
}

void _runUnaryGuarded<T, Res>(Res Function(T) cb, T value) {
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

ProviderBase _circularDependencyLock;

/// {@template riverpod.providercontainer}
/// An object that stores the state of the providers and allows overriding the
/// behavior of a specific provider.
///
/// If you are using Flutter, you do not need to care about this object
/// (outside of testing), as it is implicitly created for you by `ProviderScope`.
/// {@endtemplate}
class ProviderContainer {
  /// {@macro riverpod.providercontainer}
  ProviderContainer({
    ProviderContainer parent,
    List<Override> overrides = const [],
    List<ProviderObserver> observers,
  })  : _localObservers = observers,
        _root = parent?._root ?? parent {
    if (parent != null) {
      if (observers != null) {
        throw UnsupportedError(
          'Cannot specify observers on a non-root ProviderContainer/ProviderScope',
        );
      }
      for (final override in overrides) {
        if (override is ProviderOverride &&
            override._origin is ScopedProvider) {
        } else {
          throw UnsupportedError(
            'Cannot override providers on a non-root ProviderContainer/ProviderScope',
          );
        }
      }
    }

    for (final override in overrides) {
      if (override is ProviderOverride) {
        _overrideForProvider[override._origin] = override._provider;
      } else if (override is FamilyOverride) {
        _overrideForFamily[override._family] = override;
      }
    }
  }

  final ProviderContainer _root;
  final _overrideForProvider = <ProviderBase, ProviderBase>{};
  final _overrideForFamily = <Family, FamilyOverride>{};

  final Map<ProviderBase, ProviderElement> _stateReaders = {};

  final List<ProviderObserver> _localObservers;
  Iterable<ProviderObserver> get _observers sync* {
    final iterable = _root == null ? _localObservers : _root._localObservers;
    if (iterable != null) {
      yield* iterable;
    }
  }

  /// Whether [dispose] was called or not.
  ///
  /// This disables the different methods of [ProviderContainer], resulting in
  /// a [StateError] when attempting to use them.
  bool _disposed = false;

  /// Reads a provider without listening to it and returns the currently
  /// exposed value.
  ///
  /// ```dart
  /// final greetingProvider = Provider((_) => 'Hello world');
  ///
  /// void main() {
  ///   final container = ProviderContainer();
  ///
  ///   print(container.read(greetingProvider)); // Hello World
  /// }
  /// ```
  Result read<Result>(
    ProviderBase<Object, Result> provider,
  ) {
    final element = readProviderElement(provider);
    element.flush();
    return element.getExposedValue();
  }

  /// Subscribe to this provider.
  ///
  /// * [mayHaveChanged] will be called the first time that any of the dependency
  ///   of a provider changed.
  ///
  /// * [didChange] will be called after the first [ProviderSubscription.flush]
  ///   or [ProviderSubscription.read], only if when it is confirmed that the
  ///   value exposed changed.
  ///
  /// See also:
  ///
  /// - [ProviderSubscription], which allows reading the current value and
  ///   closing the subscription.
  /// - [ProviderReference.watch], which is an easier way for providers to listen
  ///   to another provider.
  ProviderSubscription<Result> listen<Result>(
    ProviderListenable<Result> provider, {
    void Function(ProviderSubscription<Result> sub) mayHaveChanged,
    void Function(ProviderSubscription<Result> sub) didChange,
  }) {
    if (provider is ProviderBase<Object, Result>) {
      return readProviderElement(provider).listen(
        mayHaveChanged: mayHaveChanged,
        didChange: didChange,
      );
    } else if (provider is ProviderSelector<Object, Result>) {
      return provider._listen(
        this,
        mayHaveChanged: mayHaveChanged,
        didChange: didChange,
      );
    } else {
      throw UnsupportedError('Unknown ProviderListenable $provider');
    }
  }

  /// Forces a provider to re-evaluate its state immediatly, and return the created value.
  ///
  /// This method is useful for features like "pull to refresh" or "retry on error",
  /// to restart a specific provider.
  Created refresh<Created>(RootProvider<Created, Object> provider) {
    final element = _stateReaders[provider];

    if (element == null) {
      return readProviderElement(provider).state.createdValue;
    } else {
      element.markMustRecomputeState();
      element.flush();
      return element.state.createdValue as Created;
    }
  }

  /// Updates the list of provider overrides.
  ///
  /// If you are using flutter, this is done implicitly for you by `ProviderScope`.
  ///
  /// Updating a [RootProvider.overrideWithValue] with a different value
  /// will cause the listeners to rebuild.
  ///
  /// It is not possible, to remove or add new overrides, only update existing ones.
  void updateOverrides(List<Override> overrides) {
    if (_disposed) {
      throw StateError(
        'Called updateOverrides on a ProviderContainer that was already disposed',
      );
    }

    List<Override> unusedOverrides;
    assert(() {
      unusedOverrides = [...overrides];
      return true;
    }(), '');

    for (final override in overrides) {
      if (override is ProviderOverride) {
        assert(
          _overrideForProvider[override._origin].runtimeType ==
              override._provider.runtimeType,
          'Replaced the override of type ${_overrideForProvider[override._origin].runtimeType} '
          'with an override of type ${override._provider.runtimeType}, which is different.\n'
          'Changing the kind of override or reordering overrides is not supported.',
        );

        _overrideForProvider[override._origin] = override._provider;

        // _stateReaders[override._origin] cannot be null for overriden providers.
        final element = _stateReaders[override._origin];
        if (element == null) {
          continue;
        }
        assert(() {
          unusedOverrides.remove(override);
          return true;
        }(), '');
        _runUnaryGuarded(element.update, override._provider);
      } else if (override is FamilyOverride) {
        assert(() {
          unusedOverrides.remove(override);
          return true;
        }(), '');
        _overrideForFamily[override._family] = override;
      }
      assert(
        unusedOverrides.isEmpty,
        'Updated the list of overrides with providers that were not overriden before',
      );
    }
  }

  /// Reads the state of a provider, potentially creating it in the processs.
  ///
  /// It may throw if the provider requested threw when it was built.
  ///
  /// Do not use this in production code. This is exposed only for testing
  /// and devtools, to be able to test if a provider has listeners or similar.
  ProviderElement<Created, Listened> readProviderElement<Created, Listened>(
    ProviderBase<Created, Listened> provider,
  ) {
    if (_disposed) {
      throw StateError(
        'Tried to read a provider from a ProviderContainer that was already disposed',
      );
    }
    if (_root != null && provider is RootProvider) {
      return _root.readProviderElement(provider);
    }
    if (provider == _circularDependencyLock) {
      throw CircularDependencyError._();
    }
    _circularDependencyLock ??= provider;

    try {
      final element = _stateReaders.putIfAbsent(provider, () {
        ProviderBase<Created, Listened> override;
        override ??=
            _overrideForProvider[provider] as ProviderBase<Created, Listened>;
        if (override == null &&
            provider.from != null &&
            _overrideForFamily[provider.from] != null) {
          final familyOverride = _overrideForFamily[provider.from];
          override = familyOverride._createOverride(provider._argument)
              as ProviderBase<Created, Listened>;
        }
        override ??= provider;
        final element = override.createElement()
          .._provider = override
          .._origin = provider
          .._container = this
          ..mount();

        for (final observer in _observers) {
          _runBinaryGuarded(
            observer.didAddProvider,
            provider,
            element.state._exposedValue,
          );
        }
        return element;
      }) as ProviderElement<Created, Listened>;
      return element..flush();
    } finally {
      if (_circularDependencyLock == provider) {
        _circularDependencyLock = null;
      }
    }
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

    if (_root != null) {
      return;
    }

    for (final state
        in _visitStatesInOrder().toList(growable: false).reversed) {
      state.dispose();
    }
  }

  /// Visit all nodes of the graph at most once, from roots to leaves.
  ///
  /// This is a breadth-first traversal algorithm, that removes duplicate branches.
  ///
  /// It is O(N log N) with N the number of providers currently alive.
  Iterable<ProviderElement> _visitStatesInOrder() sync* {
    final visitedNodes = <ProviderElement>{};
    final queue = DoubleLinkedQueue<ProviderElement>();

    for (final element in _stateReaders.values) {
      if (element._subscriptions == null || element._subscriptions.isEmpty) {
        queue.add(element);
      }
    }

    while (queue.isNotEmpty) {
      final element = queue.removeFirst();

      if (!visitedNodes.add(element)) {
        // Already visited
        continue;
      }

      yield element;

      if (element._dependents != null) {
        queue.addAll(element._dependents);
      }
    }
  }

  /// The states of the providers associated to this [ProviderContainer], sorted
  /// in order of dependency.
  List<ProviderElement> get debugProviderStates {
    List<ProviderElement> result;
    assert(() {
      result = _visitStatesInOrder().toList();
      return true;
    }(), '');
    return result;
  }

  /// The value exposed by all providers currently alive.
  Map<ProviderBase, Object> get debugProviderValues {
    Map<ProviderBase, Object> res;
    assert(() {
      res = {
        for (final entry in _stateReaders.entries)
          if (entry.value.state != null)
            entry.key: entry.value.state.exposedValue,
      };

      return true;
    }(), '');
    return res;
  }
}

/// An object that listens to the changes of a [ProviderContainer].
///
/// This can be used for logging or making devtools.
abstract class ProviderObserver {
  /// A provider was initialized, and the value exposed is [value].
  void didAddProvider(ProviderBase provider, Object value) {}

  /// Called when the dependency of a provider changed, but it is not yet
  /// sure if the computed value changes.
  ///
  /// It is possible that [mayHaveChanged] will be called, without [didUpdateProvider]
  /// being called, such as when a [Provider] is re-computed but returns
  /// a value == to the previous one.
  void mayHaveChanged(ProviderBase provider) {}

  /// Called my providers when they emit a notification.
  void didUpdateProvider(ProviderBase provider, Object newValue) {}

  /// A provider was disposed
  void didDisposeProvider(ProviderBase provider) {}
}

/// An object used by [ProviderContainer] to override the behavior of a provider
/// for a part of the application.
///
/// Do not implement/extend this class.
///
/// See also:
///
/// - [ProviderContainer], which uses this object.
/// - [AlwaysAliveProviderBase.overrideWithProvider], which creates a [ProviderOverride].
class ProviderOverride implements Override {
  /// Internal use only
  ProviderOverride(this._provider, this._origin);

  final ProviderBase _origin;
  final ProviderBase _provider;
}

/// An object used by [ProviderContainer]/`ProviderScope` to override the behavior
/// of a provider/family for part of the application.
///
/// Do not extend or implement.
class Override {}

/// An error thrown when a call to [ProviderReference.read]/[ProviderReference.watch]
/// leads to a provider depending on itself.
///
/// Circular dependencies are both not supported for performance reasons
/// and maintainability reasons.
/// Consider reading about unidirectional data-flow to learn about the
/// benefits of avoiding circular dependencies.
class CircularDependencyError extends Error {
  CircularDependencyError._();
}
