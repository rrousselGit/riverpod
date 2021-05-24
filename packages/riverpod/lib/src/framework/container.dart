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

ProviderBase? _circularDependencyLock;

int _debugNextId = 0;

/// {@template riverpod.providercontainer}
/// An object that stores the state of the providers and allows overriding the
/// behavior of a specific provider.
///
/// If you are using Flutter, you do not need to care about this object
/// (outside of testing), as it is implicitly created for you by `ProviderScope`.
/// {@endtemplate}
@sealed
class ProviderContainer {
  /// {@macro riverpod.providercontainer}
  ProviderContainer({
    ProviderContainer? parent,
    List<Override> overrides = const [],
    List<ProviderObserver>? observers,
  })  : _parent = parent,
        _localObservers = observers,
        _root = parent?._root ?? parent,
        _scheduler = parent?._root?._scheduler ?? _ProviderScheduler() {
    assert(() {
      _debugId = '${_debugNextId++}';
      RiverpodBinding.debugInstance.containers = {
        ...RiverpodBinding.debugInstance.containers,
        _debugId: this,
      };
      return true;
    }(), '');

    if (parent != null) {
      if (observers != null) {
        throw UnsupportedError(
          'Cannot specify observers on a non-root ProviderContainer/ProviderScope',
        );
      }
      for (final override in overrides) {
        if (override is! ProviderOverride ||
            override._origin is! ScopedProvider) {
          throw UnsupportedError(
            'Cannot override providers on a non-root ProviderContainer/ProviderScope',
          );
        }
      }

      parent._children.add(this);

      _overrideForProvider.addEntries(parent._overrideForProvider.entries
          .where((e) => e.key is ScopedProvider));
    }

    for (final override in overrides) {
      if (override is ProviderOverride) {
        _overrideForProvider[override._origin] = override._provider;
      } else if (override is FamilyOverride) {
        _overrideForFamily[override._family] = override;
      }
    }
  }

  /// The object that handles when providers are refreshed and disposed.
  final _ProviderScheduler _scheduler;

  late final String _debugId;

  /// A unique ID for this object, used by the devtool to differentiate two [ProviderContainer].
  ///
  /// Should not be used.
  @visibleForTesting
  String get debugId {
    String? id;
    assert(() {
      id = _debugId;
      return true;
    }(), '');

    return id!;
  }

  final ProviderContainer? _root;
  final ProviderContainer? _parent;

  final _children = HashSet<ProviderContainer>();

  /// All the containers that have this container as `parent`.
  ///
  /// Do not use in production
  Set<ProviderContainer> get debugChildren => {..._children};

  final _overrideForProvider = HashMap<ProviderBase, ProviderBase>();
  final _overrideForFamily = HashMap<Family, FamilyOverride>();
  final _stateReaders = HashMap<ProviderBase, ProviderElementBase>();

  final List<ProviderObserver>? _localObservers;

  /// Awaits for providers to rebuild/be disposed and for listeners to be notified.
  Future<void> pump() async {
    return _scheduler._pendingFuture;
  }

  Iterable<ProviderObserver> get _observers sync* {
    final iterable = _root == null ? _localObservers : _root!._localObservers;
    if (iterable != null) {
      yield* iterable;
    }
  }

  /// A debug utility used by `flutter_riverpod`/`hooks_riverpod` to check
  /// if it is safe to modify a provider.
  ///
  /// This corresponds to all the widgets that a [Provider] is associated with.
  final DoubleLinkedQueue<void Function()> debugVsyncs = DoubleLinkedQueue();

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
    ProviderBase<Result> provider,
  ) {
    final element = readProviderElement(provider);
    element.flush();

    // In case `read` was called on a provider that has no listener
    element.mayNeedDispose();

    return element.getExposedValue();
  }

  /// Subscribe to this provider.
  ///
  /// See also:
  ///
  /// - [ProviderSubscription], which allows reading the current value and
  ///   closing the subscription.
  /// - [ProviderRefBase.watch], which is an easier way for providers to listen
  ///   to another provider.
  ProviderSubscription<State> listen<State>(
    ProviderListenable<State> provider,
    void Function(State value) listener, {
    bool fireImmediately = false,
  }) {
    if (provider is ProviderBase<State>) {
      return _listenProvider(
        provider,
        listener,
        fireImmediately: fireImmediately,
      );
    }
    // TODO implement selectors
    else {
      throw UnsupportedError('Unknown ProviderListenable $provider');
    }
  }

  ProviderSubscription<State> _listenProvider<State>(
    ProviderBase<State> provider,
    void Function(State value) listener, {
    required bool fireImmediately,
  }) {
    final element = readProviderElement(provider);

    // TODO(rrousselGit) add fireImmediately parameter
    // TODO(rrousselGit) add onError parameter
    // TODO(rrousselGit) test that if the provider threw immediately, the listen call completes corretly
    if (fireImmediately) {
      listener(element.getExposedValue());
    }

    element._listeners.add(listener);

    return ProviderSubscription._(element, listener);
  }

  /// Forces a provider to re-evaluate its state immediately, and return the created value.
  ///
  /// This method is useful for features like "pull to refresh" or "retry on error",
  /// to restart a specific provider.
  Created refresh<Created>(ProviderBase<Created> provider) {
    final element = (_root ?? this)._stateReaders[provider];

    if (element == null) {
      return readProviderElement(provider).getExposedValue();
    } else {
      element.markMustRecomputeState();
      return element.getExposedValue() as Created;
    }
  }

  void _disposeProvider(ProviderBase<Object?> provider) {
    final element = readProviderElement(provider);
    assert(
      _stateReaders.containsKey(element._origin),
      'Removed a key that does not exist',
    );
    _stateReaders.remove(element._origin);
    if (element._origin.from != null) {
      element._origin.from!._cache.remove(element._origin.argument);
    }
    element.dispose();
  }

  /// Updates the list of provider overrides.
  ///
  /// If you are using flutter, this is done implicitly for you by `ProviderScope`.
  ///
  /// Updating a `overrideWithValue` with a different value
  /// will cause the listeners to rebuild.
  ///
  /// It is not possible, to remove or add new overrides, only update existing ones.
  void updateOverrides(List<Override> overrides) {
    if (_disposed) {
      throw StateError(
        'Called updateOverrides on a ProviderContainer that was already disposed',
      );
    }

    List<Override>? unusedOverrides;
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

        final previousOverride = _overrideForProvider[override._origin];
        _overrideForProvider[override._origin] = override._provider;

        if (override._origin is ScopedProvider) {
          for (final child in _children) {
            if (override._provider is! ValueProvider ||
                (override._provider as ValueProvider)._value !=
                    (previousOverride! as ValueProvider)._value) {
              if (child._overrideForProvider[override._origin] ==
                  previousOverride) {
                child.updateOverrides([override]);
              }
            }
          }
        }
        assert(() {
          unusedOverrides!.remove(override);
          return true;
        }(), '');

        // _stateReaders[override._origin] cannot be null for overridden providers.
        final element = _stateReaders[override._origin];
        if (element == null) {
          continue;
        }
        _runUnaryGuarded(element.update, override._provider);
      } else if (override is FamilyOverride) {
        assert(() {
          unusedOverrides!.remove(override);
          return true;
        }(), '');
        _overrideForFamily[override._family] = override;
      }
    }

    assert(
      unusedOverrides!.isEmpty,
      'Updated the list of overrides with providers that were not overriden before',
    );
  }

  /// Reads the state of a provider, potentially creating it in the process.
  ///
  /// It may throw if the provider requested threw when it was built.
  ///
  /// Do not use this in production code. This is exposed only for testing
  /// and devtools, to be able to test if a provider has listeners or similar.
  ProviderElementBase<State> readProviderElement<State>(
    ProviderBase<State> provider,
  ) {
    if (_disposed) {
      throw StateError(
        'Tried to read a provider from a ProviderContainer that was already disposed',
      );
    }
    if (_root != null && provider is RootProvider) {
      return _root!.readProviderElement(provider);
    }

    final element = _stateReaders.putIfAbsent(provider, () {
      if (provider == _circularDependencyLock) {
        throw CircularDependencyError._();
      }
      _circularDependencyLock ??= provider;
      try {
        var override = _overrideForProvider[provider];

        if (override == null &&
            provider.from != null &&
            _overrideForFamily[provider.from] != null) {
          final familyOverride = _overrideForFamily[provider.from]!;
          override = familyOverride._createOverride(provider._argument)
              as ProviderBase<State>;
        }

        override ??= provider;
        final element = override.createElement()
          .._provider = override
          .._origin = provider
          .._container = this
          ..mount();

        for (final observer in _observers) {
          _runBinaryGuarded<ProviderBase, Object?>(
            observer.didAddProvider,
            provider,
            element._state,
          );
        }
        return element;
      } finally {
        if (_circularDependencyLock == provider) {
          _circularDependencyLock = null;
        }
      }
    }) as ProviderElementBase<State>;

    return element;
  }

  /// Release all the resources associated with this [ProviderContainer].
  ///
  /// This will destroy the state of all providers associated to this
  /// [ProviderContainer] and call [ProviderRefBase.onDispose] listeners.
  void dispose() {
    if (_disposed) {
      return;
    }
    if (_children.isNotEmpty) {
      throw StateError(
        'Tried to dispose a ProviderContainer that still has children containers.',
      );
    }

    assert(() {
      RiverpodBinding.debugInstance.containers =
          Map.from(RiverpodBinding.debugInstance.containers)..remove(_debugId);
      return true;
    }(), '');

    debugVsyncs.clear();
    _parent?._children.remove(this);

    _disposed = true;

    // Using a set to deduplicate elements
    final allElementsInOrder = <ProviderElementBase>{};
    _visitStatesInOrder(allElementsInOrder.add);

    for (final element in allElementsInOrder.toList(growable: false).reversed) {
      element.dispose();
    }
  }

  /// Visit all nodes of the graph at most once, from roots to leaves.
  ///
  /// This is a breadth-first traversal algorithm, that does **not** remove duplicates,
  /// so it is possible for the same element to be visited multiple times.
  ///
  /// The visitor can return `true` if it wants to visit the dependents of that
  /// element too. Otherwise it can return false.
  void _visitStatesInOrder(
    bool Function(ProviderElementBase element) visitor,
  ) {
    void visitElement(ProviderElementBase element) {
      if (visitor(element)) {
        element._dependencies.keys.forEach(visitElement);
      }
    }

    // visit roots first
    for (final element in _stateReaders.values) {
      if (element._dependencies.isEmpty) {
        visitElement(element);
      }
    }
  }

  // /// The states of the providers associated to this [ProviderContainer], sorted
  // /// in order of dependency.
  // List<ProviderElement> get debugProviderElements {
  //   late List<ProviderElement> result;
  //   assert(() {
  //     result = _visitStatesInOrder().toList();
  //     return true;
  //   }(), '');
  //   return result;
  // }

  // /// The value exposed by all providers currently alive.
  // Map<ProviderBase, Object?> get debugProviderValues {
  //   late Map<ProviderBase, Object?> res;
  //   assert(() {
  //     res = {
  //       for (final entry in _stateReaders.entries)
  //         entry.key: entry.value.state.exposedValue,
  //     };

  //     return true;
  //   }(), '');
  //   return res;
  // }
}

/// An object that listens to the changes of a [ProviderContainer].
///
/// This can be used for logging or making devtools.
abstract class ProviderObserver {
  /// An object that listens to the changes of a [ProviderContainer].
  ///
  /// This can be used for logging or making devtools.
  const ProviderObserver();

  /// A provider was initialized, and the value exposed is [value].
  void didAddProvider(ProviderBase provider, Object? value) {}

  /// Called my providers when they emit a notification.
  void didUpdateProvider(
    ProviderBase provider,
    Object? previousValue,
    Object? newValue,
  ) {}

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
/// - `overrideWithProvider`/`overrideWithValue`, which creates a [ProviderOverride].
@sealed
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

/// An error thrown when a call to [ProviderRefBase.read]/[ProviderRefBase.watch]
/// leads to a provider depending on itself.
///
/// Circular dependencies are both not supported for performance reasons
/// and maintainability reasons.
/// Consider reading about unidirectional data-flow to learn about the
/// benefits of avoiding circular dependencies.
class CircularDependencyError extends Error {
  CircularDependencyError._();
}
