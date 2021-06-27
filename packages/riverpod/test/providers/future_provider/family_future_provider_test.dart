import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

import '../../utils.dart';

void main() {
  group('scoping an override overrides all the associated subproviders', () {
    test(
      'when passing the provider itself',
      () {},
      skip: true,
    );

    test(
      'when using provider.overrideWithValue',
      () {},
      skip: true,
    );

    test(
      'when using provider.overrideWithProvider',
      () {},
      skip: true,
    );
  });

  test('FutureProvider.family override', () async {
    final provider = FutureProvider.family<String, int>((ref, a) {
      return Future.value('$a');
    });
    final container = createContainer();

    expect(container.read(provider(0)), const AsyncValue<String>.loading());

    await container.pump();

    expect(
      container.read(provider(0)),
      const AsyncValue<String>.data('0'),
    );
  });

  test('FutureProvider.family override', () async {
    final provider = FutureProvider.family<String, int>((ref, a) {
      return Future.value('$a');
    });
    final container = createContainer(overrides: [
      provider.overrideWithProvider(
        (a) => FutureProvider<String>((ref) => Future.value('override $a')),
      ),
    ]);

    expect(container.read(provider(0)), const AsyncValue<String>.loading());

    await container.pump();

    expect(
      container.read(provider(0)),
      const AsyncValue<String>.data('override 0'),
    );
  });
}
