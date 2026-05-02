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

extension type RiverpodEval(Eval _eval) implements Eval {}

class EvalFactory {
  EvalFactory({required this.vmService, required this.serviceManager});

  Eval get dartCore => forLibrary('dart:core');
  Eval get dartAsync => forLibrary('dart:async');
  RiverpodEval get riverpodFramework =>
      RiverpodEval(forLibrary('package:riverpod/src/framework.dart'));

  final VmService vmService;
  final ServiceManager serviceManager;

  final _disposable = Disposable();

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
    _disposable.dispose();
    for (final eval in _evalCache.values.toList()) {
      eval.dispose();
    }
    _evalCache.clear();
  }

  Eval? forRef(VmInstanceRef? state) {
    final libraryUri = state?.classRef?.library?.uri;
    if (libraryUri == null) return null;

    return forLibrary(libraryUri);
  }
}

Future<Byte<ValueT>> runAndRetryOnExpired<ValueT>(
  Future<Byte<ValueT>> Function() cb, {
  FutureOr<ByteErrorType?> Function()? onRetry,
  int maxRetries = 5,
}) async {
  var i = 0;
  while (true) {
    i++;
    final result = await cb();

    switch (result) {
      case ByteVariable():
        return result;
      case ByteError(error: ExpiredSentinelExceptionType()) when i < maxRetries:
        if (onRetry != null) {
          final error = await onRetry();
          if (error != null) return ByteError(error);
        }

        continue;
      case ByteError():
        return result;
    }
  }
}

class Eval {
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

  Future<Byte<ValueT>> _run<ValueT>(Future<ValueT> Function() cb) async {
    try {
      final ref = await cb();

      return ByteVariable(ref);
    } on EvalErrorException catch (e) {
      return ByteError(EvalErrorType(e));
    } on EvalSentinelException catch (e) {
      return ByteError(SentinelExceptionType(e.sentinel));
    } on UnknownEvalException catch (e) {
      return ByteError(UnknownEvalErrorType(e.toString()));
    } on RPCError catch (e) {
      return ByteError(RPCErrorType(e));
    }
  }

  Future<Byte<VmInstanceRef>> eval(
    String code, {
    required Disposable isAlive,
    Map<String, String>? scope,
  }) {
    return _run(() async {
      return VmInstanceRef(
        await _eval.safeEval(_formatCode(code), isAlive: isAlive, scope: scope),
      );
    });
  }

  Future<Byte<VmInstance>> evalInstance(
    String code, {
    required Disposable isAlive,
    Map<String, String>? scope,
  }) async {
    final ref = await eval(code, isAlive: isAlive, scope: scope);

    switch (ref) {
      case ByteError<VmInstanceRef>():
        return ByteError(ref.error);
      case ByteVariable<VmInstanceRef>():
        return instance(ref.instance, isAlive: isAlive);
    }
  }

  Future<Byte<VmInstance>> instance(
    VmInstanceRef ref, {
    required Disposable isAlive,
  }) async {
    final instance = await _run(() => _eval.safeGetInstance(ref.raw, isAlive));
    return instance.map(VmInstance.new);
  }

  Future<Byte<Class>> getClass(ClassRef ref, {required Disposable isAlive}) {
    return _run(() => _eval.safeGetClass(ref, isAlive));
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
