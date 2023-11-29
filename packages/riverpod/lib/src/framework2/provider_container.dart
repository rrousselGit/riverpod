part of 'framework.dart';

class _Pointer {
  _Pointer({required this.isFromOverride});

  final bool isFromOverride;
  ProviderElement<Object?>? element;
}

class ProviderContainer {
  ProviderContainer({
    this.parent,
    List<Override> overrides = const [],
    List<ProviderObserver>? observers,
  }) : root = parent?.root ?? parent;

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
    addTearDown(container.dispose);

    return container;
  }

  final ProviderContainer? root;
  final ProviderContainer? parent;
  final _children = <ProviderContainer>[];
  final Map<Provider<Object?>, ProviderElement<Object?>> _providerPointers;

  void updateOverrides(List<Override> overrides);

  void debugReassemble();

  void invalidate(ProviderOrFamily provider);
  StateT refresh<StateT>(Refreshable<StateT> provider);

  StateT read<StateT>(ProviderListenable<StateT> provider) {
    final subscription = listen<StateT>(provider, (_, value) {});
    try {
      return subscription.read();
    } finally {
      subscription.close();
    }
  }

  ProviderSubscription<StateT> listen<StateT>(
    ProviderListenable<StateT> provider,
    void Function(StateT? previous, StateT next) listener, {
    bool fireImmediately = false,
    void Function(Object error, StackTrace stackTrace)? onError,
  });

  bool exists(Provider<Object?> provider);

  Future<void> pump();

  void dispose() {
    parent?._children.remove(this);
  }
}
