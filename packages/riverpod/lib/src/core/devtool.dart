part of '../framework.dart';

abstract class ServerDevtoolController {
  Stream<List<ProviderContainerInstance>> container();
}

abstract class ProviderContainerInstance {}
