// ignore: implementation_imports
// ignore_for_file: invalid_use_of_internal_member

import 'dart:async';

import 'package:devtools_app_shared/service.dart';
import 'package:devtools_app_shared/utils.dart';
import 'package:devtools_extensions/devtools_extensions.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
// ignore: implementation_imports
import 'package:riverpod/src/internals.dart' as internals;
import 'package:vm_service/vm_service.dart';

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

      print('new service ${serviceManager.hashCode}');
      state = AsyncData(newService);
    });
    ref.onDispose(timer.cancel);

    await serviceManager.onServiceAvailable;

    print('Initial service ${serviceManager.hashCode}');

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

class Eval {
  Eval._(this._eval);
  final EvalOnDartLibrary _eval;

  String _formatCode(String code) => code.replaceAll('\n', ' ');

  Future<InstanceRef> eval(
    String code, {
    required Disposable isAlive,
    Map<String, String>? scope,
  }) async {
    return _eval.safeEval(_formatCode(code), isAlive: isAlive, scope: scope);
  }

  Future<Instance> evalInstance(
    String code, {
    required Disposable isAlive,
    Map<String, String>? scope,
  }) async {
    final ref = await eval(code, isAlive: isAlive, scope: scope);
    return instance(ref, isAlive: isAlive);
  }

  Future<Instance> instance(
    InstanceRef ref, {
    required Disposable isAlive,
  }) async {
    final res = await _eval.getInstance(ref, isAlive);
    return res!;
  }
}

final evalProvider = FutureProvider.autoDispose.family<Eval, String>(
  name: 'evalProvider',
  (ref, libraryName) async {
    final vmService = await ref.watch(vmServiceProvider.future);
    final serviceManager = await ref.watch(serviceManagerProvider.future);

    final eval = EvalOnDartLibrary(
      libraryName,
      vmService,
      serviceManager: serviceManager,
    );
    ref.onDispose(eval.dispose);

    return Eval._(eval);
  },
);

final dartCoreEvalProvider = evalProvider('dart:core');
final dartAsyncEvalProvider = evalProvider('dart:async');
final riverpodFrameworkEvalProvider = evalProvider(
  'package:riverpod/src/framework.dart',
);

extension IsAlive on Ref {
  Disposable isAlive() {
    final disposable = Disposable();
    onDispose(disposable.dispose);
    return disposable;
  }
}
