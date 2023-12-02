part of '../framework.dart';

@internal
sealed class DebugProviderContainerDependentSource
    extends DebugDependentSource {
  DebugProviderContainerDependentSource._({required this.container});

  final ProviderContainer container;
}

@internal
final class DebugProviderContainerListenDependentSource
    extends DebugDependentSource {
  DebugProviderContainerListenDependentSource({
    required this.container,
  });

  final ProviderContainer container;
}

@internal
final class DebugProviderContainerReadDependentSource
    extends DebugDependentSource {
  DebugProviderContainerReadDependentSource({
    required this.container,
  });

  final ProviderContainer container;
}
