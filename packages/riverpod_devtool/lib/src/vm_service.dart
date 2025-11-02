// ignore: implementation_imports
// ignore_for_file: invalid_use_of_internal_member

import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
// ignore: implementation_imports
import 'package:hooks_riverpod/src/internals.dart' as internals;
import 'package:vm_service/vm_service.dart';

import 'core.dart';

part 'vm_service.g.dart';

final class Byte {
  Byte.of(Object? ref) : ref = ref! as InstanceRef;

  final InstanceRef ref;

  @override
  String toString() {
    switch (ref.kind) {
      case InstanceKind.kString:
        return "'${ref.valueAsString}'";
      case InstanceKind.kInt:
      case InstanceKind.kDouble:
      case InstanceKind.kBool:
        return ref.valueAsString!;
      case InstanceKind.kNull:
        return 'null';
      default:
        return 'Byte(...)';
    }
  }
}

Iterable<ItemT> decodeAll<ItemT>(
  Map<String, Byte> events,
  ItemT Function(Map<String, Byte>, {required String path}) fn, {
  required String path,
}) sync* {
  final length = int.parse(events['$path.length']!.ref.valueAsString!);

  for (var i = 0; i < length; i++) {
    final itemPath = '$path[$i]';
    yield fn(events, path: itemPath);
  }
}

String encodeList(
  String expr,
  String Function(String name, String path) mapCode, {
  required String path,
}) {
  return '''
() {
  final list = $expr;
  return {
    '$path.length': list.length,
    for (final (index, e) in list.indexed)
      ...${mapCode('e', '$path[\$index]')},
  };
}()
''';
}

void _validate(
  Map<String, Byte> events, {
  required String name,
  required String path,
}) {
  final startEvent = events['$path._type'];
  switch (startEvent) {
    case Byte(ref: InstanceRef(valueAsString: final actualName)):
      if (actualName != name) {
        throw ArgumentError(
          'Invalid event type, expected "$name" but got $actualName',
        );
      }
    case _:
      throw ArgumentError('Invalid event data for $name: $events');
  }
}

/// A provider that emits an update when a hot-restart is detected.
final hotRestartEventProvider = Provider<void>(
  name: 'hotRestartEventProvider',
  (ref) async {
    final service = await ref.watch(serviceManagerProvider.future);
    if (!ref.mounted) return;
    final selectedIsolateListenable = service.isolateManager.selectedIsolate;

    var isolateId = selectedIsolateListenable.value?.id;

    void listener() {
      final newId = selectedIsolateListenable.value?.id;
      final oldId = isolateId;
      isolateId = newId;

      if (oldId != null && oldId != newId) {
        ref.notifyListeners();
        return;
      }
    }

    selectedIsolateListenable.addListener(listener);
    ref.onDispose(() => selectedIsolateListenable.removeListener(listener));
  },
);

extension NotificationService on VmService {
  Stream<internals.Notification> get onNotification =>
      onExtensionEvent.expand((event) {
        final notification = internals.Notification.fromJson(
          event.extensionKind ?? '',
          event.extensionData?.data ?? {},
        );
        if (notification != null) {
          return [notification];
        }
        return const [];
      });
}
