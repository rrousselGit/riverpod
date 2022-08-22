import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:test/test.dart';

void main() {
  test(
      'Riverpod throws if keepAlive = true and cacheTime/disposeDelay are specified',
      () {
    bool keepAlive() => true;

    const Riverpod(keepAlive: true);
    // ignore: avoid_redundant_argument_values
    const Riverpod(keepAlive: false, cacheTime: 42, disposeDelay: 42);

    expect(
      () => Riverpod(keepAlive: keepAlive(), cacheTime: 42),
      throwsA(isA<AssertionError>()),
    );
    expect(
      () => Riverpod(keepAlive: keepAlive(), disposeDelay: 42),
      throwsA(isA<AssertionError>()),
    );
  });
}
