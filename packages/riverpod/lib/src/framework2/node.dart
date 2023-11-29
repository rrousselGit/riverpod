part of 'framework.dart';

@internal
class DebugDependentSource {}

@internal
sealed class DebugConsumerDependentSource extends DebugDependentSource {
  DebugConsumerDependentSource({required this.consumer});

  final Consumer consumer;
}

@internal
sealed class DebugProviderDependentSource extends DebugDependentSource {
  DebugProviderDependentSource({required this.provider});

  final Provider<Object?> provider;
}

@internal
sealed class DebugRefWatchDependentSource extends DebugProviderDependentSource {
  DebugRefWatchDependentSource({required super.provider}) : super();
}

@internal
sealed class DebugRefListenDependentSource
    extends DebugProviderDependentSource {
  DebugRefListenDependentSource({required super.provider}) : super();
}

@internal
sealed class DebugRefReadDependentSource extends DebugProviderDependentSource {
  DebugRefReadDependentSource({required super.provider}) : super();
}

@internal
sealed class DebugRefInvalidateDependentSource
    extends DebugProviderDependentSource {
  DebugRefInvalidateDependentSource({required super.provider}) : super();
}

@internal
sealed class DebugRefRefreshDependentSource
    extends DebugProviderDependentSource {
  DebugRefRefreshDependentSource({required super.provider}) : super();
}

@internal
class Node<StateT> {
  Node({
    required this.owner,
    required this.element,
  });

  final ProviderContainer owner;
  final ProviderElement<StateT> element;

  final _debugDependentSources = <DebugDependentSource>[];
  final _listeners = <ProviderListener<StateT>>[];

  ProviderSubscription<StateT> addListener(
    ProviderListener<StateT> listener, {
    required DebugDependentSource? debugDependents,
    required OnError? onError,
    required bool fireImmediately,
  }) {}
}
