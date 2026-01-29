part of '../vm_service.dart';

final dartCoreEvalProvider = evalProvider('dart:core');
final dartAsyncEvalProvider = evalProvider('dart:async');
final riverpodFrameworkEvalProvider = evalProvider(
  'package:riverpod/src/framework.dart',
);

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

class Eval {
  Eval._(this._eval);
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

      return ByteVariable(ResolvedVariable.fromInstance(res));
    } on SentinelException catch (e) {
      return ByteSentinel(e.sentinel);
    }
  }

  Future<Class> getClass(ClassRef ref, {required Disposable isAlive}) async {
    final res = await _eval.getClass(ref, isAlive);
    return res!;
  }
}

extension IsAlive on Ref {
  Disposable disposable() {
    final disposable = Disposable();
    onDispose(disposable.dispose);
    return disposable;
  }
}
