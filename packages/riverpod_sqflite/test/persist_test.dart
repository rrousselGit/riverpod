import 'package:riverpod/experimental/persist.dart';
import 'package:riverpod_sqflite/src/riverpod_sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:test/test.dart';

import 'third_party/fake_async.dart';

/// Initialize sqflite for test.
void sqfliteTestInit() {
  // Initialize ffi implementation
  sqfliteFfiInit();
  // Set global factory
  databaseFactory = databaseFactoryFfi;
}

void main() {
  sqfliteTestInit();

  late JsonSqFliteStorage persist;
  setUp(() async {
    persist = await JsonSqFliteStorage.open(inMemoryDatabasePath);
    addTearDown(persist.close);
  });

  group('JsonSqFliteStorage', () {
    test('Clears expired keys on creation', () {
      return fakeAsync((async) async {
        await persist.write('expired', 'value', const StorageOptions());
        await persist.write(
          'maintained',
          'value',
          const StorageOptions(cacheTime: StorageCacheTime(Duration(days: 3))),
        );

        async.elapse(const Duration(days: 3));

        final persist2 = await JsonSqFliteStorage.open(inMemoryDatabasePath);
        addTearDown(persist2.close);

        final result = await persist.db.query(persist.tableName);
        expect(result, hasLength(1));
        expect(result.single, containsPair('key', 'maintained'));
      });
    });

    test('returns null on unknown keys', () async {
      await expectLater(persist.read('key'), completion(null));
    });

    test('returns the value if it exists', () async {
      await persist.write('key', 'value', const StorageOptions());

      expect(
        await persist.read('key'),
        isA<PersistedData<String>>().having((e) => e.data, 'data', 'value'),
      );
    });

    test('returns null after a delete', () async {
      await persist.write('key', 'value', const StorageOptions());
      await persist.delete('key');

      await expectLater(persist.read('key'), completion(null));
    });
  });
}
