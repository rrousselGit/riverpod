import 'dart:async';

import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

void main() {
  test(
    'StreamProvider releases old dependency listeners after rebuilding',
    () async {
      var listeners = 0;
      var revision = 0;
      final trigger = Provider((ref) => revision);
      final dependency = Provider((ref) {
        ref.onAddListener(() => listeners++);
        ref.onRemoveListener(() => listeners--);
        return 42;
      });
      final provider = StreamProvider.autoDispose((ref) {
        ref.watch(trigger);
        final value = ref.watch(dependency);
        final controller = StreamController<int>()..add(value);
        ref.onDispose(controller.close);
        return controller.stream;
      });
      final container = ProviderContainer.test();
      final subscription = container.listen(provider, (_, _) {});

      expect(await container.read(provider.future), 42);
      await container.pump();
      expect(listeners, 1);

      revision++;
      container.invalidate(trigger);
      expect(await container.read(provider.future), 42);
      await container.pump();
      expect(listeners, 1);

      subscription.close();
      await container.pump();
      expect(listeners, 0);
    },
  );

  for (final throwsDuringBuild in [false, true]) {
    test(
      'releases old listeners after ${throwsDuringBuild ? 'a build exception' : 'a stream error'}',
      () async {
        var listeners = 0;
        var revision = 0;
        final error = StateError('failed');
        final trigger = Provider((ref) => revision);
        final dependency = Provider((ref) {
          ref.onAddListener(() => listeners++);
          ref.onRemoveListener(() => listeners--);
          return 42;
        });
        final provider = StreamProvider.autoDispose<int>((ref) {
          final revision = ref.watch(trigger);
          final value = ref.watch(dependency);
          if (revision != 0 && throwsDuringBuild) throw error;

          final controller = StreamController<int>();
          ref.onDispose(controller.close);
          if (revision == 0) {
            controller.add(value);
          } else {
            // Emit an error without closing the stream.
            controller.addError(error);
          }
          return controller.stream;
        });
        final container = ProviderContainer.test(retry: (_, _) => null);
        final subscription = container.listen(provider, (_, _) {});

        expect(await container.read(provider.future), 42);
        expect(listeners, 1);

        revision++;
        container.invalidate(trigger);
        await expectLater(
          container.read(provider.future),
          throwsA(same(error)),
        );
        await container.pump();
        expect(container.read(provider).isLoading, false);
        expect(container.read(provider).error, same(error));
        expect(listeners, 1);

        subscription.close();
        await container.pump();
        expect(listeners, 0);
      },
    );
  }

  test('a pending stream retains old listeners until disposal', () async {
    var listeners = 0;
    var revision = 0;
    var disposals = 0;
    final trigger = Provider((ref) => revision);
    final dependency = Provider((ref) {
      ref.onAddListener(() => listeners++);
      ref.onRemoveListener(() => listeners--);
    });
    final provider = StreamProvider.autoDispose<int>((ref) {
      ref.watch(trigger);
      ref.watch(dependency);
      final controller = StreamController<int>();
      ref.onDispose(() {
        disposals++;
        controller.close();
      });
      return controller.stream; // Never emits or closes while subscribed.
    });
    final container = ProviderContainer.test();
    final subscription = container.listen(provider, (_, _) {});
    expect(listeners, 1);

    revision++;
    container.invalidate(trigger);
    await container.pump();
    expect(disposals, 1);
    expect(container.read(provider).isLoading, true);
    expect(listeners, 2); // The replacement build has not finished loading.

    subscription.close();
    await container.pump();
    expect(disposals, 2);
    expect(listeners, 0);
  });

  test('an empty stream releases old listeners when it closes', () async {
    var listeners = 0;
    var revision = 0;
    late Future<void> streamClosed;
    final trigger = Provider((ref) => revision);
    final dependency = Provider((ref) {
      ref.onAddListener(() => listeners++);
      ref.onRemoveListener(() => listeners--);
    });
    final provider = StreamProvider.autoDispose<int>((ref) {
      ref.watch(trigger);
      ref.watch(dependency);
      final controller = StreamController<int>();
      ref.onDispose(controller.close);
      streamClosed = controller.close();
      return controller.stream;
    });
    final container = ProviderContainer.test();
    final subscription = container.listen(provider, (_, _) {});
    await streamClosed;
    expect(listeners, 1);

    revision++;
    container.invalidate(trigger);
    await container.pump();
    await streamClosed; // Wait for done delivery, since there is no data event.
    expect(listeners, 1);

    subscription.close();
    await container.pump();
    expect(listeners, 0);
  });
}
