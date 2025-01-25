import 'package:riverpod/persist.dart';
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

  late JsonSqFlitePersist persist;
  setUp(() async {
    persist = await JsonSqFlitePersist.open(inMemoryDatabasePath);
    addTearDown(persist.close);
  });

  group('JsonSqFlitePersist', () {
    test('Clears expired keys on creation', () async {
      return fakeAsync((async) async {
        await persist.write('expired', 'value', const PersistOptions());
        await persist.write(
          'maintained',
          'value',
          const PersistOptions(cacheTime: PersistCacheTime(Duration(days: 3))),
        );

        async.elapse(const Duration(days: 3));

        final persist2 = await JsonSqFlitePersist.open(inMemoryDatabasePath);
        addTearDown(persist2.close);

        final result = await persist.db.query(persist.tableName);
        expect(result, hasLength(1));
        expect(result.single, containsPair('key', 'maintained'));
      });
    });

    test('returns null on unknown keys', () async {
      await expectLater(
        persist.read('key', const PersistOptions()),
        completion(null),
      );
    });

    test('returns the value if it exists', () async {
      await persist.write('key', 'value', const PersistOptions());

      await expectLater(
        persist.read('key', const PersistOptions()),
        completion(('value',)),
      );
    });

    test('returns null after a delete', () async {
      await persist.write('key', 'value', const PersistOptions());
      await persist.delete('key', const PersistOptions());

      await expectLater(
        persist.read('key', const PersistOptions()),
        completion(null),
      );
    });

    test('returns null if the destroyKey changed', () async {
      await persist.write(
        'key',
        'value',
        const PersistOptions(destroyKey: 'a'),
      );

      await expectLater(
        persist.read('key', const PersistOptions(destroyKey: 'b')),
        completion(null),
      );
    });

    test('returns null if the cache time expired', () async {
      return fakeAsync((async) async {
        await persist.write('key', 'value', const PersistOptions());

        async.elapse(const Duration(hours: 47));

        await expectLater(
          persist.read('key', const PersistOptions()),
          completion(('value',)),
        );

        async.elapse(const Duration(hours: 2));

        await expectLater(
          persist.read('key', const PersistOptions()),
          completion(null),
        );
      });
    });

    test('handles "forever" cacheTime', () async {
      return fakeAsync((async) async {
        await persist.write(
          'key',
          'value',
          const PersistOptions(cacheTime: PersistCacheTime.unsafe_forever),
        );

        async.elapse(const Duration(days: 365 * 10));

        await expectLater(
          persist.read('key', const PersistOptions()),
          completion(('value',)),
        );
      });
    });
  });
}
