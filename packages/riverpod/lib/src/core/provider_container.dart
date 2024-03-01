part of '../framework.dart';

extension on String {
  String indentAfterFirstLine(int level) {
    final indent = '  ' * level;
    return split('\n').join('\n$indent');
  }
}

abstract class _PointerBase {
  bool get isTransitiveOverride;

  /// The container in which the element of this provider will be mounted.
  ProviderContainer get targetContainer;
}

@internal
class ProviderPointer implements _PointerBase {
  ProviderPointer({
    required this.providerOverride,
    required this.targetContainer,
  });

  @override
  bool get isTransitiveOverride =>
      providerOverride is TransitiveProviderOverride;

  /// The override associated with this provider, if any.
  ///
  /// If non-null, this pointer should **never** be removed.
  ///
  /// This override may be implicitly created by [ProviderOrFamily.allTransitiveDependencies].
  // ignore: library_private_types_in_public_api, not public API
  _ProviderOverride? providerOverride;
  ProviderElementBase<Object?>? element;
  @override
  final ProviderContainer targetContainer;

  @override
  String toString() {
    final buffer = StringBuffer();
    buffer.writeln('ProviderPointer$hashCode(');

    buffer.writeln('  targetContainer: $targetContainer');
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
    required ProviderContainer? targetContainer,
    required PointerT Function(ProviderContainer) inherit,
    required PointerT Function({ProviderT? override}) scope,
  }) {
    final pointer = this[provider];
    if (pointer != null) return pointer;

    final deepestTransitiveDependencyContainer = currentContainer
        ._pointerManager
        .findDeepestTransitiveDependencyProviderContainer(provider);

    final target = deepestTransitiveDependencyContainer ??
        pointer?.targetContainer ??
        targetContainer ??
        currentContainer._root ??
        currentContainer;

    if (target == currentContainer) {
      return this[provider] = scope(
        override:
            deepestTransitiveDependencyContainer == null ? null : provider,
      );
    }

    return this[provider] = inherit(target);
  }
}

@internal
class ProviderDirectory implements _PointerBase {
  ProviderDirectory.empty(
    ProviderContainer container, {
    required this.familyOverride,
  })  : pointers = HashMap(),
        targetContainer = container;

  ProviderDirectory.from(
    ProviderDirectory pointer,
  )   : familyOverride = pointer.familyOverride,
        targetContainer = pointer.targetContainer,
        pointers = HashMap.fromEntries(
          pointer.pointers.entries.where((e) => !e.value.isTransitiveOverride),
        );

  @override
  bool get isTransitiveOverride => familyOverride is TransitiveFamilyOverride;

  /// The override associated with this provider, if any.
  ///
  /// If non-null, this pointer should **never** be removed.
  ///
  /// This override may be implicitly created by [ProviderOrFamily.allTransitiveDependencies].
  // ignore: library_private_types_in_public_api, not public API
  _FamilyOverride? familyOverride;
  final HashMap<ProviderBase<Object?>, ProviderPointer> pointers;
  @override
  ProviderContainer targetContainer;

  void addProviderOverride(
    // ignore: library_private_types_in_public_api, not public API
    _ProviderOverride override, {
    required ProviderContainer targetContainer,
  }) {
    final origin = override.origin;

    pointers[origin] = ProviderPointer(
      targetContainer: targetContainer,
      providerOverride: override,
    );
  }

  ProviderPointer upsertPointer(
    ProviderBase<Object?> provider, {
    required ProviderContainer currentContainer,
  }) {
    // TODO changelog that provider which don't specify dependencies can't be scoped
    // TODO throw if a provider is overridden but does not specify dependencies

    return pointers._upsert(
      provider,
      currentContainer: currentContainer,
      targetContainer: targetContainer,
      inherit: (target) => target._pointerManager.upsertPointer(provider),
      scope: ({override}) => ProviderPointer(
        targetContainer: currentContainer,
        providerOverride: override == null || provider.from != null //
            ? null
            : TransitiveProviderOverride(override),
      ),
    );
  }

  /// Initializes a provider and returns its pointer.
  ///
  /// Overridden providers, be it directly or transitively,
  /// are mounted in the current container.
  ///
  /// Non-overridden providers are mounted in the root container.
  ProviderPointer mount(
    ProviderBase<Object?> origin, {
    required ProviderContainer currentContainer,
  }) {
    final pointer = upsertPointer(
      origin,
      currentContainer: currentContainer,
    );

    if (pointer.element == null) {
      ProviderElementBase<Object?>? element;

      switch ((pointer.providerOverride, familyOverride)) {
        // The provider is overridden. This takes over any family override
        case (final override?, _):
          element =
              override.providerOverride.$createElement(pointer.targetContainer);

        // The family was overridden using overrideWith & co.
        case (null, final $FamilyOverride override):
          element = override.createElement(pointer.targetContainer, origin);

        // Either the provider wasn't overridden or it was scoped.
        case (null, _FamilyOverride() || null):
          element = origin.$createElement(pointer.targetContainer);
      }

      /// Assigning the element before calling "mount" to guarantee
      /// that even if something goes very wrong, such as a recursive
      /// initialization or "mount" throwing, next read will not try to
      /// initialize the provider again.
      /// This has otherwise no impact unless there is a bug.
      pointer.element = element;

      // TODO test family(42) overrides on nested containers receive the correct container
      element
        // TODO remove
        .._origin = origin
        // TODO make this optional
        ..mount();
    }

    return pointer;
  }

  @override
  String toString() {
    final buffer = StringBuffer();
    buffer.writeln('ProviderDirectory$hashCode(');

    buffer.writeln('  targetContainer: $targetContainer');
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
      // Always folks orphan pointers, because of possible transitive overrides.
      orphanPointers: ProviderDirectory.from(
        parent._pointerManager.orphanPointers,
      ),

      familyPointers: HashMap.fromEntries(
        parent._pointerManager.familyPointers.entries
            .where((e) => !e.value.isTransitiveOverride)
            .map(
          (e) {
            if (e.key.allTransitiveDependencies == null) return e;

            // TODO don't fork a family if no family(42) is overridden

            return MapEntry(e.key, ProviderDirectory.from(e.value));
          },
        ),
      ),
    );
  }

  final ProviderContainer container;
  final ProviderDirectory orphanPointers;
  final HashMap<Family, ProviderDirectory> familyPointers;

  void _initializeProviderOverride(
    _ProviderOverride override,
  ) {
    final from = override.origin.from;

    if (from == null) {
      orphanPointers.addProviderOverride(
        override,
        targetContainer: container,
      );
      return;
    }

    final familyPointer = familyPointers[from] ??= ProviderDirectory.empty(
      // TODO use rootOrSelf
      container._root ?? container,
      familyOverride: null,
    );

    familyPointer.addProviderOverride(
      override,
      targetContainer: container,
    );
  }

  void _initializeOverrides(List<Override> overrides) {
    for (final override in overrides) {
      switch (override) {
        case _ProviderOverride():
          _initializeProviderOverride(override);
        case _FamilyOverride():
          final overriddenFamily = override.from;

          final previousPointer = familyPointers[overriddenFamily];
          if (previousPointer != null) {
            /// A provider from that family was overridden first.
            /// We override the family but preserve the provider overrides too.

            previousPointer
              ..familyOverride = override
              ..targetContainer = container
              // Remove inherited family values and keep only local ones
              ..pointers.removeWhere(
                (key, value) => value.targetContainer != container,
              );
            continue;
          }

          familyPointers[overriddenFamily] = ProviderDirectory.empty(
            container,
            familyOverride: override,
          );
      }
    }
  }

  /// Obtains the [ProviderContainer] in which provider/family should be mounted,
  /// if the provider is locally scoped.
  ///
  /// Returns `null` if it should be mounted at the root.
  ProviderContainer? findDeepestTransitiveDependencyProviderContainer(
    ProviderOrFamily provider,
  ) {
    if (container._parent == null) return null;

    final transitiveDependencies = provider.allTransitiveDependencies;

    /// If the provider has no dependencies, it cannot be locally overridden.
    if (transitiveDependencies == null) return null;

    ProviderContainer? deepestContainer;
    for (final dependency in transitiveDependencies) {
      final target = switch (dependency) {
        Family() => familyPointers[dependency]?.targetContainer,
        ProviderBase() => readPointer(dependency)?.targetContainer,
      };
      if (target == null || target.depth == 0) continue;
      if (deepestContainer == null || deepestContainer.depth < target.depth) {
        deepestContainer = target;
      }
    }

    return deepestContainer;
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
      targetContainer: null,
      inherit: (target) => target._pointerManager._mountFamily(family),
      scope: ({override}) => ProviderDirectory.empty(
        container,
        familyOverride: override == null //
            ? null
            : TransitiveFamilyOverride(override),
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
    return upsertDirectory(provider).mount(
      provider,
      currentContainer: container,
    );
  }

  ProviderElementBase<Object?> upsertElement(ProviderBase<Object?> provider) {
    return upsertPointer(provider).element!;
  }

  /// Traverse the [ProviderElementBase]s associated with this [ProviderContainer].
  Iterable<ProviderPointer> listProviderPointers() {
    return orphanPointers.pointers.values
        .where((pointer) => pointer.targetContainer == container)
        .followedBy(
          familyPointers.values
              .where((pointer) => pointer.targetContainer == container)
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
    // If null, nothing to remove.
    if (pointer == null) return null;
    // If from an override, must not be removed unless it is a transitive override
    if (pointer.providerOverride != null &&
        pointer.providerOverride is! TransitiveProviderOverride) {
      return pointer;
    }

    directory.pointers.remove(provider);

    final from = provider.from;
    // Cleanup family if empty.
    // We do so only if it isn't from an override, as overrides are
    // must never be removed.
    if (from != null && directory.pointers.isEmpty) {
      if (directory.familyOverride == null ||
          directory.familyOverride is TransitiveFamilyOverride) {
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

    if (kDebugMode) {
      final overrideOrigins = <Object?>{};
      for (final override in overrides) {
        switch (override) {
          case _ProviderOverride():
            if (parent != null &&
                override.origin.allTransitiveDependencies == null &&
                override.origin.from?.allTransitiveDependencies == null) {
              throw AssertionError(
                'Tried to scope a provider that did not specify "dependencies": ${override.origin}',
              );
            }

            if (!overrideOrigins.add(override.origin)) {
              throw AssertionError(
                'Tried to override a provider twice within the same container: ${override.origin}',
              );
            }
          case _FamilyOverride():
            if (parent != null &&
                override.from.allTransitiveDependencies == null) {
              throw AssertionError(
                'Tried to scope a family that did not specify "dependencies": ${override.from}',
              );
            }

            if (!overrideOrigins.add(override.from)) {
              throw AssertionError(
                'Tried to override a family twice within the same container: ${override.from}',
              );
            }
        }
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
    test.addTearDown(container.dispose);

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
    // TODO should be recursive
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
    return _pointerManager
            .readDirectory(provider)
            ?.pointers[provider]
            ?.element !=
        null;
  }

  /// Executes [ProviderElementBase.debugReassemble] on all the providers.
  void debugReassemble() {
// TODO hot-reload handle provider type change
// TODO hot-reload handle provider response type change
// TODO hot-reload handle provider -> family
// TODO hot-reload handle family adding parameters
// TODO found "Future already completed error" after adding family parameter

    if (kDebugMode) {
      for (final element in getAllProviderElements()) {
        element.debugReassemble();
      }
    }
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
  void invalidate(
    ProviderOrFamily provider, {
    bool asReload = false,
  }) {
    switch (provider) {
      case ProviderBase<Object?>():
        _pointerManager
            .readElement(provider)
            ?.invalidateSelf(asReload: asReload);
      case Family():
        for (final element in _pointerManager.listFamily(provider)) {
          element.invalidateSelf(asReload: asReload);
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

  void _recursivePointerRemoval(
    ProviderBase<Object?> provider,
    ProviderPointer pointer,
  ) {
    for (final child in _children) {
      final childPointer = child._pointerManager.readPointer(provider);

      if (childPointer != null && childPointer != pointer) {
        continue;
      }

      child._recursivePointerRemoval(provider, pointer);
    }

    _pointerManager.remove(provider);
  }

  void _disposeProvider(ProviderBase<Object?> provider) {
    final pointer = _pointerManager.remove(provider);
    // The provider is already disposed, so we don't need to do anything
    if (pointer == null) return;

    _recursivePointerRemoval(provider, pointer);

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
        case _ProviderOverride():
          final pointer = _pointerManager.readPointer(override.origin);

          if (kDebugMode) {
            debugValidateOverride(
              pointer?.providerOverride,
              override.runtimeType,
            );
          }

          pointer!.providerOverride = override;

          final element = pointer.element;
          if (element == null) continue;

          runUnaryGuarded(element.update, override.providerOverride);

        case _FamilyOverride():
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
        .whereNotNull()
        .where((e) => e.container == this);
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
      if (pointer.targetContainer != this) continue;
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
        listenableVisitor: (_) {},
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
// TODO changelog: CircularDependencyError is no-longer exported
@internal
class CircularDependencyError extends Error {
  CircularDependencyError._();
}
