import 'package:meta/meta.dart';

import '../../core/async_value.dart';
import '../framework.dart';

abstract base class SyncProvider<StateT> extends Provider<StateT> {
  const SyncProvider({
    required super.name,
    required super.from,
    required super.arguments,
    required super.debugSource,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.isAlwaysAlive,
  });

  @internal
  StateT build(Ref<StateT> ref);

  Override overrideWith(Build<StateT, Ref<StateT>> create);

  Override overrideWithValue(StateT value);

  @override
  ProviderElement<StateT> createElement(ProviderContainer container) {
    return SyncProviderElement(this, container);
  }

  @visibleForOverriding
  @override
  ProviderSubscription<StateT> addListener(
    ProviderContainer container,
    void Function(StateT? previous, StateT next) listener, {
    required bool fireImmediately,
    required void Function(Object error, StackTrace stackTrace)? onError,
    required DebugDependentSource? debugDependentSource,
    required ProviderElement<Object?>? dependent,
    required void Function()? onCancel,
  }) {
    final element = getElement(
      container,
      debugDependentSource: debugDependentSource,
    ) as SyncProviderElement<StateT>;

    return element.addListener(
      listener,
      convert: (value) => value.requireValue,
      fireImmediately: fireImmediately,
      onError: onError,
      debugDependentSource: debugDependentSource,
      dependent: dependent,
      onCancel: onCancel,
    );
  }
}

class SyncProviderElement<StateT> extends ProviderElement<StateT> {
  SyncProviderElement(this.provider, super.container);

  final SyncProvider<StateT> provider;

  @override
  void build(Ref<StateT> ref) {
    try {
      setData(provider.build(ref));
    } catch (err, stack) {
      setError(err, stack);
    }
  }
}
