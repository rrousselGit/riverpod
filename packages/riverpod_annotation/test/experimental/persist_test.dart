import 'dart:async';

import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/experimental/persist.dart';
import 'package:test/test.dart';

class _Persisted extends AsyncNotifier<int> {
  _Persisted(this.storage);

  final Storage<String, int> storage;

  @override
  Future<int> build() {
    AsyncNotifierPersistX(this).persist(
      storage,
      key: 'key',
      encode: (value) => value,
      decode: (encoded) => encoded,
      emitAsLoadingState: false,
    );
    return Completer<int>().future;
  }
}

void main() {
  test('exports AsyncNotifierPersistX', () async {
    final storage = Storage<String, int>.inMemory();
    await storage.write('key', 42, const StorageOptions());
    final container = ProviderContainer.test();
    final provider = AsyncNotifierProvider<_Persisted, int>(
      () => _Persisted(storage),
    );

    expect(await container.listen(provider.future, (_, _) {}).read(), 42);
  });
}
