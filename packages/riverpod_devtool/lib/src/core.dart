import 'dart:async';

import 'package:devtools_app_shared/service.dart';
import 'package:devtools_app_shared/utils.dart';
import 'package:devtools_extensions/devtools_extensions.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vm_service/vm_service.dart';

final serviceManagerProvider =
    AsyncNotifierProvider<ServiceManagerNotifier, ServiceManager>(
      name: 'serviceManagerProvider',
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

  Future<InstanceRef> eval(String code, {required Disposable isAlive}) async {
    return _eval.safeEval(_formatCode(code), isAlive: isAlive);
  }

  Future<Instance> evalInstance(
    String code, {
    required Disposable isAlive,
  }) async {
    final ref = await eval(code, isAlive: isAlive);
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
final riverpodInternalsEvalProvider = evalProvider(
  'package:riverpod/src/internals.dart',
);

extension IsAlive on Ref {
  Disposable isAlive() {
    final disposable = Disposable();
    onDispose(disposable.dispose);
    return disposable;
  }
}
