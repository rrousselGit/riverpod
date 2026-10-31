import 'dart:async';

import 'package:riverpod/experimental/persist.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:test/test.dart';

import '../integration/offline.dart';

void main() {
  test('persist forwards emitAsLoadingState', () async {
    final container = ProviderContainer.test();
    final storage = await container
        .listen(storageProvider.future, (_, _) {})
        .read();
    await storage.write('EmitAsData', '{"foo": "bar"}', const StorageOptions());
    final completer = Completer<Map<String, String>>();
    addTearDown(() => completer.complete({}));
    final provider = emitAsDataProvider(completer);

    final sub = container.listen(provider.future, (_, _) {});

    expect(await sub.read(), {'foo': 'bar'});
  });

  test('persist supports sync notifiers', () async {
    final container = ProviderContainer.test();
    final storage = await container
        .listen(storageProvider.future, (_, _) {})
        .read();
    await storage.write('SyncJson', '{"foo": "bar"}', const StorageOptions());

    expect(container.read(syncJsonProvider), {'foo': 'bar'});
  });
}
