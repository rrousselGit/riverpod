import 'package:devtools_app_shared/service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_devtool/src/vm_service.dart';
import 'package:vm_service/vm_service.dart';

class _FakeVmService implements VmService {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
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
