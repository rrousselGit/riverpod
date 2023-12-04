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
    required ProviderElement<Object?>? dependent,
    required void Function()? onCancel,
  });

  ProviderListenable<T> select<T>(T Function(StateT value) selector) {}
}

abstract class ProviderSubscription<StateT> {
  StateT read();

  /// Pause the subscription.
  ///
  /// While paused, the subscription will not notify listeners.
  /// If all subscriptions of a provider are paused, the provider itself
  /// will be paused (invoking [Ref.onCancel]). From there on, the provider
  /// will not rebuild unless read even if a dependency changes.
  ///
  /// If the subscription is already paused, calling [pause] again will have no effect.
  ///
  /// Calling [resume] will resume the subscription.
  /// The [resume] method will have to be called as many times as [pause] was called.
  void pause();

  /// Resume the subscription.
  ///
  /// If the subscription is not paused, calling [resume] will have no effect.
  ///
  /// If the subscription was paused multiple times, it is necessary to call
  /// [resume] as many times as [pause] was called to resume the subscription.
  /// If resuming a subscription on a provider that is paused, the provider
  /// will be resumed as well (invoking [Ref.onResume]).
  ///
  /// See also:
  /// - [pause], which pauses the subscription.
  void resume();

  void close();
}

mixin Refreshable<StateT> on ProviderListenable<StateT> {}
