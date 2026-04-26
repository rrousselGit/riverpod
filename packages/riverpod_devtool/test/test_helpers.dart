import 'package:hooks_riverpod/src/internals.dart' as internals;
import 'package:riverpod_devtool/src/vm_service.dart';
import 'package:vm_service/vm_service.dart' as vm;

vm.InstanceRef stringRef(String value, {String? id}) {
  return vm.InstanceRef(
    id: id ?? 'ref-$value',
    kind: vm.InstanceKind.kString,
    valueAsString: value,
    length: value.length,
  );
}

vm.Instance stringInstance(String value, {String? id}) {
  return vm.Instance(
    id: id ?? 'instance-$value',
    kind: vm.InstanceKind.kString,
    valueAsString: value,
    length: value.length,
  );
}

RootCachedObject cacheObject(String id) => RootCachedObject(CacheId(id));

OriginMeta originMeta({
  String id = 'origin-id',
  String label = 'origin',
  bool isFamily = false,
}) {
  return OriginMeta(
    id: internals.OriginId(id),
    toStringValue: label,
    hashValue: 'hash-$id',
    isFamily: isFamily,
    creationStackTrace: null,
  );
}

ProviderMeta providerMeta({
  required String elementId,
  String? providerId,
  String? containerId,
  String label = 'provider',
}) {
  return ProviderMeta(
    origin: originMeta(id: 'origin-$elementId', label: label),
    id: internals.ProviderId(providerId ?? 'provider-$elementId'),
    argToStringValue: '',
    hashValue: 'provider-hash-$elementId',
    containerId: internals.ContainerId(containerId ?? 'container-$elementId'),
    containerHashValue: 'container-hash-$elementId',
    elementId: internals.ElementId(elementId),
    element: cacheObject('element-cache-$elementId'),
    creationStackTrace: null,
  );
}

ProviderStateRef stateRef(String cacheId) {
  return ProviderStateRef(state: cacheObject(cacheId));
}

Frame devtoolFrame({
  required int index,
  required List<Event> events,
  DateTime? timestamp,
}) {
  return Frame(
    timestamp: timestamp ?? DateTime(2026).add(Duration(seconds: index)),
    index: index,
    events: events,
  );
}
