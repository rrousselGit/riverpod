import 'package:devtools_app_shared/utils.dart';
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

  Future<void> invalidate(
    EvalFactory evalFactory, {
    required Disposable isAlive,
  }) async {
    final elementByte = await provider.element.readRef(evalFactory, isAlive);

    switch (elementByte) {
      case ByteError(error: final error):
        throw Exception(error.toString());
      case ByteVariable(:final instance):
        final result = await evalFactory.riverpodFramework.eval(
          'that.container.invalidate(that.origin)',
          isAlive: isAlive,
          scope: {'that': instance.id!},
        );

        if (result case ByteError(error: final error)) {
          throw Exception(error.toString());
        }
    }
  }

  Future<void> resetTo(
    EvalFactory evalFactory,
    ProviderStateRef oldState, {
    required Disposable isAlive,
  }) async {
    final currentStateByte = await state.state.readRef(evalFactory, isAlive);
    final oldStateByte = await oldState.state.readRef(evalFactory, isAlive);

    switch ((currentStateByte, oldStateByte)) {
      case (ByteError(error: final error), _):
        throw Exception(error.toString());
      case (_, ByteError(error: final error)):
        throw Exception(error.toString());
      case (
          ByteVariable(instance: final currentStateInstance),
          ByteVariable(instance: final oldStateInstance)
        ):
        final result = await evalFactory.riverpodFramework.eval(
          'state = oldState',
          isAlive: isAlive,
          scope: {
            'state': currentStateInstance.id!,
            'oldState': oldStateInstance.id!,
          },
        );

        if (result case ByteError(error: final error)) {
          throw Exception(error.toString());
        }
    }
  }
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
