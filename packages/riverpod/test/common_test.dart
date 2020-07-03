import 'dart:async';

import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

void main() {
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
      AsyncValue<int>.error(21).whenData((value) => '$value'),
      isA<AsyncError<String>>().having((s) => s.error, 'error', 21),
    );
  });
  test('AsyncValue.data', () {
    expect(
      const AsyncValue.data(42).data,
      isA<AsyncData<int>>().having((s) => s.value, 'value', 42),
    );
    expect(const AsyncValue<void>.loading().data, isNull);
    expect(AsyncValue<void>.error(Error()).data, isNull);
  });
  test('AsyncValue.data handles null', () {
    expect(
      const AsyncValue<int>.data(null).data,
      isA<AsyncData<int>>().having((s) => s.value, 'value', null),
    );
  });
  test('AsyncValue.error does now allow null', () {
    expect(
      () => AsyncValue<void>.error(null),
      throwsA(isA<AssertionError>()),
    );
  });
}
