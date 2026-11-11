import 'dart:async';

import 'package:collection/collection.dart';
import 'package:meta/meta.dart';
import 'package:riverpod/misc.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod/src/internals.dart' as internals;
import 'package:vm_service/vm_service.dart';

import 'connection.dart';
import 'inspector.dart';
import 'package_name_provider.dart';

part 'vm_service.g.dart';
part 'vm_service/byte.dart';
part 'vm_service/eval.dart';
part 'vm_service/session.dart';
part 'vm_service/vm_instance.dart';
part 'vm_service/instance.dart';
part 'vm_service/instance_kind.dart';
part 'vm_service/cache.dart';

Iterable<ItemT> decodeAll<ItemT>(
  Map<String, VmInstanceRef> events,
  ItemT Function(Map<String, VmInstanceRef>, {required String path}) fn, {
  required String path,
}) sync* {
  final length = int.parse(events['$path.length']!.valueAsString!);

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
  Map<String, VmInstanceRef> events, {
  required String name,
  required String path,
}) {
  final startEvent = events['$path._type']?.valueAsString;
  if (startEvent != null && startEvent != name) {
    throw ArgumentError(
      'Invalid event type, expected "$name" but got $startEvent',
    );
  }
}

/// A provider that emits an update once a hot-restart is done.
///
/// The isolate of the application goes away during a hot-restart. Updates are
/// emitted when its successor is there, as nothing can be read until then.
final hotRestartEventProvider = Provider<void>(
  name: 'hotRestartEventProvider',
  (ref) async {
    final connection = await ref.watch(appConnectionProvider.future);
    if (!ref.mounted) return;

    var isolateId = connection.isolate?.id;

    void listener() {
      final newId = connection.isolate?.id;
      if (newId == null || newId == isolateId) return;

      isolateId = newId;
      ref.notifyListeners();
    }

    connection.addListener(listener);
    ref.onDispose(() => connection.removeListener(listener));
  },
);

extension NotificationService on AppConnection {
  /// The notifications sent by [isolate].
  ///
  /// A VM service reports the events of all of its isolates. The ones of other
  /// isolates are ignored, as they may use Riverpod too and are not what the
  /// devtool inspects.
  Stream<internals.Notification> get onNotification => service.onExtensionEvent
      .where((event) => event.isolate?.id == isolate?.id)
      .expand((event) {
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
