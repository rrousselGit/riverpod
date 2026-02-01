import 'package:flutter/cupertino.dart';
// ignore: implementation_imports
import 'package:hooks_riverpod/src/internals.dart' as internals;

import 'collection.dart';
import 'frames.dart';
import 'vm_service.dart';

@immutable
class ElementMeta {
  const ElementMeta({
    required this.provider,
    required this.state,
    required this.notifier,
  });

  final ProviderMeta provider;
  final ProviderStateRef state;
  final ProviderStateRef notifier;
}

Map<internals.ElementId, ElementMeta> computeElementsForFrame(
  FoldedFrame frame,
) {
  final state = MapBuilder<internals.ElementId, ElementMeta>(
    frame.previous?.elements ?? const {},
  );

  for (final event in frame.frame.events) {
    switch (event) {
      case ProviderContainerAddEvent():
      case ProviderContainerDisposeEvent():
        break;
      case ProviderElementDisposeEvent(:final provider):
        state.remove(provider.elementId);
      case ProviderElementAddEvent(
        state: final currentState,
        :final provider,
        :final notifier,
      ):
      case ProviderElementUpdateEvent(
        next: final currentState,
        :final provider,
        :final notifier,
      ):
        state[provider.elementId] = ElementMeta(
          provider: provider,
          state: currentState,
          notifier: notifier,
        );
    }
  }

  return state.build();
}
