import 'dart:async';

import 'package:clock/clock.dart';
import 'package:meta/meta.dart';
import 'package:riverpod/experimental/persist.dart';
import 'package:sqflite/sqflite.dart';

@internal
extension Db on JsonSqFliteStorage {
  String get tableName => JsonSqFliteStorage._tableName;
  Database get db => _db;
}

/// A storage that stores data in SQLite using JSON.
///
/// Only JSON serializable is supported.
/// This is generally used in combination `riverpod_annotation's` `JsonPersist`.
final class JsonSqFliteStorage extends Storage<String, String> {
  JsonSqFliteStorage._(this._db);

  static String get _tableName => 'riverpod';

  /// Opens a database at the specified [path].
  ///
  /// This will create a table named `riverpod` if it does not exist,
  /// and will delete any expired data present.
  ///
  /// [open] relies on the `clock` package to obtain the current time, for the
  /// purpose of determining if a key has expired.
  /// This enables your tests to mock the current type.
  static Future<JsonSqFliteStorage> open(String path) async {
    final db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
CREATE TABLE IF NOT EXISTS $_tableName(
  key TEXT PRIMARY KEY NOT NULL,
  json TEXT,
  expireAt INTEGER,
  destroyKey TEXT
) WITHOUT ROWID''');
      },
    );
    final instance = JsonSqFliteStorage._(db);
    await instance.deleteOutOfDate();
    return instance;
  }

  final Database _db;

  /// Closes the database.
  ///
  /// This makes the object unusable.
  Future<void> close() => _db.close();

  @override
  Future<void> deleteOutOfDate() async {
    await _db.transaction<void>((transaction) async {
      await transaction.execute('''
CREATE TABLE IF NOT EXISTS $_tableName(
  key TEXT PRIMARY KEY NOT NULL,
  json TEXT,
  expireAt INTEGER,
  destroyKey TEXT
) WITHOUT ROWID''');

      await transaction.delete(
        _tableName,
        where: 'expireAt < ?',
        whereArgs: [_currentTimestamp()],
      );
    });
  }

  @override
  Future<void> delete(String key) async {
    await _db.delete(_tableName, where: 'key = ?', whereArgs: [key]);
  }

  int _currentTimestamp() => clock.now().toUtc().millisecondsSinceEpoch;

  @override
  Future<PersistedData<String>?> read(String key) async {
    return _db.transaction((transaction) async {
      final result = await transaction.query(
        _tableName,
        where: 'key = ?',
        whereArgs: [key],
        limit: 1,
      );
      if (result.isEmpty) return null;

      return _Row.fromMap(result.single).toPersistedData();
    });
  }

  @override
  Future<void> write(String key, String value, StorageOptions options) async {
    await _db.insert(
      _tableName,
      {
        'key': key,
        'json': value,
        'expireAt': switch (options.cacheTime.duration) {
          null => null,
          final Duration duration =>
            _currentTimestamp() + duration.inMilliseconds,
        },
        if (options.destroyKey != null) 'destroyKey': options.destroyKey,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}

class _Row {
  _Row.fromMap(Map<String, Object?> map)
      : key = map['key']! as String,
        json = map['json']! as String,
        expireAt = map['expireAt'] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(map['expireAt']! as int),
        destroyKey = map['destroyKey'] as String?;

  final String key;
  final String json;
  final DateTime? expireAt;
  final String? destroyKey;

  Map<String, Object?> toMap() {
    return {
      'key': key,
      'json': json,
      if (expireAt != null) 'expireAt': expireAt?.millisecondsSinceEpoch,
      if (destroyKey != null) 'destroyKey': destroyKey,
    };
  }

  PersistedData<String> toPersistedData() {
    return PersistedData(json, destroyKey: destroyKey, expireAt: expireAt);
  }
}
