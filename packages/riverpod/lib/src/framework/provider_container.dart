part of '../framework.dart';

extension on String {
  String indentAfterFirstLine(int level) {
    final indent = '  ' * level;
    return split('\n').join('\n$indent');
  }
}

ProviderBase<Object?>? _circularDependencyLock;

abstract class _PointerBase {
  /// The container in which the element of this provider will be mounted.
  ProviderContainer get mountedContainer;

  /// The container that owns this pointer.
  /// May be equal to [mountedContainer] or one of its children.
  ProviderContainer get ownerContainer;
}

@internal
class ProviderPointer implements _PointerBase {
  ProviderPointer({
    required this.providerOverride,
    required this.mountedContainer,
    required this.ownerContainer,
  });

  /// The override associated with this provider, if any.
  ///
  /// If non-null, this pointer should **never** be removed.
  ///
  /// This override may be implicitly created by [ProviderOrFamily.allTransitiveDependencies].
  ProviderOverride? providerOverride;
  ProviderElementBase<Object?>? element;
  @override
  final ProviderContainer mountedContainer;
  @override
  final ProviderContainer ownerContainer;

  @override
  String toString() {
    final buffer = StringBuffer();
    buffer.writeln('ProviderPointer$hashCode(');

    buffer.writeln('  container: $mountedContainer');
    buffer.writeln('  override: $providerOverride');
    buffer.writeln('  element: $element');

    buffer.write(')');

    return buffer.toString();
  }
}

extension<PointerT extends _PointerBase, ProviderT extends ProviderOrFamily>
    on Map<ProviderT, PointerT> {
  /// - [currentContainer]: The container trying to read this pointer.
  PointerT _upsert(
    ProviderT provider, {
    required ProviderContainer currentContainer,
    required PointerT Function(ProviderContainer) inherit,
    required PointerT Function({ProviderT? override}) scope,
  }) {
    final pointer = this[provider];

    if (pointer != null) {
      if (provider.allTransitiveDependencies == null) {
        // The provider is not scoped, so can never be transitively overridden
        return pointer;
      }
      if (pointer.mountedContainer == currentContainer) {
        // The pointer isn't inherited but rather local to the current container,
        // so no need to check for transitive overrides.
        return pointer;
      }
    }

    if (currentContainer._pointerManager
        .hasLocallyOverriddenDependency(provider)) {
      return scope(override: provider);
    }

    // Where the provider should be mounted
    final target =

        /// If scoped, mount in the scope.
        pointer?.mountedContainer ??
            // If not scoped and in a child container, mount in the root
            currentContainer._root ??
            // We are in the root, mount here directly
            currentContainer;

    if (target == currentContainer) {
      return scope();
    }

    return inherit(target);
  }
}

@internal
class ProviderDirectory implements _PointerBase {
  ProviderDirectory.empty(
    ProviderContainer container, {
    required this.familyOverride,
  })  : pointers = HashMap(),
        mountedContainer = container,
        ownerContainer = container;

  ProviderDirectory.from(
    ProviderDirectory pointer, {
    required this.ownerContainer,
  })  : familyOverride = pointer.familyOverride,
        mountedContainer = pointer.mountedContainer,
        pointers = HashMap.fromEntries(
          pointer.pointers.entries.where((e) {
            if (e.key.allTransitiveDependencies == null) return true;
            if (e.value.providerOverride != null) return true;

            return false;
          }),
        );

  /// The override associated with this provider, if any.
  ///
  /// If non-null, this pointer should **never** be removed.
  ///
  /// This override may be implicitly created by [ProviderOrFamily.allTransitiveDependencies].
  FamilyOverride? familyOverride;
  final HashMap<ProviderBase<Object?>, ProviderPointer> pointers;
  @override
  final ProviderContainer mountedContainer;
  @override
  final ProviderContainer ownerContainer;

  void addProviderOverride(
    ProviderOverride override,
  ) {
    final origin = override.origin;
    final previousPointer = pointers[origin];

    if (previousPointer != null &&
        previousPointer.ownerContainer == ownerContainer) {
      throw StateError(
        'Cannot override a provider twice within the same container: $origin',
      );
    }

    pointers[origin] = ProviderPointer(
      mountedContainer: ownerContainer,
      ownerContainer: ownerContainer,
      providerOverride: override,
    );
  }

  ProviderPointer upsertPointer(ProviderBase<Object?> provider) {
    // TODO changelog that provider which don't specify depencies can't be scoped
    // TODO throw if a provider is overridden but does not specify dependencies

    return pointers._upsert(
      provider,
      currentContainer: ownerContainer,
      inherit: (target) => target._pointerManager.upsertPointer(provider),
      scope: ({override}) => ProviderPointer(
        mountedContainer: ownerContainer,
        ownerContainer: ownerContainer,
        providerOverride: override == null //
            ? null
            : _TransitiveProviderOverride(override),
      ),
    );
  }

  /// Initializes a provider and returns its pointer.
  ///
  /// Overridden providers, be it directly or transitively,
  /// are mounted in the current container.
  ///
  /// Non-overridden providers are mounted in the root container.
  ProviderPointer mount(ProviderBase<Object?> provider) {
    final pointer = upsertPointer(provider);

    if (pointer.element == null) {
      final element = provider.createElement(mountedContainer)
        // TODO remove
        .._provider = pointer.providerOverride?.providerOverride ?? provider
        // TODO remove
        .._origin = provider
        // TODO make this optional
        ..mount();
      pointer.element = element;
    }

    return pointer;
  }

  @override
  // ignore: annotate_overrides, https://github.com/dart-lang/linter/issues/4819
  String toString() {
    final buffer = StringBuffer();
    buffer.writeln('ProviderDirectory$hashCode(');

    buffer.writeln('  container: $mountedContainer');
    buffer.writeln('  override: $familyOverride');

    buffer.write('  pointers: {');
    for (final entry in pointers.entries) {
      buffer.write(
        '\n    ${entry.key}: ${entry.value.toString().indentAfterFirstLine(2)},',
      );
    }
    if (pointers.isNotEmpty) {
      buffer.writeln('\n  }');
    } else {
      buffer.writeln('}');
    }

    buffer.write(')');

    return buffer.toString();
  }
}

/// An object responsible for storing the a O(1) access to providers,
/// while also enabling the "scoping" of providers and ensuring all [ProviderContainer]s
/// are in sync.
///
/// Instead of storing a [Map<Provider, ProviderElement>], we voluntarily
/// introduce a level of indirection by storing a [Map<Provider, ProviderPointer>].
///
/// Then, when overriding a provider, it is guaranteed that the [ProviderContainer]
/// and all of its children have the same [ProviderPointer] for a overridden provider.
///
/// This way, we can read an overridden provider from any of the [ProviderContainer]s.
/// And no-matter where the first read is made, all [ProviderContainer]s will
/// share the same state.
@internal
class ProviderPointerManager {
  ProviderPointerManager(
    List<Override> overrides, {
    required this.container,
    required this.orphanPointers,
    HashMap<Family, ProviderDirectory>? familyPointers,
  }) : familyPointers = familyPointers ?? HashMap() {
    _initializeOverrides(overrides);
  }

  factory ProviderPointerManager.from(
    ProviderContainer parent,
    List<Override> overrides, {
    required ProviderContainer container,
  }) {
    if (overrides.isEmpty) return parent._pointerManager;

    return ProviderPointerManager(
      overrides,
      container: container,
      // Cloning the parent's pointers, so that we can add new pointers without
      // affecting the parent.
      // We do so only if an override is present, for performance's sake.
      // We have to always clone both types if any override is present because
      // of the possibility of providers being overridden transitively.
      orphanPointers: ProviderDirectory.from(
        parent._pointerManager.orphanPointers,
        ownerContainer: container,
      ),

      familyPointers: HashMap.fromEntries(
        parent._pointerManager.familyPointers.entries.map(
          (e) {
            if (e.key.allTransitiveDependencies == null) return e;

            if (e.value.familyOverride != null) return e;

            return MapEntry(
              e.key,
              ProviderDirectory.from(e.value, ownerContainer: container),
            );
          },
        ),
      ),
    );
  }

  final ProviderContainer container;
  ProviderDirectory orphanPointers;
  final HashMap<Family, ProviderDirectory> familyPointers;

  /// Creates a local pointer for a [Family], while preserving parent state.
  ProviderDirectory _scopeProviderDirectory(
    Family? family, {
    FamilyOverride? override,
  }) {
    final pointer = family == null ? orphanPointers : familyPointers[family];

    ProviderDirectory? newDirectory;
    if (pointer != null) {
      // The family is already overridden in this container. No need to fork.
      // This is purely an optimization.
      if (pointer.mountedContainer == container) return pointer;

      if (override == null) {
        // Fork a parent pointer, to keep its state but allow local modifications.
        newDirectory = ProviderDirectory.from(
          pointer,
          ownerContainer: container,
        );
      }
    }

    newDirectory ??= ProviderDirectory.empty(
      container,
      familyOverride: override,
    );

    if (family == null) {
      orphanPointers = newDirectory;
    } else {
      familyPointers[family] = newDirectory;
    }

    return newDirectory;
  }

  void _initializeProviderOverride(
    ProviderOverride override,
  ) {
    // Overriding a provider from a family, but not the whole family.
    // We don't want to modify the parent's family pointers,
    // therefore we need to fork the inherited family pointers.
    _scopeProviderDirectory(override.origin.from).addProviderOverride(override);
    // TODO: test that scoping a family provider does not impact the parent
    // TODO test that scoping a family provider does not impact other non-overridden providers from that family
  }

  void _initializeOverrides(List<Override> overrides) {
    for (final override in overrides) {
      switch (override) {
        case ProviderBase():
          _initializeProviderOverride(
            _ManualScopeProviderOverride(override),
          );
        case ProviderOverride():
          _initializeProviderOverride(override);
        case FamilyOverride():
          final overriddenFamily = override.from;

          final previousPointer = familyPointers[overriddenFamily];
          if (previousPointer != null &&
              previousPointer.mountedContainer == container &&
              previousPointer.familyOverride != null) {
            throw StateError(
              'Cannot override a family twice within the same container: $overriddenFamily',
            );
          }

          final pointer = _scopeProviderDirectory(
            overriddenFamily,
            override: override,
          );

          pointer.familyOverride = override;
      }
    }
  }

  /// Whether a provider was inserted at [container] instead of an ancestor.
  bool isLocallyMounted(ProviderOrFamily provider) {
    // If we are at the root, then providers are always mounted locally.
    if (this.container.parent == null) return true;

    ProviderContainer? container;

    switch (provider) {
      case ProviderBase<Object?>():
        container = readPointer(provider)?.mountedContainer ??
            readDirectory(provider)?.mountedContainer;
      case Family():
        container = familyPointers[provider]?.mountedContainer;
    }

    return container == this.container;
  }

  /// Whether a provider has a transitive dependency that is overridden in this container.
  bool hasLocallyOverriddenDependency(ProviderOrFamily provider) {
    if (container._parent == null) return false;

    final transitiveDependencies = provider.allTransitiveDependencies;

    /// If the provider has no dependencies, it cannot be locally overridden.
    if (transitiveDependencies == null) return false;

    for (final dependency in transitiveDependencies) {
      if (isLocallyMounted(dependency)) return true;
    }

    return false;
  }

  /// Initializes a family and returns its pointer.
  ///
  /// Overridden families, be it directly or transitively,
  /// are mounted in the current container.
  ///
  /// Non-overridden families are mounted in the root container.
  ProviderDirectory _mountFamily(Family family) {
    return familyPointers._upsert(
      family,
      currentContainer: container,
      inherit: (target) => ProviderDirectory.from(
        target._pointerManager._mountFamily(family),
        ownerContainer: target,
      ),
      scope: ({override}) => ProviderDirectory.empty(
        container,
        familyOverride: override == null //
            ? null
            : _TransitiveFamilyOverride(override),
      ),
    );
  }

  ProviderDirectory? readDirectory(ProviderBase<Object?> provider) {
    final from = provider.from;

    if (from == null) {
      return orphanPointers;
    } else {
      return familyPointers[from];
    }
  }

  ProviderPointer? readPointer(ProviderBase<Object?> provider) {
    return readDirectory(provider)?.pointers[provider];
  }

  ProviderElementBase<Object?>? readElement(ProviderBase<Object?> provider) {
    return readPointer(provider)?.element;
  }

  ProviderDirectory upsertDirectory(ProviderBase<Object?> provider) {
    final from = provider.from;

    if (from == null) {
      return orphanPointers;
    } else {
      //     // TODO debugAddDependency(element, debugDependentSource: debugDependentSource);
      return _mountFamily(from);
    }
  }

  ProviderPointer upsertPointer(ProviderBase<Object?> provider) {
    return upsertDirectory(provider).mount(provider);
  }

  ProviderElementBase<Object?> upsertElement(ProviderBase<Object?> provider) {
    return upsertPointer(provider).element!;
  }

  /// Traverse the [ProviderElementBase]s associated with this [ProviderContainer].
  Iterable<ProviderPointer> listProviderPointers() {
    return orphanPointers.pointers.values
        .where((pointer) => pointer.mountedContainer == container)
        .followedBy(
          familyPointers.values
              .where((pointer) => pointer.mountedContainer == container)
              .expand((e) => e.pointers.values),
        );
  }

  /// Read the [ProviderElementBase] for a provider, without creating it if it doesn't exist.
  Iterable<ProviderElementBase<Object?>> listFamily(Family family) {
    final _familyPointers = familyPointers[family];
    if (_familyPointers == null) return const [];

    return _familyPointers.pointers.values.map((e) {
      final element = e.element;
      // TODO debugAddDependency(element, debugDependentSource: debugDependentSource);

      return element;
    }).whereNotNull();
  }

  /// Remove a provider from this container.
  ///
  /// Noop if the provider is from an override or doesn't exist.
  ///
  /// Returns the associated pointer, even if it was not removed.
  ProviderPointer? remove(ProviderBase<Object?> provider) {
    // TODO remove in all containers

    final directory = readDirectory(provider);
    if (directory == null) return null;

    final pointer = directory.pointers[provider];
    // If null, nothing to remove. If from an override, must not be removed.
    if (pointer == null || pointer.providerOverride != null) {
      return pointer;
    }

    directory.pointers.remove(provider);

    final from = provider.from;
    if (from != null) {
      // Cleanup family if empty.
      // We do so only if it isn't from an override, as overrides are
      // must never be removed.
      if (directory.pointers.isEmpty && directory.familyOverride == null) {
        familyPointers.remove(from);
      }
    }

    return pointer;
  }

  @override
  String toString() {
    final buffer = StringBuffer();
    buffer.writeln('ProviderPointerManager#${shortHash(this)}(');

    buffer.writeln('  container: $container');
    buffer.writeln(
      '  orphanPointers: ${orphanPointers.toString().indentAfterFirstLine(2)}',
    );

    buffer.write('  familyPointers: {');

    for (final entry in familyPointers.entries) {
      buffer.write(
        '\n    ${entry.key}: ${entry.value.toString().indentAfterFirstLine(2)},',
      );
    }
    if (familyPointers.isNotEmpty) {
      buffer.writeln('\n  }');
    } else {
      buffer.writeln('}');
    }

    buffer.write(')');

    return buffer.toString();
  }
}

var _debugVerifyDependenciesAreRespectedEnabled = true;

int _tearDownCount = 0;

/// A callback that disposes a [ProviderContainer] inside tests
@internal
void Function() providerContainerTestTeardown(ProviderContainer container) {
  _tearDownCount++;

  return () {
    container.dispose();

    if (kDebugMode && _tearDownCount == 1) {
      test.expect(
        DebugRiverpodDevtoolBiding.containers,
        test.isEmpty,
      );
    }

    _tearDownCount--;
  };
}

/// {@template riverpod.provider_container}
/// An object that stores the state of the providers and allows overriding the
/// behavior of a specific provider.
///
/// If you are using Flutter, you do not need to care about this object
/// (outside of testing), as it is implicitly created for you by `ProviderScope`.
///
/// Inside tests, consider using [ProviderContainer.test].
/// This will automatically dispose the container at the end of the test.
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
    if (parent != null) {
      if (parent.disposed) {
        throw StateError(
          'Cannot create a ProviderContainer that has a disposed parent',
        );
      }
    }

    _pointerManager = parent != null
        ? ProviderPointerManager.from(parent, overrides, container: this)
        : ProviderPointerManager(
            overrides,
            container: this,
            orphanPointers: ProviderDirectory.empty(this, familyOverride: null),
          );

    // Mutate the parent & global state only at the very end.
    // This ensures that if an error is thrown, the parent & global state
    // are not affected.
    parent?._children.add(this);
    if (kDebugMode) DebugRiverpodDevtoolBiding.addContainer(this);
  }

  /// An automatically disposed [ProviderContainer].
  ///
  /// This also adds an internal check at the end of tests that verifies
  /// that all containers were disposed.
  ///
  /// This constructor works only inside tests, by relying on `package:test`'s
  /// `addTearDown`.
  @visibleForTesting
  factory ProviderContainer.test({
    ProviderContainer? parent,
    List<Override> overrides = const [],
    List<ProviderObserver>? observers,
  }) {
    // TODO changelog
    final container = ProviderContainer(
      parent: parent,
      overrides: overrides,
      observers: observers,
    );
    test.addTearDown(providerContainerTestTeardown(container));

    return container;
  }

  final int _debugOverridesLength;

  /// The object that handles when providers are refreshed and disposed.
  @internal
  late final ProviderScheduler scheduler = ProviderScheduler();

  /// How deep this [ProviderContainer] is in the graph of containers.
  ///
  /// Starts at 0.
  /// TODO check this is still used after refactoring
  final int depth;
  final ProviderContainer? _root;
  final ProviderContainer? _parent;

  final _children = <ProviderContainer>[];

  /// All the containers that have this container as `parent`.
  ///
  /// Do not use in production
  List<ProviderContainer> get debugChildren => UnmodifiableListView(_children);

  late final ProviderPointerManager _pointerManager;

  // final _overrideForProvider =
  //     HashMap<ProviderBase<Object?>, ProviderBase<Object?>>();
  // final _overrideForFamily = HashMap<Family, _FamilyOverrideRef>();
  // final Map<ProviderBase<Object?>, _StateReader> _stateReaders;

  /// The list of observers attached to this container.
  ///
  /// Observers can be useful for logging purpose.
  ///
  /// This list includes the observers of this container and that of its "parent"
  /// too.
  final List<ProviderObserver> observers;

  /// Whether [dispose] was called or not.
  ///
  /// This disables the different methods of [ProviderContainer], resulting in
  /// a [StateError] when attempting to use them.
  bool _disposed = false;

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
    return _pointerManager.readDirectory(provider)?.pointers[provider] != null;
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

  /// {@macro riverpod.invalidate}
  void invalidate(ProviderOrFamily provider) {
    switch (provider) {
      case ProviderBase<Object?>():
        _pointerManager.readElement(provider)?.invalidateSelf();
      case Family():
        for (final element in _pointerManager.listFamily(provider)) {
          element.invalidateSelf();
        }
    }
  }

  /// {@macro riverpod.refresh}
  StateT refresh<StateT>(Refreshable<StateT> refreshable) {
    ProviderBase<Object?> providerToRefresh;

    switch (refreshable) {
      case ProviderBase<StateT>():
        providerToRefresh = refreshable;
      case _ProviderRefreshable<StateT>(:final provider):
        providerToRefresh = provider;
      // TODO: Handle this case.
    }

    invalidate(providerToRefresh);
    return read(refreshable);
  }

  void _disposeProvider(ProviderBase<Object?> provider) {
    final pointer = _pointerManager.remove(provider);

    // The provider is already disposed, so we don't need to do anything
    if (pointer == null) return;

    pointer.element?.dispose();
    pointer.element = null;
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

    for (final override in overrides) {
      void debugValidateOverride(
        Override? previousOverride,
        Type newOverrideType,
      ) {
        if (previousOverride == null) {
          throw AssertionError(
            'Tried to update the override of a provider that was not overridden before',
          );
        }

        assert(
          previousOverride.runtimeType == newOverrideType,
          'Replaced the override of type ${previousOverride.runtimeType} '
          'with an override of type $newOverrideType, which is different.\n'
          'Changing the kind of override or reordering overrides is not supported.',
        );
      }

      switch (override) {
        case ProviderOverride():
          final pointer = _pointerManager.readPointer(override.origin);

          if (kDebugMode) {
            debugValidateOverride(
              pointer?.providerOverride,
              override.providerOverride.runtimeType,
            );
          }

          pointer!.providerOverride = override;

          final element = pointer.element;
          if (element == null) continue;

          runUnaryGuarded(element.update, override.providerOverride);

        case FamilyOverride():
          // TODO assert family override did not change

          final pointer = _pointerManager.familyPointers[override.from];

          if (kDebugMode) {
            debugValidateOverride(
              pointer?.familyOverride,
              override.runtimeType,
            );
          }

          pointer!.familyOverride = override;
      }
    }
  }

  /// TODO make private
  /// TODO remove generic
  @override
  ProviderElementBase<State> readProviderElement<State>(
    ProviderBase<State> provider,
  ) {
    if (_disposed) {
      throw StateError(
        'Tried to read a provider from a ProviderContainer that was already disposed',
      );
    }

    final element = _pointerManager.upsertElement(provider);

    // Assert that the the provider wouldn't have a more up-to-date value
    // if it was locally overridden.
    if (kDebugMode &&
        !_pointerManager.isLocallyMounted(provider) &&
        // Avoid having the assert trigger itself exponentially
        !_debugVerifyDependenciesAreRespectedEnabled) {
      try {
        _debugVerifyDependenciesAreRespectedEnabled = false;

        // Check that this containers doesn't have access to an overridden
        // dependency of the targeted provider
        final visitedDependencies = <ProviderBase<Object?>>{};
        final queue = Queue<ProviderBase<Object?>>();
        element.visitAncestors((e) => queue.add(e.origin));

        while (queue.isNotEmpty) {
          final dependency = queue.removeFirst();
          if (visitedDependencies.add(dependency)) {
            final dependencyElement = readProviderElement<Object?>(
              dependency,
            );

            assert(
              element.provider != element.origin ||
                  dependencyElement ==
                      element.container
                          .readProviderElement<Object?>(dependency),
              '''
Tried to read $provider from a place where one of its dependencies were overridden but the provider is not.

To fix this error, you can add $dependency (a) to the "dependencies" of $provider (b) such that we have:

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
    }

    return element as ProviderElementBase<State>;
  }

  void _dispose({
    // A flag to optimize recursive dispose calls.
    // When disposing a graph of containers, there is no need to call `children.remove`
    // individually, as all children will be disposed at once.
    required bool updateChildren,
  }) {
    if (_disposed) return;

    // We dispose children before disposing "this"
    // This is important to dispose providers from leaves to roots.
    // We can safely iterate over "children" without using "toList" thanks to
    // the "updateChildren" flag.
    for (final child in _children) {
      child._dispose(updateChildren: false);
    }

    _disposed = true;
    if (updateChildren) _parent?._children.remove(this);

    if (_root == null) scheduler.dispose();

    for (final element in getAllProviderElementsInOrder().toList().reversed) {
      element.dispose();
    }

    if (kDebugMode) {
      DebugRiverpodDevtoolBiding.removeContainer(this);
    }
  }

  /// Release all the resources associated with this [ProviderContainer].
  ///
  /// This will destroy the state of all providers associated with this
  /// [ProviderContainer] and call [Ref.onDispose] listeners.
  ///
  /// It is safe to call this method multiple times. Subsequent calls will be no-op.
  ///
  /// TODO changelog
  /// If this container has non-disposed child [ProviderContainer]s (cf `parent`),
  /// then this method will dispose those children first.
  /// Therefore, disposing the root [ProviderContainer] the entire graph.
  void dispose() => _dispose(updateChildren: true);

  /// Traverse the [ProviderElementBase]s associated with this [ProviderContainer].
  Iterable<ProviderElementBase<Object?>> getAllProviderElements() {
    return _pointerManager
        .listProviderPointers()
        .map((e) => e.element)
        .whereNotNull();
  }

  /// Visit all nodes of the graph at most once, from roots to leaves.
  ///
  /// This is fairly expensive and should be avoided as much as possible.
  /// If you do not need for providers to be sorted, consider using [getAllProviderElements]
  /// instead, which returns an unsorted list and is significantly faster.
  Iterable<ProviderElementBase<Object?>> getAllProviderElementsInOrder() sync* {
    final visitedNodes = HashSet<ProviderElementBase<Object?>>();
    final queue = DoubleLinkedQueue<ProviderElementBase<Object?>>();

    // get providers that don't depend on other providers from this container
    for (final pointer in _pointerManager.listProviderPointers()) {
      if (pointer.mountedContainer != this) continue;
      final element = pointer.element;
      if (element == null) continue;

      var hasAncestorsInContainer = false;
      element.visitAncestors((element) {
        // We ignore dependencies that are defined in another container, as
        // they are in a separate graph
        if (element.container == this) {
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
              if (e.container == this && !visitedNodes.contains(e)) {
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

  @override
  String toString() => 'ProviderContainer#${shortHash(this)}()';
}

@internal
extension ProviderContainerTest on ProviderContainer {
  bool get disposed => _disposed;

  ProviderContainer? get root => _root;
  ProviderContainer? get parent => _parent;

  List<ProviderContainer> get children => _children;

  ProviderPointerManager get pointerManager => _pointerManager;
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
