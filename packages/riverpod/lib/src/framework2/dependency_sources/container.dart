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

@internal
final class DebugProviderContainerExistsDependentSource
    extends DebugDependentSource {
  DebugProviderContainerExistsDependentSource({
    required this.container,
  });

  final ProviderContainer container;
}

@internal
final class DebugProviderContainerInvalidateDependentSource
    extends DebugDependentSource {
  DebugProviderContainerInvalidateDependentSource({
    required this.container,
  });

  final ProviderContainer container;
}

@internal
final class DebugProviderContainerRefreshDependentSource
    extends DebugDependentSource {
  DebugProviderContainerRefreshDependentSource({
    required this.container,
  });

  final ProviderContainer container;
}

@internal
final class DebugProviderContainerReloadDependentSource
    extends DebugDependentSource {
  DebugProviderContainerReloadDependentSource({
    required this.container,
  });

  final ProviderContainer container;
}
