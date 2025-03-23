part of '../framework.dart';

ProviderBase<Object?>? _circularDependencyLock;

class _FamilyOverrideRef {
  _FamilyOverrideRef(this.override, this.container);

  FamilyOverride<Object?> override;
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

  final ProviderBase<Object?> origin;
  ProviderBase<Object?> override;
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

      return element;
    } finally {
      if (_circularDependencyLock == origin) {
        _circularDependencyLock = null;
      }
    }
  }
}

var _debugVerifyDependenciesAreRespectedEnabled = true;

/// {@template riverpod.provider_container}
/// An object that stores the state of the providers and allows overriding the
/// behavior of a specific provider.
///
/// If you are using Flutter, you do not need to care about this object
/// (outside of testing), as it is implicitly created for you by `ProviderScope`.
/// {@endtemplate}
@sealed
class ProviderContainer implements Node {
  /// {@macro riverpod.provider_container}
  ProviderContainer({
    ProviderContainer? parent,
    List<Override> overrides = const [],
    List<ProviderObserver>? observers,
  })  : _debugOverridesLength = overrides.length,
        depth = parent == null ? 0 : parent.depth + 1,
        _parent = parent,
        observers = [
          ...?observers,
          if (parent != null) ...parent.observers,
        ],
        _root = parent?._root ?? parent {
    _legacyPointerManager = _PointerManager(
      container: this,
      parent: parent?._legacyPointerManager,
    );
    if (parent != null) {
      parent._children.add(this);
    }

    _legacyPointerManager.setupOverrides(overrides);
  }

  final int _debugOverridesLength;

  /// A function that controls the refresh rate of providers.
  ///
  /// Defaults to refreshing providers at the end of the next event-loop.
  @Deprecated('Will be removed in 3.0.0')
  @internal
  void Function(void Function() task) get vsync {
    return vsyncOverride ?? _defaultVsync;
  }

  /// A way to override [vsync], used by Flutter to synchronize a container
  /// with the widget tree.
  @Deprecated('Will be removed in 3.0.0')
  @internal
  void Function(void Function() task)? vsyncOverride;

  /// The object that handles when providers are refreshed and disposed.
  @internal
  late final ProviderScheduler scheduler = ProviderScheduler();

  /// How deep this [ProviderContainer] is in the graph of containers.
  ///
  /// Starts at 0.
  final int depth;
  final ProviderContainer? _root;
  final ProviderContainer? _parent;

  final _children = <ProviderContainer>[];

  /// All the containers that have this container as `parent`.
  ///
  /// Do not use in production
  List<ProviderContainer> get debugChildren => UnmodifiableListView(_children);

  /// The list of observers attached to this container.
  ///
  /// Observers can be useful for logging purpose.
  ///
  /// This list includes the observers of this container and that of its "parent"
  /// too.
  final List<ProviderObserver> observers;

  late final _PointerManager _legacyPointerManager;

  /// A debug utility used by `flutter_riverpod`/`hooks_riverpod` to check
  /// if it is safe to modify a provider.
  ///
  /// This corresponds to all the widgets that a [Provider] is associated with.
  @Deprecated('Will be removed in 3.0.0')
  @internal
  void Function()? debugCanModifyProviders;

  /// Whether [dispose] was called or not.
  ///
  /// This disables the different methods of [ProviderContainer], resulting in
  /// a [StateError] when attempting to use them.
  bool _disposed = false;

  /// An internal utility for checking if a [ProviderContainer] has a fast
  /// path for reading a provider.
  ///
  /// This should not be used and is an implementation detail of [ProviderContainer].
  /// It could be removed at any time without a major version bump.
  @internal
  bool hasStateReaderFor(ProviderListenable<Object?> provider) =>
      _legacyPointerManager.hasStateReaderFor(provider);

  /// Awaits for providers to rebuild/be disposed and for listeners to be notified.
  Future<void> pump() async {
    final a = scheduler.pendingFuture;
    final b = _parent?.scheduler.pendingFuture;

    await Future.wait<void>([
      if (a != null) a,
      if (b != null) b,
    ]);
  }

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

  /// {@macro riverpod.exists}
  bool exists(ProviderBase<Object?> provider) {
    final element = _legacyPointerManager._getOrNull(provider)?._element;

    return element != null;
  }

  /// Executes hot-reload on all the providers.
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

  /// {@macro riverpod.invalidate}
  void invalidate(ProviderOrFamily provider) {
    if (provider is ProviderBase) {
      final reader = _getOrNull(provider);

      reader?._element?.invalidateSelf();
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

  /// {@macro riverpod.refresh}
  State refresh<State>(Refreshable<State> provider) {
    invalidate(provider._origin);
    return read(provider);
  }

  /// Updates the list of provider overrides.
  ///
  /// If you are using flutter, this is done implicitly for you by `ProviderScope`.
  ///
  /// Updating a `overrideWithValue` with a different value
  /// will cause the listeners to rebuild.
  ///
  /// It is not possible, to remove or add new overrides, only update existing ones.
  void updateOverrides(List<Override> overrides) =>
      _legacyPointerManager.updateOverrides(overrides);

  @internal
  @override
  ProviderElementBase<State> readProviderElement<State>(
    ProviderBase<State> provider,
  ) {
    if (_disposed) {
      throw StateError(
        'Tried to read a provider from a ProviderContainer that was already disposed',
      );
    }

    return _legacyPointerManager.readProviderElement<State>(provider);
  }

  /// Release all the resources associated with this [ProviderContainer].
  ///
  /// This will destroy the state of all providers associated with this
  /// [ProviderContainer] and call [Ref.onDispose] listeners.
  void dispose() {
    if (_disposed) return;

    _disposed = true;
    _parent?._children.remove(this);

    if (_root == null) scheduler.dispose();

    for (final element in getAllProviderElementsInOrder().toList().reversed) {
      element.dispose();
    }
  }

  /// Traverse the [ProviderElementBase]s associated with this [ProviderContainer].
  @internal
  Iterable<ProviderElementBase> getAllProviderElements() sync* {
    for (final reader in _legacyPointerManager._stateReaders.values) {
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
  @internal
  Iterable<ProviderElementBase> getAllProviderElementsInOrder() sync* {
    final visitedNodes = HashSet<ProviderElementBase>();
    final queue = DoubleLinkedQueue<ProviderElementBase>();

    // get providers that don't depend on other providers from this container
    for (final reader in _legacyPointerManager._stateReaders.values) {
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
    ProviderBase<Object?> provider,
    Object? value,
    ProviderContainer container,
  ) {}

  /// A provider emitted an error, be it by throwing during initialization
  /// or by having a [Future]/[Stream] emit an error
  void providerDidFail(
    ProviderBase<Object?> provider,
    Object error,
    StackTrace stackTrace,
    ProviderContainer container,
  ) {}

  /// Called by providers when they emit a notification.
  ///
  /// - [newValue] will be `null` if the provider threw during initialization.
  /// - [previousValue] will be `null` if the previous build threw during initialization.
  void didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {}

  /// A provider was disposed
  void didDisposeProvider(
    ProviderBase<Object?> provider,
    ProviderContainer container,
  ) {}
}

/// An implementation detail for the override mechanism of providers
@internal
typedef SetupOverride = void Function({
  required ProviderBase<Object?> origin,
  required ProviderBase<Object?> override,
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
    required ProviderBase<Object?> origin,
    required ProviderBase<Object?> override,
  })  : _origin = origin,
        _override = override;

  /// The provider that is overridden.
  final ProviderBase<Object?> _origin;

  /// The new provider behavior.
  final ProviderBase<Object?> _override;
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
