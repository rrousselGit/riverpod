import 'package:riverpod/src/_internals.dart';
import 'package:test/test.dart';

void main() {
  test('exports the internals that the other packages build on', () {
    expect(<Type>[
      ProviderContainer,
      ProviderElement,
      Provider,
      FutureProvider,
      StreamProvider,
      NotifierProvider,
      AsyncNotifierProvider,
      StreamNotifierProvider,
    ], hasLength(8));
  });
}
