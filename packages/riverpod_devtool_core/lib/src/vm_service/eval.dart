part of '../vm_service.dart';

/// A token telling whether the owner of a request is still interested in it.
///
/// Requests made with a disposed token throw a [CancelledException].
class Disposable {
  bool get disposed => _disposed;
  bool _disposed = false;

  void dispose() => _disposed = true;
}

/// Thrown by requests whose owner or connection went away before they
/// completed.
final class CancelledException implements Exception {}

final riverpodEvalProvider = FutureProvider((ref) {
  return ref.watch(
    evalProvider.selectAsync((evalFactory) => evalFactory.riverpodFramework),
  );
});

final evalProvider = FutureProvider.autoDispose<EvalFactory>(
  name: 'evalProvider',
  (ref) async {
    final connection = await ref.watch(appConnectionProvider.future);

    final eval = EvalFactory(connection);
    ref.onDispose(eval.dispose);

    return eval;
  },
);

extension type RiverpodEval(Eval _eval) implements Eval {}

class EvalFactory {
  EvalFactory(this.connection) {
    connection.addListener(_connectionChanged);
  }

  void _connectionChanged() {
    if (!connection.connected) dispose();
  }

  Eval get dartCore => forLibrary('dart:core');
  Eval get dartAsync => forLibrary('dart:async');
  RiverpodEval get riverpodFramework =>
      RiverpodEval(forLibrary('package:riverpod/src/framework.dart'));

  final AppConnection connection;
  VmService get vmService => connection.service;

  String? sessionId;

  final _disposable = Disposable();
  final _closed = StreamController<void>.broadcast(sync: true);

  final _evalCache = <String, Eval>{};
  final _isolates = <String, Future<Isolate>>{};

  Future<Isolate> _loadIsolate(IsolateRef ref, {bool refresh = false}) {
    final id = ref.id!;
    if (refresh) unawaited(_isolates.remove(id));
    return _isolates[id] ??= () async {
      try {
        return await vmService.getIsolate(id);
      } catch (_) {
        // A failed lookup must not prevent later evaluations.
        unawaited(_isolates.remove(id));
        rethrow;
      }
    }();
  }

  Future<List<LibraryRef>> _libraries(
    IsolateRef ref, {
    required String containing,
  }) async {
    bool hasLibrary(Isolate isolate) =>
        isolate.libraries?.any((e) => e.uri == containing) ?? false;

    var isolate = await _loadIsolate(ref);
    // Applications load more libraries over time, such as after a hot-reload.
    if (!hasLibrary(isolate)) isolate = await _loadIsolate(ref, refresh: true);
    if (!hasLibrary(isolate)) throw LibraryNotFound(containing);

    return isolate.libraries!;
  }

  Eval forLibrary(String libraryName) {
    if (_disposable.disposed) throw CancelledException();
    return _evalCache.putIfAbsent(libraryName, () => Eval._(this, libraryName));
  }

  void dispose() {
    if (_disposable.disposed) return;
    connection.removeListener(_connectionChanged);
    sessionId = null;
    _disposable.dispose();
    _closed.add(null);
    unawaited(_closed.close());
    _evalCache.clear();
    _isolates.clear();
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

/// Evaluating an expression threw, or the expression does not compile.
final class EvalErrorException implements Exception {
  EvalErrorException({
    required this.expression,
    required this.scope,
    required this.errorRef,
  });

  final String expression;
  final Map<String, String>? scope;
  final ErrorRef errorRef;

  @override
  String toString() =>
      'Evaluation `$expression` failed with ${errorRef.message}';
}

/// Evaluating an expression returned neither an instance nor a known error.
final class UnknownEvalException implements Exception {
  UnknownEvalException({
    required this.expression,
    required this.scope,
    required this.exception,
  });

  final String expression;
  final Map<String, String>? scope;
  final Object? exception;

  @override
  String toString() =>
      'Unknown error during the evaluation of `$expression`: $exception';
}

/// The library in which to evaluate code is not part of the application.
final class LibraryNotFound implements Exception {
  LibraryNotFound(this.name);

  final String name;

  @override
  String toString() => 'Library matching $name not found';
}

/// Evaluates code within a library of the application.
class Eval {
  Eval._(this.factory, this.libraryName);

  final EvalFactory factory;
  final String libraryName;

  VmService get _service => factory.vmService;

  /// Throws unless a request sent to [isolate] is still of use.
  ///
  /// What an isolate returns means nothing to the one that replaced it.
  void _checkAlive(Disposable isAlive, IsolateRef? isolate) {
    if (isAlive.disposed ||
        factory._disposable.disposed ||
        isolate == null ||
        factory.connection.isolate?.id != isolate.id) {
      throw CancelledException();
    }
  }

  Future<Byte<ValueT>> _run<ValueT>(
    Disposable isAlive,
    Future<ValueT> Function(IsolateRef isolate) cb,
  ) async {
    final isolate = factory.connection.isolate;
    _checkAlive(isAlive, isolate);
    final cancelled = Completer<ValueT>();
    final subscription = factory._closed.stream.listen((_) {
      cancelled.completeError(CancelledException());
    });
    try {
      final ref = await Future.any([cb(isolate!), cancelled.future]);
      _checkAlive(isAlive, isolate);
      return ByteVariable(ref);
    } catch (error) {
      // The isolate may go away while an outstanding request fails.
      // Translate only requests whose connection or owner has gone away.
      _checkAlive(isAlive, isolate);
      if (error is EvalErrorException) {
        final e = error;
        if (e.errorRef.message?.contains('Riverpod devtool session expired') ??
            false) {
          return ByteError(const ExpiredDevtoolSessionType());
        }
        return ByteError(EvalErrorType(e));
      }
      // Thrown by VmService when the object of a request has expired.
      if (error is SentinelException) {
        return ByteError(SentinelExceptionType(error.sentinel));
      }
      if (error is UnknownEvalException) {
        return ByteError(UnknownEvalErrorType(error.toString()));
      }
      if (error is RPCError) return ByteError(RPCErrorType(error));
      rethrow;
    } finally {
      await subscription.cancel();
    }
  }

  Future<InstanceRef> _evaluate(
    IsolateRef isolateRef,
    String expression,
    Map<String, String>? scope,
  ) async {
    final libraries = await factory._libraries(
      isolateRef,
      containing: libraryName,
    );
    final library = libraries.firstWhere((e) => e.uri == libraryName);

    final Object result;
    if (scope != null &&
        scope.isNotEmpty &&
        libraries.any((e) => e.uri == 'dart:html')) {
      // Web applications do not support `scope`. Its values are passed as
      // the parameters of a closure instead.
      final closure = await _evaluate(
        isolateRef,
        '(${scope.keys.join(',')}) => $expression',
        null,
      );
      result = await _service.invoke(
        isolateRef.id!,
        closure.id!,
        'call',
        scope.values.toList(),
        disableBreakpoints: true,
      );
    } else {
      result = await _service.evaluate(
        isolateRef.id!,
        library.id!,
        expression,
        scope: scope,
        disableBreakpoints: true,
      );
    }

    switch (result) {
      case InstanceRef():
        return result;
      case ErrorRef():
        throw EvalErrorException(
          expression: expression,
          scope: scope,
          errorRef: result,
        );
      default:
        throw UnknownEvalException(
          expression: expression,
          scope: scope,
          exception: result,
        );
    }
  }

  Future<ObjT> _getObject<ObjT extends Obj>(
    IsolateRef isolate,
    ObjRef ref,
  ) async {
    return await _service.getObject(isolate.id!, ref.id!) as ObjT;
  }

  Future<Byte<VmInstanceRef>> eval(
    String code, {
    required Disposable isAlive,
    Map<String, String>? scope,
  }) {
    return _run(isAlive, (isolate) async {
      return VmInstanceRef(await _evaluate(isolate, code, scope));
    });
  }

  /// Evaluates [condition] until it is true, or [timeout] elapsed.
  ///
  /// The application makes progress on its asynchronous work between
  /// evaluations, which are [pollInterval] apart. This may wait for longer
  /// than [timeout] if evaluations are slow, and stops early if [condition]
  /// cannot be evaluated.
  Future<void> waitUntil(
    String condition, {
    required Disposable isAlive,
    Map<String, String>? scope,
    Duration timeout = const Duration(seconds: 2),
    Duration pollInterval = const Duration(milliseconds: 10),
  }) async {
    final stopwatch = Stopwatch()..start();
    while (true) {
      final result = await eval(condition, isAlive: isAlive, scope: scope);
      if (result.valueOrNull?.valueAsString != 'false') return;
      if (stopwatch.elapsed + pollInterval >= timeout) return;
      await Future<void>.delayed(pollInterval);
    }
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
    final instance = await _run(
      isAlive,
      (isolate) => _getObject<Instance>(isolate, ref.raw),
    );
    return instance.map(VmInstance.new);
  }

  Future<Byte<Class>> getClass(ClassRef ref, {required Disposable isAlive}) {
    return _run(isAlive, (isolate) => _getObject<Class>(isolate, ref));
  }
}

extension IsAlive on Ref {
  Disposable disposable() {
    final disposable = Disposable();
    onDispose(disposable.dispose);
    return disposable;
  }
}
