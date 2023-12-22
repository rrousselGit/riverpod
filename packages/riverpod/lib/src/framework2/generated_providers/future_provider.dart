import 'dart:async';

import 'package:meta/meta.dart';

import '../../core/async_value.dart';
import '../framework.dart';

abstract base class AsyncProvider<StateT> extends Provider<AsyncValue<StateT>> {
  const AsyncProvider({
    required super.name,
    required super.from,
    required super.arguments,
    required super.debugSource,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.isAlwaysAlive,
  });

  FutureOr<StateT> build(Ref<StateT> ref);

  Override overrideWith(Build<FutureOr<StateT>, Ref<StateT>> create);

  Override overrideWithValue(AsyncValue<StateT> value);

  @override
  ProviderElement<StateT> createElement(
    ProviderContainer container,
  ) {
    return AsyncProviderElement(this, container);
  }

  @visibleForOverriding
  @override
  ProviderSubscription<AsyncValue<StateT>> addListener(
    ProviderContainer container,
    void Function(AsyncValue<StateT>? previous, AsyncValue<StateT> next)
        listener, {
    required bool fireImmediately,
    required void Function(Object error, StackTrace stackTrace)? onError,
    required DebugDependentSource? debugDependentSource,
    required ProviderElement<Object?>? dependent,
    required void Function()? onCancel,
  }) {
    final element = getElement(
      container,
      debugDependentSource: debugDependentSource,
    ) as AsyncProviderElement<StateT>;

    return element.addListener(
      listener,
      convert: (value) => value,
      fireImmediately: fireImmediately,
      onError: onError,
      debugDependentSource: debugDependentSource,
      dependent: dependent,
      onCancel: onCancel,
    );
  }
}

class AsyncProviderElement<StateT> extends ProviderElement<StateT> {
  AsyncProviderElement(this.provider, super.container);

  final AsyncProvider<StateT> provider;

  @override
  FutureOr<void> build(Ref<StateT> ref) {
    try {
      final futureOr = provider.build(ref);

      if (futureOr is Future<StateT>) {
        // TODO handle cancellation
        return futureOr.then(
          setData,
          onError: setError,
        );
      } else {
        setData(futureOr);
      }
    } catch (err, stack) {
      setError(err, stack);
    }
  }
}
