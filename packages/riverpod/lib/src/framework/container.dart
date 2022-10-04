part of '../framework.dart';

ProviderBase? _circularDependencyLock;

void _defaultVsync(void Function() task) {
  Future(task);
}

int _debugNextId = 0;

class _FamilyOverrideRef {
  _FamilyOverrideRef(this.override, this.container);

  FamilyOverride override;
  final ProviderContainer container;
}

/// An object that contains a [ProviderElementBase].
///
/// This object is used to implement the scoping mechanism of providers,
/// by allowing a [ProviderContainer] to "inherit" the [_StateReader]s from
/// its ancestor, while preserving the "mount providers on demand" logic.
class _StateReader {
  _StateReader({
    required this.origin,
    required this.override,
    required this.container,
    required this.isDynamicallyCreated,
  });

  final ProviderBase origin;
  ProviderBase override;
  final ProviderContainer container;

  /// Whether the [_StateReader] was created on first provider read instead of
  /// at the creation of the [ProviderContainer]
  final bool isDynamicallyCreated;

  ProviderElementBase? _element;

  ProviderElementBase getElement() => _element ??= _create();

  ProviderElementBase _create() {
    if (origin == _circularDependencyLock) {
      throw CircularDependencyError._();
    }
    _circularDependencyLock ??= origin;
    try {
      final element = override.createElement()
        .._provider = override
        .._origin = origin
        .._container = container
        ..mount();

      element.getState()!.map<void>(
        // ignore: avoid_types_on_closure_parameters
        data: (ResultData<Object?> data) {
          for (final observer in container._observers) {
            runTernaryGuarded(
              observer.didAddProvider,
              origin,
              data.state,
              container,
            );
          }
        },
        error: (error) {
          for (final observer in container._observers) {
            runTernaryGuarded(
              observer.didAddProvider,
              origin,
              null,
              container,
            );
          }
          for (final observer in container._observers) {
            runQuaternaryGuarded(
              observer.providerDidFail,
              origin,
              error.error,
              error.stackTrace,
              container,
            );
          }
        },
      );
      return element;
    } finally {
      if (_circularDependencyLock == origin) {
        _circularDependencyLock = null;
      }
    }
  }
}

var _debugVerifyDependenciesAreRespectedEnabled = true;

/// {@template riverpod.providercontainer}
/// An object that stores the state of the providers and allows overriding the
/// behavior of a specific provider.
///
/// If you are using Flutter, you do not need to care about this object
/// (outside of testing), as it is implicitly created for you by `ProviderScope`.
/// {@endtemplate}
@sealed
class ProviderContainer implements Node {
  /// {@macro riverpod.providercontainer}
  ProviderContainer({
    ProviderContainer? parent,
    List<Override> overrides = const [],
    List<ProviderObserver>? observers,
  })  : _debugOverridesLength = overrides.length,
        depth = parent == null ? 0 : parent.depth + 1,
        _parent = parent,
        _observers = [
          ...?observers,
          if (parent != null) ...parent._observers,
        ],
        _stateReaders = {
          if (parent != null)
            for (final entry in parent._stateReaders.entries)
              if (!entry.value.isDynamicallyCreated) entry.key: entry.value,
        },
        _root = parent?._root ?? parent {
    assert(
      () {
        _debugId = '${_debugNextId++}';
        RiverpodBinding.debugInstance.containers = {
          ...RiverpodBinding.debugInstance.containers,
          _debugId: this,
        };
        return true;
      }(),
      '',
    );

    if (parent != null) {
      parent._children.add(this);
      _overrideForFamily.addAll(parent._overrideForFamily);
    }

    for (final override in overrides) {
      if (override is ProviderOverride) {
        _overrideForProvider[override._origin] = override._override;
        _stateReaders[override._origin] = _StateReader(
          origin: override._origin,
          override: override._override,
          container: this,
          isDynamicallyCreated: false,
        );
      } else if (override is FamilyOverride) {
        _overrideForFamily[override.overriddenFamily] = _FamilyOverrideRef(
          override,
          this,
        );
      }
    }
  }

  final int _debugOverridesLength;

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
      _parent?._scheduler ?? _ProviderScheduler(vsync);

  late final String _debugId;

  /// How deep this [ProviderContainer] is in the graph of containers.
  ///
  /// Starts at 0.
  final int depth;

  /// A unique ID for this object, used by the devtool to differentiate two [ProviderContainer].
  ///
  /// Should not be used.
  @visibleForTesting
  String get debugId {
    String? id;
    assert(
      () {
        id = _debugId;
        return true;
      }(),
      '',
    );

    return id!;
  }

  final ProviderContainer? _root;
  final ProviderContainer? _parent;

  final _children = <ProviderContainer>[];

  /// All the containers that have this container as `parent`.
  ///
  /// Do not use in production
  List<ProviderContainer> get debugChildren => UnmodifiableListView(_children);

  final _overrideForProvider = HashMap<ProviderBase, ProviderBase>();
  final _overrideForFamily = HashMap<Family, _FamilyOverrideRef>();
  final Map<ProviderBase, _StateReader> _stateReaders;

  /// Awaits for providers to rebuild/be disposed and for listeners to be notified.
  Future<void> pump() async {
    return _scheduler.pendingFuture;
  }

  final List<ProviderObserver> _observers;

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
    ProviderListenable<Result> provider,
  ) {
    return provider.read(this);
  }

  /// Executes [ProviderElementBase.debugReassemble] on all the providers.
  void debugReassemble() {
// TODO hot-reload handle provider type change
// TODO hot-reload handle provider response type change
// TODO hot-reload handle provider -> family
// TODO hot-reload handle family adding parameters
// TODO found "Future already completed error" after adding family parameter

    assert(
      () {
        for (final element in getAllProviderElements()) {
          element.debugReassemble();
        }

        return true;
      }(),
      '',
    );
  }

  @override
  ProviderSubscription<State> _listenElement<State>(
    ProviderElementBase<State> element, {
    required void Function(State? previous, State next) listener,
    required void Function(Object error, StackTrace stackTrace) onError,
  }) {
    final sub = _ExternalProviderSubscription<State>._(
      element,
      listener,
      onError: onError,
    );

    element._externalDependents.add(sub);

    return sub;
  }

  /// {@macro riverpod.listen}
  @override
  ProviderSubscription<State> listen<State>(
    ProviderListenable<State> provider,
    void Function(State? previous, State next) listener, {
    bool fireImmediately = false,
    void Function(Object error, StackTrace stackTrace)? onError,
  }) {
    // TODO test always flushed provider
    return provider.addListener(
      this,
      listener,
      fireImmediately: fireImmediately,
      onError: onError,
      onDependencyMayHaveChanged: null,
    );
  }

  /// {@template riverpod.invalidate}
  void invalidate(ProviderOrFamily provider) {
    if (provider is ProviderBase) {
      final reader = _getStateReader(provider._origin);

      reader._element?.invalidateSelf();
    } else {
      provider as Family;

      final familyContainer =
          _overrideForFamily[provider]?.container ?? _root ?? this;

      for (final stateReader in familyContainer._stateReaders.values) {
        if (stateReader.origin.from != provider) continue;
        stateReader._element?.invalidateSelf();
      }
    }
  }

  /// {@template riverpod.refresh}
  State refresh<State>(Refreshable<State> provider) {
    invalidate(provider._origin);
    return read(provider);
  }

  void _disposeProvider(ProviderBase<Object?> provider) {
    final element = readProviderElement(provider);
    element.dispose();

    final reader = _stateReaders[element._origin]!;

    if (reader.isDynamicallyCreated) {
      // Since the StateReader is implicitly created, we don't keep it
      // on provider dispose, to avoid memory leak

      void removeStateReaderFrom(ProviderContainer container) {
        if (container._stateReaders[element._origin] == reader) {
          container._stateReaders.remove(element._origin);
          container._children.forEach(removeStateReaderFrom);
        }
      }

      removeStateReaderFrom(this);
    } else {
      reader._element = null;
    }
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

    assert(
      _debugOverridesLength == overrides.length,
      'Tried to change the number of overrides. This is not allowed – '
      'overrides cannot be removed/added, they can only be updated.',
    );

    List<Override>? unusedOverrides;
    assert(
      () {
        unusedOverrides = [...overrides];
        return true;
      }(),
      '',
    );

    for (final override in overrides) {
      if (override is ProviderOverride) {
        assert(
          () {
            unusedOverrides!.remove(override);
            return true;
          }(),
          '',
        );

        assert(
          _overrideForProvider[override._origin].runtimeType ==
              override._override.runtimeType,
          'Replaced the override of type ${_overrideForProvider[override._origin].runtimeType} '
          'with an override of type ${override._override.runtimeType}, which is different.\n'
          'Changing the kind of override or reordering overrides is not supported.',
        );

        // _stateReaders[origin] cannot be null for overridden providers.
        final reader = _stateReaders[override._origin]!;

        reader.override =
            _overrideForProvider[override._origin] = override._override;

        final element = reader._element;
        if (element == null) continue;

        runUnaryGuarded(element.update, override._override);
      } else if (override is FamilyOverride) {
        assert(
          () {
            unusedOverrides!.remove(override);
            return true;
          }(),
          '',
        );
        // TODO assert family override did not change

        _overrideForFamily[override.overriddenFamily]!.override = override;
      }
    }

    assert(
      unusedOverrides!.isEmpty,
      'Updated the list of overrides with providers that were not overridden before',
    );
  }

  @override
  ProviderElementBase<State> readProviderElement<State>(
    ProviderBase<State> provider,
  ) {
    if (_disposed) {
      throw StateError(
        'Tried to read a provider from a ProviderContainer that was already disposed',
      );
    }

    final reader = _getStateReader(provider);

    assert(
      () {
        // Avoid having the assert trigger itself exponentially
        if (!_debugVerifyDependenciesAreRespectedEnabled) return true;

        try {
          _debugVerifyDependenciesAreRespectedEnabled = false;

          // Check that this containers doesn't have access to an overridden
          // dependency of the targeted provider
          final targetElement = reader.getElement();
          final visitedDependencies = <ProviderBase>{};
          final queue = Queue<ProviderBase>();
          targetElement.visitAncestors((e) => queue.add(e.origin));

          while (queue.isNotEmpty) {
            final dependency = queue.removeFirst();
            if (visitedDependencies.add(dependency)) {
              final dependencyElement =
                  readProviderElement<Object?>(dependency);

              assert(
                targetElement.provider != targetElement.origin ||
                    dependencyElement ==
                        targetElement.container
                            .readProviderElement<Object?>(dependency),
                '''
Tried to read $provider from a place where one of its dependencies were overridden but the provider is not.

To fix this error, you can add add "dependencies" to $provider such that we have:

```
final a = Provider(...);
final b = Provider((ref) => ref.watch(a), dependencies: [a]);
```
''',
              );

              dependencyElement.visitAncestors((e) => queue.add(e.origin));
            }
          }
        } finally {
          _debugVerifyDependenciesAreRespectedEnabled = true;
        }
        return true;
      }(),
      '',
    );

    return reader.getElement() as ProviderElementBase<State>;
  }

  _StateReader _getStateReader(ProviderBase provider) {
    final currentReader = _stateReaders[provider];
    if (currentReader != null) return currentReader;

    _StateReader getReader() {
      if (provider.from != null) {
        // reading a family

        final familyOverrideRef = _overrideForFamily[provider.from];
        if (familyOverrideRef != null) {
          // A family was overridden, so we implicitly mount the readers

          if (familyOverrideRef.container._stateReaders.containsKey(provider)) {
            return familyOverrideRef.container._stateReaders[provider]!;
          }

          void setupOverride({
            required ProviderBase origin,
            required ProviderBase override,
          }) {
            assert(
              origin == override || override.dependencies == null,
              'A provider override cannot specify `dependencies`',
            );

            // setupOverride may be called multiple times on different providers
            // of the same family (provider vs provider.modifier), so we use ??=
            // to initialize the providers only once
            familyOverrideRef.container._stateReaders[origin] ??= _StateReader(
              origin: origin,
              override: override,
              container: familyOverrideRef.container,
              isDynamicallyCreated: true,
            );
          }

          final providerOverride =
              familyOverrideRef.override.getProviderOverride(provider);

          setupOverride(origin: provider, override: providerOverride);

          // if setupOverride overrode the provider, it was already initialized
          // in the code above. Otherwise we initialize it as if it was not overridden
          return familyOverrideRef.container._stateReaders[provider] ??
              _StateReader(
                origin: provider,
                override: provider,
                container: familyOverrideRef.container,
                isDynamicallyCreated: true,
              );
        }
      }

      final root = _root;
      if (root != null) {
        // On scoped containers, check for implicit override.

        final dependencies = provider.from?.allTransitiveDependencies ??
            provider.allTransitiveDependencies;

        final containerForDependencyOverride = dependencies
            ?.map((dep) {
              final reader = _stateReaders[dep];
              if (reader != null) {
                return reader.container;
              }
              final familyOverride = _overrideForFamily[dep];
              return familyOverride?.container;
            })
            .where((container) => container != null)
            .toList();

        if (containerForDependencyOverride != null &&
            containerForDependencyOverride.isNotEmpty) {
          // a dependency of the provider was overridden, so the provider is overridden too

          final deepestOverrideContainer = containerForDependencyOverride
              .fold<ProviderContainer>(root, (previous, container) {
            if (container!.depth > previous.depth) {
              return container;
            }
            return previous;
          });

          /// Insert the StateReader in the container that it belongs to,
          /// and import it locally
          return deepestOverrideContainer._stateReaders.putIfAbsent(provider,
              () {
            return _StateReader(
              origin: provider,
              override: provider,
              container: deepestOverrideContainer,
              isDynamicallyCreated: true,
            );
          });
        }
      }

      if (_root?._stateReaders.containsKey(provider) ?? false) {
        // For un-overridden providers, it is possible that the provider was
        // read in the root ProviderContainer before this container. In which case
        // we reuse the existing state instead of creating a new one.
        return _root!._stateReaders[provider]!;
      }

      // The provider had no existing state and no override, so we're
      // mounting it on the root container.
      final reader = _StateReader(
        origin: provider,
        // If a provider did not have an associated StateReader then it is
        // guaranteed to not be overridden
        override: provider,
        container: _root ?? this,
        isDynamicallyCreated: true,
      );

      if (_root != null) {
        _root!._stateReaders[provider] = reader;
      }

      return reader;
    }

    return _stateReaders[provider] = getReader();
  }

  /// Release all the resources associated with this [ProviderContainer].
  ///
  /// This will destroy the state of all providers associated with this
  /// [ProviderContainer] and call [Ref.onDispose] listeners.
  void dispose() {
    if (_disposed) {
      return;
    }
    if (_children.isNotEmpty) {
      throw StateError(
        'Tried to dispose a ProviderContainer that still has children containers.',
      );
    }

    assert(
      () {
        RiverpodBinding.debugInstance.containers =
            Map.from(RiverpodBinding.debugInstance.containers)
              ..remove(_debugId);
        return true;
      }(),
      '',
    );

    _parent?._children.remove(this);

    _disposed = true;

    for (final element in getAllProviderElementsInOrder().toList().reversed) {
      element.dispose();
    }

    if (_root == null) _scheduler.dispose();
  }

  /// Traverse the [ProviderElementBase]s associated with this [ProviderContainer].
  Iterable<ProviderElementBase> getAllProviderElements() sync* {
    for (final reader in _stateReaders.values) {
      if (reader._element != null && reader.container == this) {
        yield reader._element!;
      }
    }
  }

  /// Visit all nodes of the graph at most once, from roots to leaves.
  ///
  /// This is fairly expensive and should be avoided as much as possible.
  /// If you do not need for providers to be sorted, consider using [getAllProviderElements]
  /// instead, which returns an unsorted list and is significantly faster.
  Iterable<ProviderElementBase> getAllProviderElementsInOrder() sync* {
    final visitedNodes = HashSet<ProviderElementBase>();
    final queue = DoubleLinkedQueue<ProviderElementBase>();

    // get providers that don't depend on other providers from this container
    for (final reader in _stateReaders.values) {
      if (reader.container != this) continue;
      final element = reader._element;
      if (element == null) continue;

      var hasAncestorsInContainer = false;
      element.visitAncestors((element) {
        // We ignore dependencies that are defined in another container, as
        // they are in a separate graph
        if (element._container == this) {
          hasAncestorsInContainer = true;
        }
      });

      if (!hasAncestorsInContainer) {
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
      element.visitChildren(
        elementVisitor: (dependent) {
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
        },
        // We only care about Elements here, so let's ignore notifiers
        notifierVisitor: (_) {},
      );
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
  ///
  /// [value] will be `null` if the provider threw during initialization.
  void didAddProvider(
    ProviderBase provider,
    Object? value,
    ProviderContainer container,
  ) {}

  /// A provider emitted an error, be it by throwing during initialization
  /// or by having a [Future]/[Stream] emit an error
  void providerDidFail(
    ProviderBase provider,
    Object error,
    StackTrace stackTrace,
    ProviderContainer container,
  ) {}

  /// Called my providers when they emit a notification.
  ///
  /// - [newValue] will be `null` if the provider threw during initialization.
  /// - [previousValue] will be `null` if the previous build threw during initialization.
  void didUpdateProvider(
    ProviderBase provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {}

  /// A provider was disposed
  void didDisposeProvider(
    ProviderBase provider,
    ProviderContainer container,
  ) {}
}

/// An implementation detail for the override mechanism of providers
@internal
typedef SetupOverride = void Function({
  required ProviderBase origin,
  required ProviderBase override,
});

/// An object used by [ProviderContainer] to override the behavior of a provider
/// for a part of the application.
///
/// Do not implement/extend this class.
///
/// See also:
///
/// - [ProviderContainer], which uses this object.
/// - `overrideWithValue`, which creates a [ProviderOverride].
@internal
class ProviderOverride implements Override {
  /// Override a provider
  ProviderOverride({
    required ProviderBase origin,
    required ProviderBase override,
  })  : _origin = origin,
        _override = override;

  /// The provider that is overridden.
  final ProviderBase _origin;

  /// The new provider behaviour.
  final ProviderBase _override;
}

/// An object used by [ProviderContainer]/`ProviderScope` to override the behavior
/// of a provider/family for part of the application.
///
/// Do not extend or implement.
abstract class Override {}

/// An error thrown when a call to [Ref.read]/[Ref.watch]
/// leads to a provider depending on itself.
///
/// Circular dependencies are both not supported for performance reasons
/// and maintainability reasons.
/// Consider reading about unidirectional data flow to learn about the
/// benefits of avoiding circular dependencies.
class CircularDependencyError extends Error {
  CircularDependencyError._();
}
