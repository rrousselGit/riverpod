// ignore_for_file: avoid_types_on_closure_parameters

import 'dart:async';

import 'package:riverpod/riverpod.dart';
import 'package:riverpod/src/internals.dart';
import 'package:test/test.dart';

void main() {
  group('custom AsyncValue', () {
    test('supports when', () {
      expect(
        const CustomData(42).whenOrNull(data: (v) => v * 2),
        84,
      );

      expect(
        const CustomError<int>(42, stackTrace: StackTrace.empty)
            .whenOrNull(data: (v) => v * 2),
        null,
      );

      expect(
        const CustomLoading<int>().whenOrNull(data: (v) => v * 2),
        null,
      );
    });
  });

  test('unwrapPrevious', () {
    expect(
      const AsyncLoading<int>()
          .copyWithPrevious(const AsyncData(42))
          .unwrapPrevious(),
      const AsyncLoading<int>(),
    );
    expect(
      const AsyncLoading<int>()
          .copyWithPrevious(const AsyncError(42, StackTrace.empty))
          .unwrapPrevious(),
      const AsyncLoading<int>(),
    );

    expect(
      const AsyncData<int>(42)
          .copyWithPrevious(const AsyncLoading())
          .unwrapPrevious(),
      const AsyncData<int>(42),
    );
    expect(
      const AsyncData<int>(42)
          .copyWithPrevious(const AsyncError(42, StackTrace.empty))
          .unwrapPrevious(),
      const AsyncData<int>(42),
    );

    expect(
      const AsyncError<int>(42, StackTrace.empty)
          .copyWithPrevious(const AsyncLoading())
          .unwrapPrevious(),
      const AsyncError<int>(42, StackTrace.empty),
    );
    expect(
      const AsyncError<int>(42, StackTrace.empty)
          .copyWithPrevious(const AsyncError(21, StackTrace.empty))
          .unwrapPrevious(),
      const AsyncError<int>(42, StackTrace.empty),
    );
    expect(
      const AsyncError<int>(42, StackTrace.empty)
          .copyWithPrevious(const AsyncData(42))
          .unwrapPrevious(),
      const AsyncError<int>(42, StackTrace.empty),
    );
  });

  test('isRefreshing', () {
    expect(const AsyncLoading<int>().isRefreshing, false);
    expect(
      const AsyncLoading<int>()
          .copyWithPrevious(const AsyncLoading())
          .isRefreshing,
      false,
    );

    expect(const AsyncData<int>(42).isRefreshing, false);
    expect(
      const AsyncLoading<int>()
          .copyWithPrevious(const AsyncData<int>(42))
          .isRefreshing,
      true,
    );

    expect(const AsyncError<int>('err', StackTrace.empty).isRefreshing, false);
    expect(
      const AsyncLoading<int>()
          .copyWithPrevious(const AsyncError<int>('err', StackTrace.empty))
          .isRefreshing,
      true,
    );
  });

  test('isLoading', () {
    expect(const AsyncData(42).isLoading, false);
    expect(const AsyncLoading<int>().isLoading, true);
    expect(const AsyncError<int>(Object(), StackTrace.empty).isLoading, false);

    expect(
      const AsyncLoading<int>().copyWithPrevious(const AsyncData(42)).isLoading,
      true,
    );
    expect(
      const AsyncLoading<int>()
          .copyWithPrevious(const AsyncError(42, StackTrace.empty))
          .isLoading,
      true,
    );

    expect(
      const AsyncData<int>(42).copyWithPrevious(const AsyncLoading()).isLoading,
      false,
    );
    expect(
      const AsyncData<int>(42)
          .copyWithPrevious(const AsyncError(42, StackTrace.empty))
          .isLoading,
      false,
    );
  });

  test('asError', () {
    const value = AsyncValue<int>.error(42, StackTrace.empty);

    // ignore: omit_local_variable_types, unused_local_variable, testing that assignment works,
    final AsyncError? error = value.asError;

    expect(const AsyncData(42).asError, null);
    expect(const AsyncLoading<int>().asError, null);
    expect(
      const AsyncError<int>(Object(), StackTrace.empty).asError,
      const AsyncError<int>(Object(), StackTrace.empty),
    );
  });

  test('map', () {
    expect(
      const AsyncValue.data(42).map(
        data: (AsyncData<int> value) => [value.value],
        error: (value) => throw Error(),
        loading: (_) => throw Error(),
      ),
      [42],
    );

    final stack = StackTrace.current;

    expect(
      AsyncError<int>(42, stack).map(
        data: (value) => throw Error(),
        error: (AsyncError<int> error) => [error.error, error.stackTrace],
        loading: (_) => throw Error(),
      ),
      [42, stack],
    );

    expect(
      const AsyncLoading<int>().map(
        data: (value) => throw Error(),
        error: (_) => throw Error(),
        loading: (AsyncLoading<int> loading) => 'loading',
      ),
      'loading',
    );
  });

  group('maybeMap', () {
    test('matching case', () {
      expect(
        const AsyncValue.data(42).maybeMap(
          data: (AsyncData<int> value) => [value.value],
          orElse: () => throw Error(),
        ),
        [42],
      );

      final stack = StackTrace.current;

      expect(
        AsyncError<int>(42, stack).maybeMap(
          error: (AsyncError<int> error) => [error.error, error.stackTrace],
          orElse: () => throw Error(),
        ),
        [42, stack],
      );

      expect(
        const AsyncLoading<int>().maybeMap(
          loading: (AsyncLoading<int> loading) => 'loading',
          orElse: () => throw Error(),
        ),
        'loading',
      );
    });

    test('orElse', () {
      expect(
        const AsyncValue.data(42).maybeMap(
          error: (_) => throw Error(),
          loading: (_) => throw Error(),
          orElse: () => 'orElse',
        ),
        'orElse',
      );

      final stack = StackTrace.current;

      expect(
        AsyncError<int>(42, stack).maybeMap(
          data: (value) => throw Error(),
          loading: (_) => throw Error(),
          orElse: () => 'orElse',
        ),
        'orElse',
      );

      expect(
        const AsyncLoading<int>().maybeMap(
          data: (value) => throw Error(),
          error: (_) => throw Error(),
          orElse: () => 'orElse',
        ),
        'orElse',
      );
    });
  });

  group('mapOrNull', () {
    test('matching case', () {
      expect(
        const AsyncValue.data(42).mapOrNull(
          data: (AsyncData<int> value) => [value.value],
        ),
        [42],
      );

      final stack = StackTrace.current;

      expect(
        AsyncError<int>(42, stack).mapOrNull(
          error: (AsyncError<int> error) => [error.error, error.stackTrace],
        ),
        [42, stack],
      );

      expect(
        const AsyncLoading<int>().mapOrNull(
          loading: (AsyncLoading<int> loading) => 'loading',
        ),
        'loading',
      );
    });

    test('orElse', () {
      expect(
        const AsyncValue.data(42).mapOrNull(
          error: (_) => throw Error(),
          loading: (_) => throw Error(),
        ),
        null,
      );

      final stack = StackTrace.current;

      expect(
        AsyncError<int>(42, stack).mapOrNull(
          data: (value) => throw Error(),
          loading: (_) => throw Error(),
        ),
        null,
      );

      expect(
        const AsyncLoading<int>().mapOrNull(
          data: (value) => throw Error(),
          error: (_) => throw Error(),
        ),
        null,
      );
    });
  });

  test('when', () {
    expect(
      const AsyncValue.data(42).when(
        data: (value) => [value],
        error: (a, b) => throw Error(),
        loading: () => throw Error(),
      ),
      [42],
    );

    final stack = StackTrace.current;

    expect(
      AsyncError<int>(
        42,
        stack,
      ).when(
        data: (value) => throw Error(),
        error: (a, b) => [a, b],
        loading: () => throw Error(),
      ),
      [42, stack],
    );

    expect(
      const AsyncLoading<int>().when(
        data: (value) => throw Error(),
        error: (a, b) => throw Error(),
        loading: () => 'loading',
      ),
      'loading',
    );
  });

  group('maybeWhen', () {
    test('matching case', () {
      expect(
        const AsyncValue.data(42).maybeWhen(
          data: (value) => [value],
          orElse: () => throw Error(),
        ),
        [42],
      );

      final stack = StackTrace.current;

      expect(
        AsyncError<int>(
          42,
          stack,
        ).maybeWhen(
          error: (a, b) => [a, b],
          orElse: () => throw Error(),
        ),
        [42, stack],
      );

      expect(
        const AsyncLoading<int>().maybeWhen(
          loading: () => 'loading',
          orElse: () => throw Error(),
        ),
        'loading',
      );
    });

    test('orElse', () {
      expect(
        const AsyncValue.data(42).maybeWhen(
          error: (a, b) => throw Error(),
          loading: () => throw Error(),
          orElse: () => 'orElse',
        ),
        'orElse',
      );

      final stack = StackTrace.current;

      expect(
        AsyncError<int>(42, stack).maybeWhen(
          data: (value) => throw Error(),
          loading: () => throw Error(),
          orElse: () => 'orElse',
        ),
        'orElse',
      );

      expect(
        const AsyncLoading<int>().maybeWhen(
          data: (value) => throw Error(),
          error: (a, b) => throw Error(),
          orElse: () => 'orElse',
        ),
        'orElse',
      );
    });
  });

  group('whenOrNull', () {
    test('matching case', () {
      expect(
        const AsyncValue.data(42).whenOrNull(
          data: (value) => [value],
        ),
        [42],
      );

      final stack = StackTrace.current;

      expect(
        AsyncError<int>(
          42,
          stack,
        ).whenOrNull(
          error: (a, b) => [a, b],
        ),
        [42, stack],
      );

      expect(
        const AsyncLoading<int>().whenOrNull(
          loading: () => 'loading',
        ),
        'loading',
      );
    });

    test('orElse', () {
      expect(
        const AsyncValue.data(42).whenOrNull(
          error: (a, b) => throw Error(),
          loading: () => throw Error(),
        ),
        null,
      );

      final stack = StackTrace.current;

      expect(
        AsyncError<int>(42, stack).whenOrNull(
          data: (value) => throw Error(),
          loading: () => throw Error(),
        ),
        null,
      );

      expect(
        const AsyncLoading<int>().whenOrNull(
          data: (value) => throw Error(),
          error: (a, b) => throw Error(),
        ),
        null,
      );
    });
  });

  test('==', () {
    // ignore: prefer_const_declarations
    final value = 42;
    // ignore: prefer_const_declarations
    final value2 = 21;

    final stack = StackTrace.current;
    final stack2 = StackTrace.current;

    expect(
      AsyncData<int>(value),
      AsyncData<int>(value),
    );
    expect(
      AsyncData<int>(value),
      isNot(const AsyncLoading<int>().copyWithPrevious(AsyncData(value))),
    );
    expect(
      AsyncData<int>(value),
      isNot(AsyncData<int>(value2)),
    );
    expect(
      AsyncData<int>(value),
      isNot(AsyncValue<num>.data(value)),
    );
    expect(
      AsyncValue<num>.data(value),
      isNot(AsyncData<int>(value)),
    );
    expect(
      const AsyncData<int>(42).copyWithPrevious(const AsyncLoading()),
      const AsyncData<int>(42),
    );
    expect(
      const AsyncData<int>(42)
          .copyWithPrevious(const AsyncError(42, StackTrace.empty)),
      const AsyncData<int>(42),
    );

    expect(
      AsyncError<int>(value, stack),
      AsyncError<int>(value, stack),
    );
    expect(
      AsyncError<int>(value, stack),
      isNot(
        const AsyncLoading<int>()
            .copyWithPrevious(AsyncError<int>(value, stack)),
      ),
    );
    expect(
      AsyncError<int>(value, stack),
      isNot(AsyncValue<num>.error(value, stack)),
    );
    expect(
      AsyncValue<num>.error(value, stack),
      isNot(AsyncError<int>(value, stack)),
    );
    expect(
      AsyncError<int>(value, stack),
      isNot(AsyncError<int>(value, stack2)),
    );
    expect(
      AsyncError<int>(value, stack),
      isNot(AsyncError<int>(value2, stack)),
    );

    expect(
      // ignore: prefer_const_constructors
      AsyncLoading<int>(),
      // ignore: prefer_const_constructors
      AsyncLoading<int>(),
    );
    expect(
      // ignore: prefer_const_constructors
      AsyncLoading<int>(),
      // ignore: prefer_const_constructors
      isNot(AsyncValue<num>.loading()),
    );
    expect(
      // ignore: prefer_const_constructors
      AsyncValue<num>.loading(),
      // ignore: prefer_const_constructors
      isNot(AsyncLoading<int>()),
    );

    expect(
      const AsyncError<int?>(42, StackTrace.empty)
          .copyWithPrevious(const AsyncData(null)),
      isNot(const AsyncError<int?>(42, StackTrace.empty)),
      reason: 'hasValue should be checked',
    );

    expect(
      const AsyncError<int?>(42, StackTrace.empty)
          .copyWithPrevious(const AsyncData(42)),
      isNot(
        const AsyncData<int?>(42)
            .copyWithPrevious(const AsyncError(42, StackTrace.empty)),
      ),
      reason: 'runtimeType should be checked',
    );
  });

  test('hashCode', () {
    // ignore: prefer_const_declarations
    final value = 42;
    // ignore: prefer_const_declarations
    final value2 = 21;

    final stack = StackTrace.current;
    final stack2 = StackTrace.current;

    expect(
      AsyncData<int>(value).hashCode,
      AsyncData<int>(value).hashCode,
    );
    expect(
      AsyncData<int>(value).hashCode,
      isNot(
        const AsyncLoading<int>().copyWithPrevious(AsyncData(value)).hashCode,
      ),
    );
    expect(
      AsyncData<int>(value).hashCode,
      isNot(AsyncData<int>(value2).hashCode),
    );
    expect(
      AsyncData<int>(value).hashCode,
      isNot(AsyncValue<num>.data(value).hashCode),
    );
    expect(
      AsyncValue<num>.data(value).hashCode,
      isNot(AsyncData<int>(value).hashCode),
    );

    expect(
      AsyncError<int>(value, stack).hashCode,
      AsyncError<int>(value, stack).hashCode,
    );

    expect(
      AsyncError<int>(value, stack).hashCode,
      isNot(
        const AsyncLoading<int>()
            .copyWithPrevious(AsyncError(value, stack))
            .hashCode,
      ),
    );

    expect(
      AsyncError<int>(value, stack).hashCode,
      isNot(AsyncValue<num>.error(value, stack).hashCode),
    );
    expect(
      AsyncValue<num>.error(value, stack).hashCode,
      isNot(AsyncError<int>(value, stack).hashCode),
    );
    expect(
      AsyncError<int>(value, stack).hashCode,
      isNot(AsyncError<int>(value, stack2).hashCode),
    );
    expect(
      AsyncError<int>(value, stack).hashCode,
      isNot(AsyncError<int>(value2, stack).hashCode),
    );

    expect(
      // ignore: prefer_const_constructors
      AsyncLoading<int>().hashCode,
      // ignore: prefer_const_constructors
      AsyncLoading<int>().hashCode,
    );
    expect(
      // ignore: prefer_const_constructors
      AsyncLoading<int>().hashCode,
      // ignore: prefer_const_constructors
      isNot(AsyncValue<num>.loading().hashCode),
    );
    expect(
      // ignore: prefer_const_constructors
      AsyncValue<num>.loading().hashCode,
      // ignore: prefer_const_constructors
      isNot(AsyncLoading<int>().hashCode),
    );

    expect(
      const AsyncError<int?>(42, StackTrace.empty)
          .copyWithPrevious(const AsyncData(null))
          .hashCode,
      isNot(const AsyncError<int?>(42, StackTrace.empty).hashCode),
      reason: 'hasValue should be checked',
    );

    expect(
      const AsyncError<int?>(42, StackTrace.empty)
          .copyWithPrevious(const AsyncData(42))
          .hashCode,
      isNot(
        const AsyncData<int?>(42)
            .copyWithPrevious(const AsyncError(42, StackTrace.empty))
            .hashCode,
      ),
      reason: 'runtimeType should be checked',
    );
  });

  test('toString', () {
    expect(
      const AsyncValue.data(42).toString(),
      'AsyncData<int>(value: 42)',
    );
    expect(
      const AsyncError<int>(42, StackTrace.empty).toString(),
      'AsyncError<int>(error: 42, stackTrace: )',
    );
    expect(
      const AsyncLoading<int>().toString(),
      'AsyncLoading<int>()',
    );

    expect(
      const AsyncLoading<int>()
          .copyWithPrevious(const AsyncData(42))
          .toString(),
      'AsyncData<int>(isLoading: true, value: 42)',
    );
    expect(
      const AsyncLoading<int>()
          .copyWithPrevious(const AsyncError(42, StackTrace.empty))
          .toString(),
      'AsyncError<int>(isLoading: true, error: 42, stackTrace: )',
    );
    expect(
      const AsyncData<int>(42)
          .copyWithPrevious(const AsyncError(42, StackTrace.empty))
          .toString(),
      'AsyncData<int>(value: 42)',
    );
    expect(
      const AsyncError<int>(42, StackTrace.empty)
          .copyWithPrevious(const AsyncData(42))
          .toString(),
      'AsyncError<int>(value: 42, error: 42, stackTrace: )',
    );
  });

  test('hasValue', () {
    expect(const AsyncData(42).hasValue, true);
    expect(const AsyncLoading<int>().hasValue, false);
    expect(const AsyncError<int>('err', StackTrace.empty).hasValue, false);

    expect(
      const AsyncError<int>(42, StackTrace.empty)
          .copyWithPrevious(const AsyncData(42))
          .hasValue,
      true,
    );
    expect(
      const AsyncError<int>(42, StackTrace.empty)
          .copyWithPrevious(
            const AsyncLoading<int>().copyWithPrevious(const AsyncData(42)),
          )
          .hasValue,
      true,
    );
    expect(
      const AsyncLoading<int>().copyWithPrevious(const AsyncData(42)).hasValue,
      true,
    );
  });

  test('hasError', () {
    expect(const AsyncData(42).hasError, false);
    expect(const AsyncLoading<int>().hasError, false);
    expect(const AsyncError<int>('err', StackTrace.empty).hasError, true);

    expect(
      const AsyncData<int>(42)
          .copyWithPrevious(const AsyncError(42, StackTrace.empty))
          .hasError,
      false,
    );
    expect(
      const AsyncData<int>(42)
          .copyWithPrevious(
            const AsyncLoading<int>()
                .copyWithPrevious(const AsyncError(42, StackTrace.empty)),
          )
          .hasError,
      false,
    );
    expect(
      const AsyncLoading<int>()
          .copyWithPrevious(const AsyncError(42, StackTrace.empty))
          .hasError,
      true,
    );
  });

  group('whenData', () {
    test('preserves isLoading/isRefreshing', () {
      expect(
        const AsyncLoading<int>()
            .copyWithPrevious(const AsyncData(42))
            .whenData((value) => value * 2),
        const AsyncLoading<int>().copyWithPrevious(const AsyncData(84)),
      );

      expect(
        const AsyncLoading<int>()
            .copyWithPrevious(const AsyncData(42))
            .whenData<String>(
              (value) => Error.throwWithStackTrace(84, StackTrace.empty),
            ),
        const AsyncLoading<String>().copyWithPrevious(
          const AsyncError(84, StackTrace.empty),
        ),
      );

      expect(
        const AsyncLoading<int>()
            .copyWithPrevious(
              const AsyncError(84, StackTrace.empty),
            )
            .whenData<String>((value) => '$value'),
        const AsyncLoading<String>().copyWithPrevious(
          const AsyncError(84, StackTrace.empty),
        ),
      );
    });

    test('transforms data if any', () {
      expect(
        const AsyncValue.data(42).whenData((value) => '$value'),
        const AsyncData<String>('42'),
      );
      expect(
        const AsyncLoading<int>().whenData((value) => '$value'),
        const AsyncLoading<String>(),
      );
      expect(
        const AsyncError<int>(21, StackTrace.empty)
            .whenData((value) => '$value'),
        const AsyncError<String>(21, StackTrace.empty),
      );
    });

    test('catches errors in data transformer and return AsyncError', () {
      expect(
        const AsyncValue.data(42).whenData<int>(
          // ignore: only_throw_errors
          (value) => throw '42',
        ),
        isA<AsyncError<int>>()
            .having((e) => e.error, 'error', '42')
            .having((e) => e.stackTrace, 'stackTrace', isNotNull),
      );
    });
  });

  test('AsyncValue.asData', () {
    const value = AsyncValue<int>.data(42);

    // ignore: omit_local_variable_types, unused_local_variable, testing that assignment works,
    final AsyncData? data = value.asData;

    expect(
      const AsyncValue.data(42).asData,
      const AsyncData<int>(42),
    );
    expect(const AsyncValue<void>.loading().asData, isNull);
    expect(AsyncValue<void>.error(Error(), StackTrace.empty).asData, isNull);

    expect(
      const AsyncValue<int?>.data(null).asData,
      const AsyncData<int?>(null),
    );
  });

  test('AsyncValue.value', () {
    expect(const AsyncValue.data(42).value, 42);
    expect(
      const AsyncLoading<int>().value,
      null,
    );
    expect(
      () => const AsyncError<int>('err', StackTrace.empty).value,
      throwsA('err'),
    );

    expect(
      const AsyncError<int>('err', StackTrace.empty)
          .copyWithPrevious(const AsyncData(42))
          .value,
      42,
    );
    expect(
      const AsyncLoading<int>().copyWithPrevious(const AsyncData(42)).value,
      42,
    );
  });

  test('AsyncValue.valueOrNull', () {
    expect(const AsyncValue.data(42).valueOrNull, 42);
    expect(
      const AsyncLoading<int>().valueOrNull,
      null,
    );
    expect(const AsyncError<int>('err', StackTrace.empty).valueOrNull, null);

    expect(
      const AsyncError<int>('err', StackTrace.empty)
          .copyWithPrevious(const AsyncData(42))
          .valueOrNull,
      42,
    );
    expect(
      const AsyncLoading<int>()
          .copyWithPrevious(const AsyncData(42))
          .valueOrNull,
      42,
    );
  });

  test('AsyncValue.guard emits the data when the created future completes',
      () async {
    await expectLater(
      AsyncValue.guard(() => Future.value(42)),
      completion(const AsyncValue.data(42)),
    );
  });

  test('AsyncValue.guard emits the error when the created future fails',
      () async {
    final stack = StackTrace.current;

    await expectLater(
      AsyncValue.guard(() => Future<int>.error(42, stack)),
      completion(AsyncError<int>(42, stack)),
    );
  });
}

class CustomLoading<T> extends AsyncLoading<T> {
  const CustomLoading();
}

class CustomData<T> extends AsyncData<T> {
  const CustomData(super.value);
}

class CustomError<T> extends AsyncError<T> {
  const CustomError(Object error, {required StackTrace stackTrace})
      : super(
          error,
          stackTrace,
        );
}
