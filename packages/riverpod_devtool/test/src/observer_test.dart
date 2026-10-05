import 'dart:async';

import 'package:devtools_app_shared/service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_devtool/main.dart';
import 'package:riverpod_devtool/src/vm_service.dart';

void main() {
  test('does not log VM requests cancelled after inspector disposal', () async {
    final logs = <String>[];
    await runZoned(
      () async {
        final container = ProviderContainer.test(observers: [const Observer()]);
        final response = Completer<void>();
        final inspector = FutureProvider.autoDispose((ref) async {
          final isAlive = ref.disposable();
          await response.future;
          expect(isAlive.disposed, isTrue);
          // The VM service throws this when an in-flight request's owner is gone.
          throw CancelledException();
        });
        final subscription = container.listen(inspector, (_, _) {});
        subscription.close();
        await container.pump();
        response.complete();
        await pumpEventQueue();
      },
      zoneSpecification: ZoneSpecification(
        print: (self, parent, zone, message) => logs.add(message),
      ),
    );
    expect(logs, isEmpty);
  });

  test('still logs genuine provider failures', () async {
    final logs = <String>[];
    await runZoned(
      () async {
        final container = ProviderContainer.test(observers: [const Observer()]);
        final provider = FutureProvider<void>((ref) {
          return Future<void>.error(StateError('inspection failed'));
        });
        await expectLater(container.read(provider.future), throwsStateError);
      },
      zoneSpecification: ZoneSpecification(
        print: (self, parent, zone, message) => logs.add(message),
      ),
    );
    expect(logs, [contains('inspection failed')]);
  });
}
