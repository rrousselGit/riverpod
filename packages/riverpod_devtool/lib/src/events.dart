import 'dart:async';

import 'package:devtools_app_shared/utils.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vm_service/vm_service.dart';

import 'containers.dart';
import 'core.dart';

class Event {
  Event({
    required this.id,
    required this.ref,
    required this.originRef,
    required this.containerId,
    required this.displayString,
    required this.argument,
    required this.family,
  });

  final ProviderElementId id;
  final InstanceRef ref;
  final InstanceRef originRef;
  final InstanceRef? family;
  final InstanceRef? argument;
  final String displayString;
  final ContainerId containerId;
}

extension type ProviderElementId(String id) {}

final providerElementsProvider =
    AsyncNotifierProvider.autoDispose<
      ProviderElementsNotifier,
      Map<ProviderElementId, Event>
    >(ProviderElementsNotifier.new, name: 'providerElementsProvider');

class ProviderElementsNotifier
    extends AsyncNotifier<Map<ProviderElementId, Event>> {
  @override
  Future<Map<ProviderElementId, Event>> build() async {
    final service = await ref.watch(vmServiceProvider.future);

    if (!state.hasValue) state = const AsyncData({});

    final riverpodEval = await ref.watch(riverpodInternalsEvalProvider.future);

    final isAlive = ref.isAlive();

    {
      final sub = service.onExtensionEvent
          .where((event) => event.extensionKind == 'riverpod:add_element')
          .listen(
            (event) => _handleAddElement(
              event,
              isAlive: isAlive,
              riverpodEval: riverpodEval,
            ),
          );
      ref.onDispose(sub.cancel);
    }
    {
      final sub = service.onExtensionEvent
          .where((event) => event.extensionKind == 'riverpod:remove_element')
          .listen(_handleRemoveElement);
      ref.onDispose(sub.cancel);
    }

    final newItems = await _parseElementsForMap(
      'RiverpodDevtool.instance.elements',
      riverpodEval: riverpodEval,
      isAlive: isAlive,
    );

    return Map.fromEntries(state.value!.entries.followedBy(newItems));
  }

  Future<List<MapEntry<ProviderElementId, Event>>>
  _parseElementsForMap(
    String mapExpression, {
    required Eval riverpodEval,
    required Disposable isAlive,
  }) async {
    final containers = await riverpodEval.evalInstance(isAlive: isAlive, '''
() {
  final expr = $mapExpression;
  final elements = [
    for (final MapEntry(key: id, value: element) in expr.entries)
      [
        element,
        id,
        element.container.id,
        element.origin,
        element.origin.from,
        (element.origin.from ?? element.origin).toString(),
        element.origin.argument,
      ],
  ].flatten();

  final uniqueProviders = <ProviderOrFamily, List<ProviderElement>>{};
  for (final element in expr.values) {
    final provider = element.origin.from ?? element.origin;
    final associatedElements = uniqueProviders[provider] ??= [];

    associatedElements.add(element);
  }
  final uniqueProvidersList = uniqueProviders.entries.map((entry) {
    final provider = entry.key;
    final associatedElements = entry.value;

    return [provider, ...associatedElements];
  }).toList().flatten();

  return [elements, uniqueProvidersList].flatten();
}()
''');

    final newItems = <MapEntry<ProviderElementId, Event>>[];
    final list = inflateList(containers.elements!);
    final [flatElements, flatUniqueProvidersList] = list;
    final elements = inflateList(flatElements);
    final uniqueProvidersList = inflateList(flatUniqueProvidersList);

    for (final item in elements) {
      final [
        element,
        id,
        containerId,
        origin,
        family,
        displayString,
        argument,
      ] = item;

      final node = Event(
        id: ProviderElementId(id!.valueAsString!),
        ref: element!,
        originRef: origin!,
        family: family,
        argument: argument,
        displayString: displayString!.valueAsString!,
        containerId: ContainerId(containerId!.valueAsString!),
      );
      newItems.add(MapEntry(node.id, node));
    }

    return newItems;
  }

  Future<void> _handleAddElement(
    Event event, {
    required Disposable isAlive,
    required Eval riverpodEval,
  }) async {
    final id = ProviderElementId(event.extensionData!.data['id'] as String);

    final addedContainers = await _parseElementsForMap(
      """
{ 
  if (RiverpodDevtool.instance.elements['$id'] case final element?) 
    '$id': element,
}
""",
      riverpodEval: riverpodEval,
      isAlive: isAlive,
    );

    state = AsyncData({...?state.value, ...Map.fromEntries(addedContainers)});
  }

  void _handleRemoveElement(Event event) {
    final id = ProviderElementId(event.extensionData!.data['id'] as String);

    final currentState = state.value;
    if (currentState == null || !currentState.containsKey(id)) return;

    final newState = Map.of(currentState);
    newState.remove(id);
    state = AsyncData(newState);
  }
}

// Converts [2, name, age, 3, name, age, address, ...] into [[name, age], [name, age, address], ...]
List<List<InstanceRef?>> inflateList(List<Object?> buffer) {
  final result = <List<InstanceRef?>>[];

  for (var i = 0; i < buffer.length;) {
    final length = int.parse((buffer[i]! as InstanceRef).valueAsString!);
    result.add(buffer.sublist(i + 1, i + 1 + length).cast<InstanceRef?>());

    i += length + 1;
  }

  return result;
}
