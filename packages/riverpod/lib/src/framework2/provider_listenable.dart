part of 'framework.dart';

@immutable
mixin ProviderListenable<StateT> implements ProviderListenableOrFamily {
  @visibleForOverriding
  ProviderSubscription<StateT> addListener(
    ProviderContainer container,
    void Function(StateT? previous, StateT next) listener, {
    required bool fireImmediately,
    required void Function(Object error, StackTrace stackTrace)? onError,
    required DebugDependentSource? debugDependentSource,
  });

  ProviderListenable<T> select<T>(T Function(StateT value) selector) {}
}

abstract class ProviderSubscription<StateT> {
  const ProviderSubscription();

  StateT read();

  void pause();
  void resume();

  void close();
}

mixin Refreshable<StateT> on ProviderListenable<StateT> {}
