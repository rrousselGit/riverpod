// ignore: implementation_imports
import 'package:hooks_riverpod/src/internals.dart' as internals;

import 'collection.dart';
import 'frames.dart';
import 'vm_service.dart';

class ElementMeta {
  ElementMeta({
    required this.provider,
    required this.state,
    required this.notifier,
    required this.children,
    required this.parents,
  });

  final ProviderMeta provider;
  final ProviderStateRef state;
  final ProviderStateRef? notifier;
  final Set<NodeMeta> children;
  final Set<internals.ElementId> parents;
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
      // Unrelated events
      case ProviderElementDisposeEvent():
        // We keep the state on purpose
        break;
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
        final previous = state[provider.elementId];
        state[provider.elementId] = ElementMeta(
          provider: provider,
          state: currentState,
          notifier: notifier,
          parents: previous?.parents ?? const {},
          children: previous?.children ?? const {},
        );
      case ProviderDependencyChangeEvent(:final elementId):
        final previous = state[elementId];
        if (previous == null) {
          throw StateError(
            'Received a ProviderDependencyChangeEvent for an element that does not exist: $elementId',
          );
        }
        state[elementId] = ElementMeta(
          provider: previous.provider,
          state: previous.state,
          notifier: previous.notifier,
          parents: event.dependencies,
          children: {...event.weakDependents, ...event.dependents},
        );
    }
  }

  return state.build();
}
