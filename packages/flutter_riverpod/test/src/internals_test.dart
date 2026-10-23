import 'package:flutter_riverpod/src/internals.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('exports the internals of riverpod and flutter_riverpod', () {
    expect(<Type>[
      ProviderContainer,
      ProviderScope,
      UncontrolledProviderScope,
    ], hasLength(3));
  });
}
