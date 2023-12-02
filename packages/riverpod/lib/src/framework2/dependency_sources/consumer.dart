part of '../framework.dart';

@internal
sealed class DebugConsumerDependentSource extends DebugDependentSource {
  DebugConsumerDependentSource({required this.consumer, required this.element});

  final Consumer consumer;
  final Element element;
}
