import 'package:riverpod/src/synchronous_future.dart';
import 'package:test/test.dart';

void main() {
  group('SynchronousFuture', () {
    test('can be awaited synchronously', () {
      var x = 0;

      Future<void> fn() async {
        x = await SynchronousFuture(42);
      }

      fn();

      expect(x, 42);
    });

    test('implements ==', () {
      expect(
        SynchronousFuture(42),
        SynchronousFuture(42),
      );

      expect(
        SynchronousFuture(42),
        isNot(SynchronousFuture(21)),
      );
    });

    test('overrides hashCode', () {
      expect(
        SynchronousFuture(42).hashCode,
        SynchronousFuture(42).hashCode,
      );

      expect(
        SynchronousFuture(42).hashCode,
        isNot(SynchronousFuture(21).hashCode),
      );
    });

    test('overrides toString', () {
      expect(
        SynchronousFuture(42).toString(),
        'SynchronousFuture<int>(42)',
      );
    });
  });

  test('SynchronousFuture.catchError', () {
    expect(
      // ignore: avoid_types_on_closure_parameters
      SynchronousFuture(42).catchError((Object? err, StackTrace stack) {}),
      SynchronousFuture(42),
    );
  });

  // Imported from Flutter
  test('SynchronousFuture control test', () async {
    final Future<int> future = SynchronousFuture<int>(42);

    int? result;
    // ignore: unawaited_futures
    future.then<void>((value) {
      result = value;
    });

    expect(result, equals(42));
    result = null;

    final futureWithTimeout = future.timeout(const Duration(milliseconds: 1));
    // ignore: unawaited_futures
    futureWithTimeout.then<void>((value) {
      result = value;
    });
    expect(result, isNull);
    await futureWithTimeout;
    expect(result, equals(42));
    result = null;

    final stream = future.asStream();

    expect(await stream.single, equals(42));

    var ranAction = false;
    // ignore: void_checks
    final completeResult = future.whenComplete(() {
      // ignore: void_checks, https://github.com/dart-lang/linter/issues/1675
      ranAction = true;
      // verify that whenComplete does NOT propagate its return value:
      return Future<int>.value(31);
    });

    expect(ranAction, isTrue);
    ranAction = false;

    expect(await completeResult, equals(42));

    Object? exception;
    try {
      // ignore: void_checks
      await future.whenComplete(() {
        // ignore: void_checks, https://github.com/dart-lang/linter/issues/1675
        throw ArgumentError();
      });
      // Unreached.
      expect(false, isTrue);
    } catch (e) {
      exception = e;
    }
    expect(exception, isArgumentError);
  });
}
