import 'dart:async';

import 'package:devtools_app_shared/service.dart';
import 'package:devtools_app_shared/src/service/isolate_manager.dart'
    show TestIsolateManager;
import 'package:devtools_app_shared/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_devtool/src/vm_service.dart';
import 'package:vm_service/vm_service.dart';

class _FakeVmService implements VmService {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

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

final class _Isolates with TestIsolateManager {
  @override
  final ValueNotifier<IsolateRef?> selectedIsolate = ValueNotifier<IsolateRef?>(
    IsolateRef(id: 'isolates/1', number: '1', name: 'main'),
  );

  @override
  IsolateState isolateState(IsolateRef ref) =>
      IsolateState(ref)..handleIsolateLoad(
        Isolate(
          libraries: [
            LibraryRef(id: 'libraries/1', uri: 'dart:core', name: 'dart:core'),
          ],
        ),
      );

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

// A controllable connection is needed to reproduce disconnect races.
// ignore: subtype_of_sealed_class
class _Manager implements ServiceManager<VmService> {
  @override
  final ValueNotifier<ConnectedState> connectedState = ValueNotifier(
    const ConnectedState(true),
  );
  @override
  final _Isolates isolateManager = _Isolates();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('evaluation lifecycle', () {
    late _LookupService service;
    late _Manager manager;
    late EvalFactory factory;
    late Eval eval;
    late Disposable alive;
    setUp(() {
      service = _LookupService();
      manager = _Manager();
      factory = EvalFactory(vmService: service, serviceManager: manager);
      eval = factory.dartCore;
      alive = Disposable();
    });
    tearDown(() {
      factory.dispose();
      manager.connectedState.dispose();
      manager.isolateManager.selectedIsolate.dispose();
    });

    test('does not send class lookups after the isolate disappears', () async {
      manager.isolateManager.selectedIsolate.value = null;
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
      manager.connectedState.value = const ConnectedState(false);
      manager.isolateManager.selectedIsolate.value = null;
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
        manager.connectedState.value = const ConnectedState(false);
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
      manager.connectedState.value = const ConnectedState(false);
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
  group('EvalFactory.dispose', () {
    test('does not throw when cached evals remove themselves', () {
      final factory = EvalFactory(
        vmService: _FakeVmService(),
        serviceManager: ServiceManager<VmService>(),
      );

      factory.forLibrary('dart:core');
      factory.forLibrary('dart:async');

      expect(factory.dispose, returnsNormally);
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
