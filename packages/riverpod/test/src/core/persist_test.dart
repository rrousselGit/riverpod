import 'package:riverpod/src/internals.dart';
import 'package:test/test.dart';

void main() {
  group('Storage.inMemory', () {
    group('InMemoryPersist', () {
      test('returns null on unknown keys', () {
        final persist = Storage<String, String>.inMemory();

        expect(persist.read('unknown'), null);
      });

      test('returns the value if it exists', () {
        final persist = Storage<String, String>.inMemory();

        persist.write('key', 'value', const StorageOptions());

        expect(
          persist.read('key'),
          isA<PersistedData<String>>().having((e) => e.data, 'data', 'value'),
        );
      });

      test('returns null after a delete', () {
        final persist = Storage<String, String>.inMemory();

        persist.write('key', 'value', const StorageOptions());
        persist.delete('key');

        expect(persist.read('key'), null);
      });
    });
  });
}
