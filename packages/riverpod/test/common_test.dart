import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

void main() {
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
