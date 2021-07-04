import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

import '../../utils.dart';

void main() {
  group('StreamProvider.autoDispose', () {
    group('scoping an override overrides all the associated subproviders', () {
      test('when passing the provider itself', () async {
        final provider = StreamProvider.autoDispose((ref) => Stream.value(0));
        final root = createContainer();
        final container = createContainer(parent: root, overrides: [provider]);

        expect(await container.read(provider.stream).first, 0);
        expect(await container.read(provider.last), 0);
        expect(container.read(provider), const AsyncValue.data(0));
        expect(root.getAllProviderElements(), isEmpty);
        expect(
          container.getAllProviderElements(),
          unorderedEquals(<Object?>[
            isA<ProviderElementBase>()
                .having((e) => e.origin, 'origin', provider),
            isA<ProviderElementBase>()
                .having((e) => e.origin, 'origin', provider.last),
            isA<ProviderElementBase>()
                .having((e) => e.origin, 'origin', provider.stream),
          ]),
        );
      });

      test('when using provider.overrideWithValue', () async {
        final provider = StreamProvider.autoDispose((ref) => Stream.value(0));
        final root = createContainer();
        final container = createContainer(parent: root, overrides: [
          provider.overrideWithValue(const AsyncValue.data(42)),
        ]);

        expect(await container.read(provider.stream).first, 42);
        expect(await container.read(provider.last), 42);
        expect(container.read(provider), const AsyncValue.data(42));
        expect(root.getAllProviderElements(), isEmpty);
        expect(
          container.getAllProviderElements(),
          unorderedEquals(<Object?>[
            isA<ProviderElementBase>()
                .having((e) => e.origin, 'origin', provider),
            isA<ProviderElementBase>()
                .having((e) => e.origin, 'origin', provider.last),
            isA<ProviderElementBase>()
                .having((e) => e.origin, 'origin', provider.stream),
          ]),
        );
      });

      test('when using provider.overrideWithProvider', () async {
        final provider = StreamProvider.autoDispose((ref) => Stream.value(0));
        final root = createContainer();
        final container = createContainer(parent: root, overrides: [
          provider.overrideWithProvider(
            FutureProvider.autoDispose((ref) async => 42),
          ),
        ]);

        expect(await container.read(provider.stream).first, 42);
        expect(await container.read(provider.last), 42);
        expect(container.read(provider), const AsyncValue.data(42));
        expect(root.getAllProviderElements(), isEmpty);
        expect(
          container.getAllProviderElements(),
          unorderedEquals(<Object?>[
            isA<ProviderElementBase>()
                .having((e) => e.origin, 'origin', provider),
            isA<ProviderElementBase>()
                .having((e) => e.origin, 'origin', provider.last),
            isA<ProviderElementBase>()
                .having((e) => e.origin, 'origin', provider.stream),
          ]),
        );
      });
    });

    test('works', () async {
      var stream = Stream.value(42);
      final onDispose = OnDisposeMock();
      final provider = StreamProvider.autoDispose((ref) {
        ref.onDispose(onDispose);
        return stream;
      });
      final container = createContainer();
      final listener = Listener<AsyncValue<int>>();

      final sub = container.listen(provider, listener, fireImmediately: true);

      verifyOnly(listener, listener(const AsyncValue.loading()));

      sub.close();

      await container.pump();

      verifyOnly(onDispose, onDispose());

      stream = Stream.value(21);

      container.listen(
        provider,
        listener,
        fireImmediately: true,
      );

      verifyOnly(listener, listener(const AsyncValue.loading()));

      await container.pump();

      verifyOnly(listener, listener(const AsyncValue.data(21)));
    });
  });
}
