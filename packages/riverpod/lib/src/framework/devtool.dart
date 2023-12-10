part of '../framework.dart';

@internal
abstract class DebugRiverpodDevtoolBiding {
  static final _containers = <ProviderContainer>[];

  static List<ProviderContainer> get containers =>
      UnmodifiableListView(_containers);

  static void addContainer(ProviderContainer container) {
    _containers.add(container);
  }

  static void removeContainer(ProviderContainer container) {
    _containers.remove(container);
  }
}
