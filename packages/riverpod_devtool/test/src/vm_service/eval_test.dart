import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_devtool/src/vm_service.dart';
import 'package:vm_service/vm_service.dart';

void main() {
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
              SentinelExceptionType(
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
      var retries = 0;

      final result = await runAndRetryOnExpired<int>(
        () async => ByteError(UnknownEvalErrorType('boom')),
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
    });
  });
}
