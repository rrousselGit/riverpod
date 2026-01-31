// ignore_for_file: invalid_use_of_internal_member

import 'dart:async';
import 'dart:js_interop';

import 'package:collection/collection.dart';
import 'package:devtools_app_shared/service.dart' hide SentinelException;
import 'package:devtools_app_shared/utils.dart';
import 'package:devtools_extensions/devtools_extensions.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
// ignore: implementation_imports
import 'package:hooks_riverpod/src/internals.dart' as internals;
import 'package:meta/meta.dart';
import 'package:vm_service/vm_service.dart';

part 'vm_service.g.dart';
part 'vm_service/byte.dart';
part 'vm_service/eval.dart';
part 'vm_service/hot_restart.dart';
part 'vm_service/instance.dart';
part 'vm_service/instance_kind.dart';
part 'vm_service/cache.dart';

Iterable<ItemT> decodeAll<ItemT>(
  Map<String, InstanceRef> events,
  ItemT Function(Map<String, InstanceRef>, {required String path}) fn, {
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
  Map<String, InstanceRef> events, {
  required String name,
  required String path,
}) {
  final startEvent = events['$path._type']?.valueAsString;
  if (startEvent != name) {
    throw ArgumentError(
      'Invalid event type, expected "$name" but got $startEvent',
    );
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

final serviceManagerProvider =
    AsyncNotifierProvider<ServiceManagerNotifier, ServiceManager>(
      name: 'serviceManagerProvider',
      ServiceManagerNotifier.new,
    );

class ServiceManagerNotifier extends AsyncNotifier<ServiceManager> {
  @override
  Future<ServiceManager<VmService>> build() async {
    final timer = Timer.periodic(const Duration(milliseconds: 18), (_) async {
      final newService = serviceManager;
      final currentService = await future;
      // New service detected
      if (state.value == currentService) return;

      state = const AsyncLoading();
      await newService.onServiceAvailable;
      // Changed service while in the async gap
      if (serviceManager != newService) return;

      state = AsyncData(newService);
    });
    ref.onDispose(timer.cancel);

    await serviceManager.onServiceAvailable;

    return serviceManager;
  }
}

final vmServiceProvider = AsyncNotifierProvider<VmServiceNotifier, VmService>(
  name: 'vmServiceProvider',
  VmServiceNotifier.new,
);

class VmServiceNotifier extends AsyncNotifier<VmService> {
  @override
  Future<VmService> build() async {
    final serviceManager = ref.watch(serviceManagerProvider);
    final timer = Timer.periodic(const Duration(milliseconds: 18), (_) {
      if (state.value == serviceManager.value?.service) return;

      switch (serviceManager.value?.service) {
        case final service?:
          state = AsyncValue.data(service);
        case null:
          state = const AsyncValue.loading();
      }
    });
    ref.onDispose(timer.cancel);

    if (serviceManager.value?.service case final service?) return service;

    return future;
  }
}
