part of '../framework.dart';

@internal
sealed class DebugConsumerDependentSource extends DebugDependentSource {
  DebugConsumerDependentSource({required this.consumer, required this.element});

  // TODO
  final Object consumer;
  // TODO
  final Object? element;
}
