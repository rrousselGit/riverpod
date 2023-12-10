part of 'framework.dart';

class _ProviderPointer {
  _ProviderPointer({required this.isFromOverride});

  /// Whether this pointer was created from an override.
  ///
  /// If so, this pointer should **never** be removed.
  final bool isFromOverride;
  ProviderElement<Object?>? element;
}

/// An object responsible for storing the a O(1) access to providers,
/// while also enabling the "scoping" of providers and ensuring all [ProviderContainer]s
/// are in sync.
///
/// Instead of storing a [Map<Provider, ProviderElement], we voluntarily
/// introduce a level of indirection by storing a [Map<Provider, _ProviderPointer>].
///
/// Then, when overriding a provider, it is guaranteed that the [ProviderContainer]
/// and all of its children have the same [_ProviderPointer] for a overridden provider.
///
/// This way, we can read an overridden provider from any of the [ProviderContainer]s.
/// And no-matter where the first read is made, all [ProviderContainer]s will
/// share the same state.
class _ProviderPointers {
  _ProviderPointers()
      : _orphanPointers = HashMap(),
        _familyPointers = HashMap();

  _ProviderPointers.from(ProviderContainer parent)
      : _orphanPointers =
            HashMap.from(parent._providerPointers._orphanPointers),
        _familyPointers =
            HashMap.from(parent._providerPointers._familyPointers);

  late final ProviderContainer container;
  final HashMap<Provider<Object?>, _ProviderPointer> _orphanPointers;
  final HashMap<Family, HashMap<Provider<Object?>, _ProviderPointer>>
      _familyPointers;

  /// Obtain and possibly mount the [ProviderElement] for a provider.
  ProviderElement<Object?> add(
    Provider<Object?> provider, {
    required bool isFromOverride,
    required DebugDependentSource? debugDependentSource,
  }) {
    final from = provider.from;

    _ProviderPointer mount() {
      final pointer = _ProviderPointer(isFromOverride: isFromOverride);
      final element = provider.createElement(container);
      pointer.element = element;

      return pointer;
    }

    if (from == null) {
      final pointer = _orphanPointers.putIfAbsent(provider, mount);
      final element = pointer.element!;
      // TODO debugAddDependency(element, debugDependentSource: debugDependentSource);

      return element;
    } else {
      final _familyPointers =
          this._familyPointers.putIfAbsent(from, HashMap.new);
      final pointer = _familyPointers.putIfAbsent(provider, mount);
      final element = pointer.element!;
      // TODO   debugAddDependency(element, debugDependentSource: debugDependentSource);

      return element;
    }
  }

  /// Obtain the pointer for a provider. Noop if it doesn't exist.
  _ProviderPointer? _readPointer(Provider<Object?> provider) {
    final from = provider.from;

    if (from == null) {
      return _orphanPointers[provider];
    } else {
      return _familyPointers[from]?[provider];
    }
  }

  /// Read the [ProviderElement] for a provider, without creating it if it doesn't exist.
  ProviderElement<Object?>? read(
    Provider<Object?> provider, {
    required DebugDependentSource? debugDependentSource,
  }) {
    final element = _readPointer(provider)?.element;
// TODO    debugAddDependency(element, debugDependentSource: debugDependentSource);

    return element;
  }

  /// Read the [ProviderElement] for a provider, without creating it if it doesn't exist.
  Iterable<ProviderElement<Object?>> readFamily(
    Family family, {
    required DebugDependentSource? debugDependentSource,
  }) {
    final _familyPointers = this._familyPointers[family];
    if (_familyPointers == null) return const [];

    return _familyPointers.values.map((e) {
      final element = e.element;
      // TODO debugAddDependency(element, debugDependentSource: debugDependentSource);

      return element;
    }).whereNotNull();
  }

  /// Remove a provider from this container.
  ///
  /// Noop if the provider is from an override or doesn't exist.
  void remove(Provider<Object?> provider) {
    final pointer = _readPointer(provider);
    // If null, nothing to remove. If from an override, must not be removed.
    if (pointer == null || pointer.isFromOverride) {
      return;
    }

    final from = provider.from;

    if (from == null) {
      _orphanPointers.remove(provider);
    } else {
      final familyPointer = _familyPointers[from];

      // Nothing to remove
      if (familyPointer == null) return;
      familyPointer.remove(provider);

      // Cleanup family if empty

      // The family isn't empty, nothing to do
      if (familyPointer.isNotEmpty) return;
      // The family is empty, remove it.
      // It should be guaranteed that there this won't remove scoped provider pointers
      // as there's a "isFromOverride" check at the beginning of this method.
      _familyPointers.remove(from);
    }
  }
}

final class ProviderContainer {
  ProviderContainer({
    this.parent,
    List<Override> overrides = const [],
    List<ProviderObserver>? observers,
  })  : root = parent?.root ?? parent,
        _providerPointers = parent != null
            ? _ProviderPointers.from(parent)
            : _ProviderPointers() {
    _providerPointers.container = this;
  }

  @visibleForTesting
  factory ProviderContainer.test({
    ProviderContainer? parent,
    List<Override> overrides = const [],
    List<ProviderObserver>? observers,
  }) {
    final container = ProviderContainer(
      parent: parent,
      overrides: overrides,
      observers: observers,
    );
    test.addTearDown(container.dispose);

    return container;
  }

  final ProviderContainer? root;
  final ProviderContainer? parent;
  final _children = <ProviderContainer>[];
  final _ProviderPointers _providerPointers;
  var _disposed = false;
  final _scheduler = SchedulerBinding();

  // TODO void updateOverrides(List<Override> overrides);

  // TODO void debugReassemble();

  void invalidate(
    ProviderOrFamily provider, {
    bool asReload = false,
    @internal DebugDependentSource? debugDependentSource,
  }) {
    switch (provider) {
      case Provider<Object?>():
        _providerPointers
            .read(
              provider,
              debugDependentSource: kDebugMode
                  ? (debugDependentSource ??
                      DebugProviderContainerInvalidateDependentSource(
                        container: this,
                      ))
                  : null,
            )
            ?.markNeedsRebuild(asReload: asReload);
      case Family():
        final elements = _providerPointers.readFamily(
          provider,
          debugDependentSource: debugDependentSource,
        );
        for (final element in elements) {
          element.markNeedsRebuild(asReload: asReload);
        }
    }
  }

  StateT refresh<StateT>(
    Refreshable<StateT> provider, {
    @internal DebugDependentSource? debugDependentSource,
  }) {
    invalidate(
      provider._refreshed,
      debugDependentSource: kDebugMode
          ? (debugDependentSource ??
              DebugProviderContainerRefreshDependentSource(container: this))
          : null,
    );

    return read(
      provider,
      debugDependentSource: kDebugMode
          ? (debugDependentSource ??
              DebugProviderContainerRefreshDependentSource(container: this))
          : null,
    );
  }

  ProviderElement<Object?> _insertProvider(
    Provider<Object?> provider, {
    required DebugDependentSource? debugDependentSource,
  }) {
    return _providerPointers.add(
      provider,
      // If the provider points to an override, a pointer should already be set.
      // So always using `false` isn't an issue.
      isFromOverride: false,
      debugDependentSource: debugDependentSource,
    );
  }

  StateT read<StateT>(
    ProviderListenable<StateT> provider, {
    @internal DebugDependentSource? debugDependentSource,
  }) {
    final subscription = listen<StateT>(
      provider,
      (_, value) {},
      debugDependentSource: kDebugMode
          ? (debugDependentSource ??
              DebugProviderContainerReadDependentSource(container: this))
          : null,
    );
    try {
      return subscription.read();
    } finally {
      subscription.close();
    }
  }

  ProviderSubscription<StateT> listen<StateT>(
    ProviderListenable<StateT> provider,
    ProviderListener<StateT> listener, {
    bool fireImmediately = false,
    OnError? onError,
    @internal DebugDependentSource? debugDependentSource,
    OnCancel? onCancel,
  }) {
    return provider.addListener(
      this,
      listener,
      fireImmediately: fireImmediately,
      onError: onError,
      onCancel: onCancel,
      dependent: null,
      debugDependentSource: kDebugMode
          ? (debugDependentSource ??
              DebugProviderContainerListenDependentSource(container: this))
          : null,
    );
  }

  bool exists(
    Provider<Object?> provider, {
    @internal DebugDependentSource? debugDependentSource,
  }) {
    return _providerPointers.read(
          provider,
          debugDependentSource: kDebugMode
              ? (debugDependentSource ??
                  DebugProviderContainerExistsDependentSource(container: this))
              : null,
        ) !=
        null;
  }

  // TODO Future<void> pump();

  void dispose() {
    if (_disposed) return;

    _disposed = true;
    parent?._children.remove(this);
  }
}

@internal
extension ProviderContainerTest on ProviderContainer {
  bool get disposed => _disposed;
}
