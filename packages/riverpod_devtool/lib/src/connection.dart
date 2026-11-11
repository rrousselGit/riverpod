import 'dart:async';

import 'package:devtools_app_shared/service.dart';
import 'package:devtools_extensions/devtools_extensions.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_devtool_core/riverpod_devtool_core.dart';
import 'package:vm_service/vm_service.dart';

/// Connects the devtool to the application that DevTools is debugging.
///
/// Meant to override [appConnectionProvider].
Future<AppConnection> devtoolsAppConnection(Ref ref) async {
  final service = await ref.watch(vmServiceProvider.future);
  final serviceManager = await ref.watch(serviceManagerProvider.future);

  return DevtoolsAppConnection(
    service: service,
    serviceManager: serviceManager,
  );
}

/// The application selected in DevTools, as tracked by its [ServiceManager].
class DevtoolsAppConnection implements AppConnection {
  DevtoolsAppConnection({required this.service, required this.serviceManager});

  @override
  final VmService service;
  final ServiceManager serviceManager;

  @override
  IsolateRef? get isolate =>
      serviceManager.isolateManager.selectedIsolate.value;

  @override
  bool get connected => serviceManager.connectedState.value.connected;

  @override
  void addListener(void Function() listener) {
    serviceManager.isolateManager.selectedIsolate.addListener(listener);
    serviceManager.connectedState.addListener(listener);
  }

  @override
  void removeListener(void Function() listener) {
    serviceManager.isolateManager.selectedIsolate.removeListener(listener);
    serviceManager.connectedState.removeListener(listener);
  }
}

final serviceManagerProvider =
    AsyncNotifierProvider<ServiceManagerNotifier, ServiceManager>(
      name: 'serviceManagerProvider',
      ServiceManagerNotifier.new,
    );

class ServiceManagerNotifier extends AsyncNotifier<ServiceManager> {
  @override
  Future<ServiceManager<VmService>> build() async {
    final timer = Timer.periodic(const Duration(seconds: 1), (_) async {
      final newService = serviceManager;
      // New service detected
      if (state.value == newService) return;

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
