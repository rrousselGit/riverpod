import 'dart:async';

import 'package:riverpod_devtool_core/src/vm_service.dart';
import 'package:test/test.dart';
import 'package:vm_service/vm_service.dart';

import '../../utils.dart';

class _LookupService implements VmService {
  final response = Completer<Obj>();
  int requests = 0;

  @override
  Future<Obj> getObject(
    String isolateId,
    String objectId, {
    int? offset,
    int? count,
    String? idZoneId,
  }) {
    requests++;
    return response.future;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _EvalService implements VmService {
  final libraries = [
    LibraryRef(id: 'libraries/core', uri: 'dart:core'),
    LibraryRef(id: 'libraries/async', uri: 'dart:async'),
  ];
  final evaluations =
      <({String target, String expression, Map<String, String>? scope})>[];
  final invocations = <({String target, String selector, List<String> args})>[];
  final objectLookups = <String>[];
  int isolateLookups = 0;
  StateError? isolateError;
  Exception? failure;
  Response Function()? respond;
  Response response = InstanceRef(
    id: 'objects/ok',
    kind: InstanceKind.kString,
    valueAsString: 'ok',
  );

  @override
  Future<Isolate> getIsolate(String isolateId) async {
    isolateLookups++;
    if (isolateError case final error?) throw error;
    return Isolate(id: isolateId, libraries: [...libraries]);
  }

  @override
  Future<Response> evaluate(
    String isolateId,
    String targetId,
    String expression, {
    Map<String, String>? scope,
    bool? disableBreakpoints,
    String? idZoneId,
  }) async {
    evaluations.add((target: targetId, expression: expression, scope: scope));
    if (failure case final failure?) throw failure;
    return respond?.call() ?? response;
  }

  @override
  Future<Response> invoke(
    String isolateId,
    String targetId,
    String selector,
    List<String> argumentIds, {
    bool? disableBreakpoints,
    String? idZoneId,
  }) async {
    invocations.add((target: targetId, selector: selector, args: argumentIds));
    return InstanceRef(
      id: 'objects/invoked',
      kind: InstanceKind.kString,
      valueAsString: 'invoked',
    );
  }

  @override
  Future<Obj> getObject(
    String isolateId,
    String objectId, {
    int? offset,
    int? count,
    String? idZoneId,
  }) async {
    if (failure case final failure?) throw failure;
    objectLookups.add(objectId);
    return Instance(id: objectId, kind: InstanceKind.kString);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('evaluation lifecycle', () {
    late _LookupService service;
    late FakeConnection connection;
    late EvalFactory factory;
    late Eval eval;
    late Disposable alive;
    setUp(() {
      service = _LookupService();
      connection = FakeConnection(service);
      factory = EvalFactory(connection);
      eval = factory.dartCore;
      alive = Disposable();
    });
    tearDown(() => factory.dispose());

    test('does not send class lookups after the isolate disappears', () async {
      connection.isolate = null;
      await expectLater(
        eval.getClass(ClassRef(id: 'classes/1'), isAlive: alive),
        throwsA(isA<CancelledException>()),
      );
      expect(service.requests, 0);
    });

    test('cancels a lookup failing during disconnect', () async {
      final result = eval.getClass(ClassRef(id: 'classes/1'), isAlive: alive);
      final expectation = expectLater(
        result,
        throwsA(isA<CancelledException>()),
      );
      connection.connected = false;
      connection.isolate = null;
      service.response.completeError(StateError('connection closed'));
      await expectation;
      expect(() => factory.dartCore, throwsA(isA<CancelledException>()));
      expect(factory.dispose, returnsNormally);
    });

    test(
      'cancels pending requests without waiting for a VM response',
      () async {
        final result = eval.getClass(ClassRef(id: 'classes/1'), isAlive: alive);
        final expectation = expectLater(
          result,
          throwsA(isA<CancelledException>()),
        );
        connection.connected = false;
        await expectation;
        // A late failure must also be consumed, rather than becoming unhandled.
        service.response.completeError(StateError('late connection failure'));
        await pumpEventQueue();
      },
    );

    test('discards successful responses received after disconnect', () async {
      final result = eval.getClass(ClassRef(id: 'classes/1'), isAlive: alive);
      final expectation = expectLater(
        result,
        throwsA(isA<CancelledException>()),
      );
      connection.connected = false;
      service.response.complete(Class(id: 'classes/1'));
      await expectation;
    });

    test('cancels a lookup whose inspector was disposed', () async {
      final result = eval.getClass(ClassRef(id: 'classes/1'), isAlive: alive);
      final expectation = expectLater(
        result,
        throwsA(isA<CancelledException>()),
      );
      alive.dispose();
      service.response.completeError(StateError('owner disposed'));
      await expectation;
    });

    test('preserves unexpected failures while still connected', () async {
      final result = eval.getClass(ClassRef(id: 'classes/1'), isAlive: alive);
      final error = StateError('lookup failed');
      final expectation = expectLater(result, throwsA(same(error)));
      service.response.completeError(error);
      await expectation;
    });

    test('returns live class lookups', () async {
      final result = eval.getClass(ClassRef(id: 'classes/1'), isAlive: alive);
      final value = Class(id: 'classes/1');
      service.response.complete(value);
      expect((await result).valueOrNull, same(value));
    });
  });
  group('evaluation', () {
    late _EvalService service;
    late EvalFactory factory;
    late Disposable alive;
    setUp(() {
      service = _EvalService();
      factory = EvalFactory(FakeConnection(service));
      alive = Disposable();
    });
    tearDown(() => factory.dispose());

    test('evaluates code in the requested library', () async {
      final result = await factory.dartCore.eval(
        'a\n+ b',
        isAlive: alive,
        scope: {'a': 'objects/1'},
      );

      expect(result.require.instance.valueAsString, 'ok');
      expect(service.evaluations.map((e) => '$e'), [
        '(expression: a + b, scope: {a: objects/1}, target: libraries/core)',
      ]);
    });

    test('looks up the libraries of an isolate once', () async {
      await factory.dartCore.eval('1', isAlive: alive);
      await factory.dartAsync.eval('2', isAlive: alive);

      expect(service.isolateLookups, 1);
    });

    test('finds libraries that were loaded after the first lookup', () async {
      await factory.dartCore.eval('1', isAlive: alive);
      service.libraries.add(LibraryRef(id: 'libraries/late', uri: 'late.dart'));

      final result = await factory
          .forLibrary('late.dart')
          .eval('2', isAlive: alive);

      expect(result, isA<ByteVariable<VmInstanceRef>>());
      expect(service.evaluations.last.target, 'libraries/late');
    });

    test('fails for libraries that the application does not have', () async {
      await expectLater(
        factory.forLibrary('missing.dart').eval('1', isAlive: alive),
        throwsA(
          isA<LibraryNotFound>().having(
            (e) => e.toString(),
            'toString',
            'Library matching missing.dart not found',
          ),
        ),
      );
    });

    test('retries isolate lookups that failed', () async {
      service.isolateError = StateError('not ready');
      await expectLater(
        factory.dartCore.eval('1', isAlive: alive),
        throwsStateError,
      );

      service.isolateError = null;

      expect(
        await factory.dartCore.eval('1', isAlive: alive),
        isA<ByteVariable<VmInstanceRef>>(),
      );
    });

    test('passes the scope of web applications through a closure', () async {
      service.libraries.add(LibraryRef(id: 'libraries/html', uri: 'dart:html'));

      final result = await factory.dartCore.eval(
        'a + b',
        isAlive: alive,
        scope: {'a': 'objects/1', 'b': 'objects/2'},
      );

      expect(result.require.instance.valueAsString, 'invoked');
      expect(service.evaluations.map((e) => '$e'), [
        '(expression: (a,b) => a + b, scope: null, target: libraries/core)',
      ]);
      expect(service.invocations.map((e) => '$e'), [
        '(args: [objects/1, objects/2], selector: call, target: objects/ok)',
      ]);
    });

    test('evaluates web code without scope directly', () async {
      service.libraries.add(LibraryRef(id: 'libraries/html', uri: 'dart:html'));

      await factory.dartCore.eval('1', isAlive: alive);

      expect(service.invocations, isEmpty);
    });

    test('reports code that throws or does not compile', () async {
      service.response = ErrorRef(
        id: 'objects/error',
        kind: ErrorKind.kUnhandledException,
        message: 'Bad state: nope',
      );

      final result = await factory.dartCore.eval('throw 1', isAlive: alive);

      expect(
        result,
        isA<ByteError<VmInstanceRef>>().having(
          (e) => e.error,
          'error',
          isA<EvalErrorType>()
              .having((e) => '$e', 'toString', 'EvalError: Bad state: nope')
              .having(
                (e) => '${e.error}',
                'exception',
                'Evaluation `throw 1` failed with Bad state: nope',
              ),
        ),
      );
    });

    test('reports expired sessions', () async {
      service.response = ErrorRef(
        id: 'objects/error',
        kind: ErrorKind.kUnhandledException,
        message: 'Bad state: Riverpod devtool session expired',
      );

      expect(
        await factory.dartCore.eval('1', isAlive: alive),
        ByteError<VmInstanceRef>(const ExpiredDevtoolSessionType()),
      );
    });

    test('reports objects that expired', () async {
      service.failure = SentinelException.parse('getObject', {
        'type': 'Sentinel',
        'kind': SentinelKind.kExpired,
        'valueAsString': '<expired>',
      });

      final result = await factory.dartCore.instance(
        VmInstanceRef.string('gone'),
        isAlive: alive,
      );

      expect(
        result,
        isA<ByteError<VmInstance>>().having(
          (e) => e.error,
          'error',
          isA<ExpiredSentinelExceptionType>(),
        ),
      );
    });

    test('reports failed requests', () async {
      service.failure = RPCError('evaluate', 100, 'Feature is disabled');

      final result = await factory.dartCore.eval('1', isAlive: alive);

      expect(
        result,
        isA<ByteError<VmInstanceRef>>().having(
          (e) => e.error,
          'error',
          isA<RPCErrorType>(),
        ),
      );
    });

    test('reports responses that are not instances', () async {
      service.response = Success();

      final result = await factory.dartCore.eval('1', isAlive: alive);

      expect(
        result,
        isA<ByteError<VmInstanceRef>>().having(
          (e) => '${e.error}',
          'error',
          startsWith(
            'UnknownEvalError: Unknown error during the evaluation of `1`',
          ),
        ),
      );
    });

    test('evalInstance loads the evaluated instance', () async {
      final result = await factory.dartCore.evalInstance('1', isAlive: alive);

      expect(result.require.instance.id, 'objects/ok');
      expect(service.objectLookups, ['objects/ok']);
    });

    test('evalInstance does not load failed evaluations', () async {
      service.failure = RPCError('evaluate', 100, 'Feature is disabled');

      final result = await factory.dartCore.evalInstance('1', isAlive: alive);

      expect(result, isA<ByteError<VmInstance>>());
      expect(service.objectLookups, isEmpty);
    });

    test('waitUntil evaluates a condition until it is true', () async {
      final answers = ['false', 'false', 'true', 'false'];
      service.respond = () => InstanceRef(
        id: 'objects/bool',
        kind: InstanceKind.kBool,
        valueAsString: answers.removeAt(0),
      );

      await factory.dartCore.waitUntil('done', isAlive: alive);

      expect(service.evaluations, hasLength(3));
    });

    test('waitUntil gives up on conditions that stay false or fail', () async {
      service.respond = () => InstanceRef(
        id: 'objects/bool',
        kind: InstanceKind.kBool,
        valueAsString: 'false',
      );
      await factory.dartCore.waitUntil(
        'done',
        isAlive: alive,
        timeout: const Duration(milliseconds: 20),
      );
      expect(service.evaluations, isNotEmpty);

      service.evaluations.clear();
      service.failure = RPCError('evaluate', 100, 'Feature is disabled');
      await factory.dartCore.waitUntil('done', isAlive: alive);
      expect(service.evaluations, hasLength(1));
    });

    test('forRef evaluates in the library of the instance', () {
      final ref = VmInstanceRef(
        InstanceRef(
          id: 'objects/1',
          classRef: ClassRef(
            id: 'classes/1',
            library: LibraryRef(id: 'libraries/1', uri: 'package:a/a.dart'),
          ),
        ),
      );

      expect(factory.forRef(ref)?.libraryName, 'package:a/a.dart');
      expect(factory.forRef(VmInstanceRef.string('core')), isNull);
      expect(factory.forRef(null), isNull);
    });

    test('evaluates against a real application', () async {
      final app = await startApp();
      final factory = EvalFactory(app.connection);
      addTearDown(factory.dispose);

      final sum = await factory.dartCore.evalInstance('1 + 1', isAlive: alive);
      expect(sum.require.instance.valueAsString, '2');

      final scoped = await factory.dartCore.eval(
        'that.length',
        isAlive: alive,
        scope: {'that': sum.require.instance.classRef!.id!},
      );
      expect(scoped, isA<ByteError<VmInstanceRef>>());

      final thrown = await factory.dartCore.eval(
        'throw StateError("nope")',
        isAlive: alive,
      );
      expect('${(thrown as ByteError).error}', contains('nope'));

      final session = await factory.riverpodFramework.eval(
        'RiverpodDevtool.instance.validateSession("unknown")',
        isAlive: alive,
      );
      expect(
        session,
        ByteError<VmInstanceRef>(const ExpiredDevtoolSessionType()),
      );
    });
  });

  group('runAndRetryOnExpired', () {
    test('returns successful values immediately', () async {
      var calls = 0;

      final result = await runAndRetryOnExpired<int>(() async {
        calls++;
        return const ByteVariable(42);
      });

      expect(result, const ByteVariable(42));
      expect(calls, 1);
    });

    test('retries expired sentinels and then returns success', () async {
      var attempts = 0;
      var retries = 0;

      final result = await runAndRetryOnExpired<int>(
        () async {
          attempts++;
          if (attempts < 3) {
            return ByteError(
              ExpiredSentinelExceptionType(
                Sentinel(kind: SentinelKind.kExpired, valueAsString: 'expired'),
              ),
            );
          }

          return const ByteVariable(7);
        },
        onRetry: () {
          retries++;
          return null;
        },
      );

      expect(result, const ByteVariable(7));
      expect(attempts, 3);
      expect(retries, 2);
    });

    test('stops retrying when the retry itself fails', () async {
      var attempts = 0;

      final result = await runAndRetryOnExpired<int>(() async {
        attempts++;
        return ByteError(
          ExpiredSentinelExceptionType(
            Sentinel(kind: SentinelKind.kExpired, valueAsString: 'expired'),
          ),
        );
      }, onRetry: () => const ExpiredDevtoolSessionType());

      expect(result, ByteError<int>(const ExpiredDevtoolSessionType()));
      expect('${(result as ByteError<int>).error}', 'DevTools session expired');
      expect(attempts, 1);
    });

    test('returns non-expired errors without retrying', () async {
      var attempts = 0;
      var retries = 0;

      final result = await runAndRetryOnExpired<int>(
        () async {
          attempts++;
          return ByteError(UnknownEvalErrorType('boom'));
        },
        onRetry: () {
          retries++;
          return null;
        },
      );

      expect(result, isA<ByteError<int>>());
      expect(
        (result as ByteError<int>).error.toString(),
        'UnknownEvalError: boom',
      );
      expect(retries, 0);
      expect(attempts, 1);
    });
  });
}
