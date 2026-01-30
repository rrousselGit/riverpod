part of '../vm_service.dart';

final riverpodEvalProvider = FutureProvider((ref) {
  return ref.watch(
    evalProvider.selectAsync((evalFactory) => evalFactory.riverpodFramework),
  );
});

final evalProvider = FutureProvider.autoDispose<EvalFactory>(
  name: 'evalProvider',
  (ref) async {
    final vmService = await ref.watch(vmServiceProvider.future);
    final serviceManager = await ref.watch(serviceManagerProvider.future);

    final eval = EvalFactory(
      vmService: vmService,
      serviceManager: serviceManager,
    );
    ref.onDispose(eval.dispose);

    return eval;
  },
);

class EvalFactory {
  EvalFactory({required this.vmService, required this.serviceManager});

  Eval get dartCore => forLibrary('dart:core');
  Eval get dartAsync => forLibrary('dart:async');
  Eval get riverpodFramework =>
      forLibrary('package:riverpod/src/framework.dart');

  final VmService vmService;
  final ServiceManager serviceManager;

  final _evalCache = <String, Eval>{};
  Eval forLibrary(String libraryName) {
    return _evalCache.putIfAbsent(
      libraryName,
      () => Eval._(
        this,
        libraryName,
        vmService: vmService,
        serviceManager: serviceManager,
      ),
    );
  }

  void dispose() {
    for (final eval in _evalCache.values) {
      eval.dispose();
    }
    _evalCache.clear();
  }

  Eval? forRef(VariableRef? state) {
    final libraryUri = state?.ref?.classRef?.library?.uri;
    if (libraryUri == null) return null;

    return forLibrary(libraryUri);
  }
}

class Eval {
  // TODO  handle  RPCError (also remove explicit try/catch)

  Eval._(
    this.factory,
    String libraryName, {
    required VmService vmService,
    required ServiceManager serviceManager,
  }) : _eval = EvalOnDartLibrary(
         libraryName,
         vmService,
         serviceManager: serviceManager,
       );

  final EvalFactory factory;
  final EvalOnDartLibrary _eval;

  String _formatCode(String code) => code.replaceAll('\n', ' ');

  Future<CacheId> cache(InstanceRef ref, {required Disposable isAlive}) async {
    final idRef = await _eval.safeEval(
      'RiverpodDevtool.instance.cache(that)',
      scope: {'that': ref.id!},
      isAlive: isAlive,
    );

    if (idRef.valueAsStringIsTruncated!) {
      throw StateError('CacheId value is truncated');
    }
    return CacheId(idRef.valueAsString!);
  }

  Future<void> deleteCache(CacheId id, {required Disposable isAlive}) async {
    await _eval.safeEval(
      'RiverpodDevtool.instance.deleteCache(that)',
      scope: {'that': id.value},
      isAlive: isAlive,
    );
  }

  Future<InstanceRef> getCache(CacheId id, {required Disposable isAlive}) {
    return _eval.safeEval(
      'RiverpodDevtool.instance.getCache(that)',
      scope: {'that': id.value},
      isAlive: isAlive,
    );
  }

  Future<InstanceRef> eval(
    String code, {
    required Disposable isAlive,
    Map<String, String>? scope,
  }) {
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

  @Deprecated('use instance2')
  Future<Instance> instance(
    InstanceRef ref, {
    required Disposable isAlive,
  }) async {
    final res = await _eval.getInstance(ref, isAlive);
    return res!;
  }

  Future<Byte<ResolvedVariable>> instance2(
    InstanceRef ref, {
    required Disposable isAlive,
  }) async {
    try {
      final res = await _eval.safeGetInstance(ref, isAlive);

      return ByteVariable(ResolvedVariable.fromInstance(res, factory));
    } on SentinelException catch (e) {
      return ByteSentinel(e.sentinel);
    }
  }

  Future<Class> getClass(ClassRef ref, {required Disposable isAlive}) async {
    final res = await _eval.getClass(ref, isAlive);
    return res!;
  }

  void dispose() {
    _eval.dispose();
    factory._evalCache.removeWhere((_, v) => v == this);
  }
}

extension IsAlive on Ref {
  Disposable disposable() {
    final disposable = Disposable();
    onDispose(disposable.dispose);
    return disposable;
  }
}
