import 'dart:async';

import 'package:clock/clock.dart';
import 'package:meta/meta.dart';
// ignore: implementation_imports, using tight constraint
import 'package:riverpod/src/core/persist.dart';
import 'package:sqflite/sqflite.dart';

@internal
extension Db on JsonSqFlitePersist {
  String get tableName => JsonSqFlitePersist._tableName;
  Database get db => _db;
}

class JsonSqFlitePersist implements Persist<String, String> {
  JsonSqFlitePersist._(this._db);

  static String get _tableName => 'states';

  static Future<JsonSqFlitePersist> open(
    String path,
  ) async {
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
    final instance = JsonSqFlitePersist._(db);
    await instance._init();
    return instance;
  }

  final Database _db;

  Future<void> close() => _db.close();

  Future<void> _init() async {
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
    await _db.delete(
      _tableName,
      where: 'key = ?',
      whereArgs: [key],
    );
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
  Future<void> write(
    String key,
    String value,
    PersistOptions options,
  ) async {
    await _db.insert(
      _tableName,
      {
        'key': key,
        'json': value,
        'expireAt': switch (options.cacheTime) {
          ForeverPersistCacheTime() => null,
          DurationPersistCacheTime(:final duration) =>
            _currentTimestamp() + duration.inMilliseconds,
        },
        if (options.destroyKey != null) 'destroyKey': options.destroyKey,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}

class _Row {
  final String key;
  final String json;
  final DateTime? expireAt;
  final String? destroyKey;

  _Row.fromMap(Map<String, Object?> map)
      : key = map['key']! as String,
        json = map['json']! as String,
        expireAt = map['expireAt'] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(map['expireAt']! as int),
        destroyKey = map['destroyKey'] as String?;

  Map<String, Object?> toMap() {
    return {
      'key': key,
      'json': json,
      if (expireAt != null) 'expireAt': expireAt?.millisecondsSinceEpoch,
      if (destroyKey != null) 'destroyKey': destroyKey,
    };
  }

  PersistedData<String> toPersistedData() {
    return PersistedData(
      json,
      destroyKey: destroyKey,
      expireAt: expireAt,
    );
  }
}
