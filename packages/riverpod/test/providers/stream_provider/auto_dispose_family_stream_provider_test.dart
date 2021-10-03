import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

import '../../utils.dart';

void main() {
  group('StreamProvider.autoDispose.family', () {
    group('scoping an override overrides all the associated subproviders', () {
      test('when passing the provider itself', () async {
        final provider = StreamProvider.autoDispose
            .family<int, int>((ref, _) => Stream.value(0));
        final root = createContainer();
        final container = createContainer(parent: root, overrides: [provider]);

        expect(await container.read(provider(0).stream).first, 0);
        expect(await container.read(provider(0).last), 0);
        expect(container.read(provider(0)), const AsyncData(0));
        expect(root.getAllProviderElements(), isEmpty);
        expect(
          container.getAllProviderElements(),
          unorderedEquals(<Object?>[
            isA<ProviderElementBase>()
                .having((e) => e.origin, 'origin', provider(0)),
            isA<ProviderElementBase>()
                .having((e) => e.origin, 'origin', provider(0).last),
            isA<ProviderElementBase>()
                .having((e) => e.origin, 'origin', provider(0).stream),
          ]),
        );
      });

      test('when using provider.overrideWithProvider', () async {
        final provider = StreamProvider.autoDispose
            .family<int, int>((ref, _) => Stream.value(0));
        final root = createContainer();
        final container = createContainer(parent: root, overrides: [
          provider.overrideWithProvider(
            (value) => StreamProvider.autoDispose((ref) => Stream.value(42)),
          ),
        ]);

        expect(await container.read(provider(0).stream).first, 42);
        expect(await container.read(provider(0).last), 42);
        expect(container.read(provider(0)), const AsyncData(42));
        expect(root.getAllProviderElements(), isEmpty);
        expect(
          container.getAllProviderElements(),
          unorderedEquals(<Object?>[
            isA<ProviderElementBase>()
                .having((e) => e.origin, 'origin', provider(0)),
            isA<ProviderElementBase>()
                .having((e) => e.origin, 'origin', provider(0).last),
            isA<ProviderElementBase>()
                .having((e) => e.origin, 'origin', provider(0).stream),
          ]),
        );
      });
    });

    test('override', () async {
      final provider = StreamProvider.autoDispose.family<int, int>((ref, a) {
        return Stream.value(a * 2);
      });
      final container = createContainer();
      final listener = Listener<AsyncValue<int>>();

      container.listen(provider(21), listener, fireImmediately: true);

      verifyOnly(listener, listener(const AsyncValue.loading()));

      await container.pump();

      verifyOnly(listener, listener(const AsyncValue.data(42)));
    });

    test('override', () async {
      final provider = StreamProvider.autoDispose.family<int, int>((ref, a) {
        return Stream.value(a * 2);
      });
      final container = ProviderContainer(overrides: [
        provider.overrideWithProvider((a) {
          return StreamProvider.autoDispose((ref) => Stream.value(a * 4));
        }),
      ]);
      final listener = Listener<AsyncValue<int>>();

      container.listen(provider(21), listener, fireImmediately: true);

      verifyOnly(listener, listener(const AsyncValue.loading()));

      await container.pump();

      verifyOnly(listener, listener(const AsyncValue.data(84)));
    });
  });
}
