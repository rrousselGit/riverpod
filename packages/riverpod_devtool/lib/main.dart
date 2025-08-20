import 'dart:async';

import 'package:devtools_app_shared/service.dart';
import 'package:devtools_app_shared/utils.dart';
import 'package:devtools_extensions/devtools_extensions.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vm_service/vm_service.dart';

void main() {
  runApp(const ProviderScope(child: SomePkgDevToolsExtension()));
}

class SomePkgDevToolsExtension extends ConsumerWidget {
  const SomePkgDevToolsExtension({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DevToolsExtension(
      child: Consumer(
        builder: (context, ref, child) {
          final intClass = ref.watch(intRef);

          return Column(
            children: [
              Text(intClass.toString()),
              Text('${intClass.value?.fields?.map((e) => e.name).join(', ')}'),
            ],
          );
        },
      ),
    );
  }
}

final serviceManagerProvider =
    AsyncNotifierProvider<ServiceManagerNotifier, ServiceManager>(
      ServiceManagerNotifier.new,
    );

class ServiceManagerNotifier extends AsyncNotifier<ServiceManager> {
  @override
  Future<ServiceManager<VmService>> build() async {
    final timer = Timer.periodic(const Duration(milliseconds: 18), (_) async {
      final value = serviceManager;
      if (state.value == value) return;

      state = const AsyncLoading();
      await value.onServiceAvailable;
      if (serviceManager != value) return;

      state = AsyncData(value);
    });
    ref.onDispose(timer.cancel);

    await serviceManager.onServiceAvailable;

    return serviceManager;
  }
}

final vmServiceProvider = AsyncNotifierProvider<VmServiceNotifier, VmService>(
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

final evalProvider = FutureProvider.autoDispose
    .family<EvalOnDartLibrary, String>((ref, libraryName) async {
      final vmService = await ref.watch(vmServiceProvider.future);
      final serviceManager = await ref.watch(serviceManagerProvider.future);

      return EvalOnDartLibrary(
        libraryName,
        vmService,
        serviceManager: serviceManager,
      );
    });

final dartCore = evalProvider('dart:core');
final dartAsync = evalProvider('dart:async');

final intRef = FutureProvider<Class>((ref) async {
  final eval = await ref.watch(dartCore.future);
  final res = await eval.safeEval('int', isAlive: ref.isAlive());

  return eval.safeGetClass(res.typeClass!, ref.isAlive());
});

extension IsAlive on Ref {
  Disposable isAlive() {
    final disposable = Disposable();
    onDispose(disposable.dispose);
    return disposable;
  }
}
