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
  });

  final ProviderMeta provider;
  final ProviderStateRef state;
  final ProviderStateRef? notifier;
  final Set<internals.ElementId> children = {};
  final Set<internals.ElementId> parents = {};
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
        state[provider.elementId] = ElementMeta(
          provider: provider,
          state: currentState,
          notifier: notifier,
        );
    }
  }

  final map = state.build();

  // _computeRelations(map, frame);

  return map;
}

// TODO
// void _computeRelations(Map<internals.ElementId, ElementMeta> elements) {
//   for (final element in elements.values) {
//     for (final dependency in element.state.dependencies) {
//       final dependencyElement = elements[dependency];
//       if (dependencyElement == null) continue;

//       element.parents.add(dependency);
//       dependencyElement.children.add(element.provider.elementId);
//     }
//   }
// }
