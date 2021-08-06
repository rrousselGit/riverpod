// ignore_for_file: deprecated_member_use_from_same_package

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
      AsyncValue<int>.error(42, stack).when(
        data: (value) => throw Error(),
        error: (a, b) => [a, b],
        loading: () => throw Error(),
      ),
      [42, stack],
    );

    expect(
      const AsyncValue<int>.loading().when(
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
        AsyncValue<int>.error(42, stack).maybeWhen(
          error: (a, b) => [a, b],
          orElse: () => throw Error(),
        ),
        [42, stack],
      );

      expect(
        const AsyncValue<int>.loading().maybeWhen(
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
        AsyncValue<int>.error(42, stack).maybeWhen(
          data: (value) => throw Error(),
          loading: () => throw Error(),
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
        const AsyncValue<int>.loading().whenOrNull(
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
        AsyncValue<int>.error(42, stack).whenOrNull(
          data: (value) => throw Error(),
          loading: () => throw Error(),
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
      const AsyncValue<int>.loading().toString(),
      'AsyncLoading<int>()',
    );
  });

  test('AsyncValue.whenData', () {
    expect(
      const AsyncValue.data(42).whenData((value) => '$value'),
      isA<AsyncData<String>>().having((s) => s.value, 'value', '42'),
    );
    expect(
      const AsyncValue<int>.loading().whenData((value) => '$value'),
      isA<AsyncLoading<String>>(),
    );
    expect(
      const AsyncValue<int>.error(21).whenData((value) => '$value'),
      isA<AsyncError<String>>().having((s) => s.error, 'error', 21),
    );
  });

  test('AsyncValue.asData', () {
    expect(
      const AsyncValue.data(42).asData,
      isA<AsyncData<int>>().having((s) => s.value, 'value', 42),
    );
    expect(const AsyncValue<void>.loading().asData, isNull);
    expect(AsyncValue<void>.error(Error()).asData, isNull);
  });

  test('AsyncValue.value', () {
    expect(const AsyncValue.data(42).value, 42);
    expect(
      () => const AsyncValue<void>.loading().value,
      throwsA(isA<AsyncValueLoadingException>()),
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
      isA<AsyncData<int?>>().having((s) => s.value, 'value', null),
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
