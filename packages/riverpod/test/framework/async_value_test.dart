// ignore_for_file: deprecated_member_use_from_same_package, avoid_types_on_closure_parameters

import 'dart:async';

import 'package:riverpod/riverpod.dart';
import 'package:riverpod/src/internals.dart';
import 'package:test/test.dart';

void main() {
  group('custom AsyncValue', () {
    test('supports when', () {
      expect(
        CustomData(42).whenOrNull(data: (v) => v * 2),
        84,
      );

      expect(
        CustomError<int>(42).whenOrNull(data: (v) => v * 2),
        null,
      );

      expect(
        const CustomLoading<int>().whenOrNull(data: (v) => v * 2),
        null,
      );
    });
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
      AsyncValue<int>.error(42, stack).map(
        data: (value) => throw Error(),
        error: (AsyncError<int> error) => [error.error, error.stackTrace],
        loading: (_) => throw Error(),
      ),
      [42, stack],
    );

    expect(
      const AsyncValue<int>.loading(
        previous: AsyncData(42),
      ).map(
        data: (value) => throw Error(),
        error: (_) => throw Error(),
        loading: (AsyncLoading<int> loading) =>
            'loading ${loading.previous?.value}',
      ),
      'loading 42',
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
        AsyncValue<int>.error(42, stack).maybeMap(
          error: (AsyncError<int> error) => [error.error, error.stackTrace],
          orElse: () => throw Error(),
        ),
        [42, stack],
      );

      expect(
        const AsyncValue<int>.loading(
          previous: AsyncData(42),
        ).maybeMap(
          loading: (AsyncLoading<int> loading) =>
              'loading ${loading.previous?.value}',
          orElse: () => throw Error(),
        ),
        'loading 42',
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
        AsyncValue<int>.error(42, stack).maybeMap(
          data: (value) => throw Error(),
          loading: (_) => throw Error(),
          orElse: () => 'orElse',
        ),
        'orElse',
      );

      expect(
        const AsyncValue<int>.loading().maybeMap(
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
        AsyncValue<int>.error(42, stack).mapOrNull(
          error: (AsyncError<int> error) => [error.error, error.stackTrace],
        ),
        [42, stack],
      );

      expect(
        const AsyncValue<int>.loading(
          previous: AsyncData(42),
        ).mapOrNull(
          loading: (AsyncLoading<int> loading) =>
              'loading ${loading.previous?.value}',
        ),
        'loading 42',
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
        AsyncValue<int>.error(42, stack).mapOrNull(
          data: (value) => throw Error(),
          loading: (_) => throw Error(),
        ),
        null,
      );

      expect(
        const AsyncValue<int>.loading().mapOrNull(
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
        loading: (_) => throw Error(),
      ),
      [42],
    );

    final stack = StackTrace.current;

    expect(
      AsyncValue<int>.error(42, stack).when(
        data: (value) => throw Error(),
        error: (a, b) => [a, b],
        loading: (_) => throw Error(),
      ),
      [42, stack],
    );

    expect(
      const AsyncValue<int>.loading(
        previous: AsyncData(42),
      ).when(
        data: (value) => throw Error(),
        error: (a, b) => throw Error(),
        loading: (previous) => 'loading ${previous?.value}',
      ),
      'loading 42',
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
        AsyncValue<int>.error(42, stack).maybeWhen(
          error: (a, b) => [a, b],
          orElse: () => throw Error(),
        ),
        [42, stack],
      );

      expect(
        const AsyncValue<int>.loading(
          previous: AsyncData(42),
        ).maybeWhen(
          loading: (previous) => 'loading ${previous?.value}',
          orElse: () => throw Error(),
        ),
        'loading 42',
      );
    });

    test('orElse', () {
      expect(
        const AsyncValue.data(42).maybeWhen(
          error: (a, b) => throw Error(),
          loading: (_) => throw Error(),
          orElse: () => 'orElse',
        ),
        'orElse',
      );

      final stack = StackTrace.current;

      expect(
        AsyncValue<int>.error(42, stack).maybeWhen(
          data: (value) => throw Error(),
          loading: (_) => throw Error(),
          orElse: () => 'orElse',
        ),
        'orElse',
      );

      expect(
        const AsyncValue<int>.loading().maybeWhen(
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
        AsyncValue<int>.error(42, stack).whenOrNull(
          error: (a, b) => [a, b],
        ),
        [42, stack],
      );

      expect(
        const AsyncValue<int>.loading(
          previous: AsyncData(42),
        ).whenOrNull(
          loading: (previous) => 'loading ${previous?.value}',
        ),
        'loading 42',
      );
    });

    test('orElse', () {
      expect(
        const AsyncValue.data(42).whenOrNull(
          error: (a, b) => throw Error(),
          loading: (_) => throw Error(),
        ),
        null,
      );

      final stack = StackTrace.current;

      expect(
        AsyncValue<int>.error(42, stack).whenOrNull(
          data: (value) => throw Error(),
          loading: (_) => throw Error(),
        ),
        null,
      );

      expect(
        const AsyncValue<int>.loading().whenOrNull(
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
      AsyncValue<int>.data(value),
      AsyncValue<int>.data(value),
    );
    expect(
      AsyncValue<int>.data(value),
      isNot(AsyncValue<int>.data(value2)),
    );
    expect(
      AsyncValue<int>.data(value),
      isNot(AsyncValue<num>.data(value)),
    );
    expect(
      AsyncValue<num>.data(value),
      isNot(AsyncValue<int>.data(value)),
    );

    expect(
      AsyncValue<int>.error(value, stack),
      AsyncValue<int>.error(value, stack),
    );
    expect(
      AsyncValue<int>.error(value, stack),
      isNot(AsyncValue<num>.error(value, stack)),
    );
    expect(
      AsyncValue<num>.error(value, stack),
      isNot(AsyncValue<int>.error(value, stack)),
    );
    expect(
      AsyncValue<int>.error(value, stack),
      isNot(AsyncValue<int>.error(value, stack2)),
    );
    expect(
      AsyncValue<int>.error(value, stack),
      isNot(AsyncValue<int>.error(value2, stack)),
    );

    expect(
      // ignore: prefer_const_constructors
      AsyncValue<int>.loading(),
      // ignore: prefer_const_constructors
      AsyncValue<int>.loading(),
    );
    expect(
      // ignore: prefer_const_constructors
      AsyncValue<int>.loading(),
      // ignore: prefer_const_constructors
      isNot(AsyncValue<num>.loading()),
    );
    expect(
      // ignore: prefer_const_constructors
      AsyncValue<num>.loading(),
      // ignore: prefer_const_constructors
      isNot(AsyncValue<int>.loading()),
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
      AsyncValue<int>.data(value).hashCode,
      AsyncValue<int>.data(value).hashCode,
    );
    expect(
      AsyncValue<int>.data(value).hashCode,
      isNot(AsyncValue<int>.data(value2).hashCode),
    );
    expect(
      AsyncValue<int>.data(value).hashCode,
      isNot(AsyncValue<num>.data(value).hashCode),
    );
    expect(
      AsyncValue<num>.data(value).hashCode,
      isNot(AsyncValue<int>.data(value).hashCode),
    );

    expect(
      AsyncValue<int>.error(value, stack).hashCode,
      AsyncValue<int>.error(value, stack).hashCode,
    );
    expect(
      AsyncValue<int>.error(value, stack).hashCode,
      isNot(AsyncValue<num>.error(value, stack).hashCode),
    );
    expect(
      AsyncValue<num>.error(value, stack).hashCode,
      isNot(AsyncValue<int>.error(value, stack).hashCode),
    );
    expect(
      AsyncValue<int>.error(value, stack).hashCode,
      isNot(AsyncValue<int>.error(value, stack2).hashCode),
    );
    expect(
      AsyncValue<int>.error(value, stack).hashCode,
      isNot(AsyncValue<int>.error(value2, stack).hashCode),
    );

    expect(
      // ignore: prefer_const_constructors
      AsyncValue<int>.loading().hashCode,
      // ignore: prefer_const_constructors
      AsyncValue<int>.loading().hashCode,
    );
    expect(
      // ignore: prefer_const_constructors
      AsyncValue<int>.loading().hashCode,
      // ignore: prefer_const_constructors
      isNot(AsyncValue<num>.loading().hashCode),
    );
    expect(
      // ignore: prefer_const_constructors
      AsyncValue<num>.loading().hashCode,
      // ignore: prefer_const_constructors
      isNot(AsyncValue<int>.loading().hashCode),
    );
  });

  test('toString', () {
    expect(
      const AsyncValue.data(42).toString(),
      'AsyncData<int>(value: 42)',
    );

    expect(
      const AsyncValue<int>.error(42).toString(),
      'AsyncError<int>(error: 42, stackTrace: null)',
    );

    expect(
      const AsyncValue<int>.loading(previous: AsyncData(42)).toString(),
      'AsyncLoading<int>(previous: AsyncData<int>(value: 42))',
    );
  });

  group('whenData', () {
    test('transforms data if any', () {
      expect(
        const AsyncValue.data(42).whenData((value) => '$value'),
        const AsyncData<String>('42'),
      );
      expect(
        const AsyncValue<int>.loading().whenData((value) => '$value'),
        const AsyncLoading<String>(),
      );
      expect(
        const AsyncValue<int>.error(21).whenData((value) => '$value'),
        const AsyncError<String>(21),
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
    expect(
      const AsyncValue.data(42).asData,
      const AsyncData<int>(42),
    );
    expect(const AsyncValue<void>.loading().asData, isNull);
    expect(AsyncValue<void>.error(Error()).asData, isNull);
  });

  test('AsyncValue.value', () {
    expect(const AsyncValue.data(42).value, 42);
    expect(
      () => const AsyncValue<void>.loading().value,
      throwsA(isA<AsyncValueLoadingError>()),
    );

    final error = Error();
    expect(
      () => AsyncValue<void>.error(error).value,
      throwsA(error),
    );
  });

  test('AsyncValue.data handles null', () {
    expect(
      const AsyncValue<int?>.data(null).data,
      const AsyncData<int?>(null),
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
      completion(AsyncValue<int>.error(42, stack)),
    );
  });
}

class CustomLoading<T> extends AsyncLoading<T> {
  const CustomLoading();
}

class CustomData<T> extends AsyncData<T> {
  CustomData(T value) : super(value);
}

class CustomError<T> extends AsyncError<T> {
  CustomError(Object error, [StackTrace? stackTrace])
      : super(error, stackTrace);
}
