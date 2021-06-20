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

void _defaultVsync(void Function() task) {
  Future(task);
}

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
        _root = parent?._root ?? parent {
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

  /// A function that controls the refresh rate of providers.
  ///
  /// Defaults to refreshing providers at the end of the next event-loop.
  void Function(void Function() task) get vsync {
    return vsyncOverride ?? _defaultVsync;
  }

  /// A way to override [vsync], used by Flutter to synchronize a container
  /// with the widget tree.
  void Function(void Function() task)? vsyncOverride;

  /// The object that handles when providers are refreshed and disposed.
  late final _ProviderScheduler _scheduler =
      _parent?._root?._scheduler ?? _ProviderScheduler(vsync);

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

  // /// A function that calls its callback at the end of the current "frame".
  // ///
  // /// This is exposed so that
  // ///
  // /// Defaults to wraping the callback in a [Future].
  // void Function(void Function()) addPostFrameCallback = (cb) => Future(cb);

  final List<ProviderObserver>? _localObservers;

  /// Awaits for providers to rebuild/be disposed and for listeners to be notified.
  Future<void> pump() async {
    return _scheduler.pendingFuture;
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
  void Function()? debugCanModifyProviders;

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
    if (provider is _ProviderSelector<Object?, State>) {
      return provider.listen(this, listener, fireImmediately: fireImmediately);
    }

    final element = readProviderElement(provider as ProviderBase<State>);

    return element.addListener(
      provider,
      listener,
      fireImmediately: fireImmediately,
    );
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
          override = familyOverride._createOverride(
              provider._argument, provider) as ProviderBase<State>;
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

    _parent?._children.remove(this);

    _disposed = true;

    for (final element in getAllProviderElementsInOrder().toList().reversed) {
      element.dispose();
    }
  }

  /// Traverse the [ProviderElementBase]s associated with this [ProviderContainer].
  Iterable<ProviderElementBase> getAllProviderElements() {
    return _stateReaders.values;
  }

  /// Visit all nodes of the graph at most once, from roots to leaves.
  ///
  /// This is fairly expensive and should be avoided as much as possible.
  /// If you do not need for providers to be sorted, consider using [getAllProviderElements]
  /// instead, which returns an unsorted list and is significantly faster.
  Iterable<ProviderElementBase> getAllProviderElementsInOrder() sync* {
    final visitedNodes = HashSet<ProviderElementBase>();
    final queue = DoubleLinkedQueue<ProviderElementBase>();

    // get roots of the provider graph
    for (final element in _stateReaders.values) {
      var hasAncestors = false;
      element.visitAncestors((element) {
        hasAncestors = true;
      });

      if (!hasAncestors) {
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

      // Queue the children of this element, but only if all of its ancestors
      // were already visited before.
      // If a child does not have all of its ancestors visited, when those
      // ancestors will be visited, they will retry visiting this child.
      element.visitChildren((dependent) {
        if (dependent.container == this) {
          // All the parents of a node must have been visited before a node is visited
          var areAllAncestorsAlreadyVisited = true;
          dependent.visitAncestors((e) {
            if (e._container == this && !visitedNodes.contains(e)) {
              areAllAncestorsAlreadyVisited = false;
            }
          });

          if (areAllAncestorsAlreadyVisited) queue.add(dependent);
        }
      });
    }
  }
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
