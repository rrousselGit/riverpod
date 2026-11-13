// GENERATED from packages/riverpod_sqflite/README.md by scripts/snippets.sh.
// Do not modify by hand: edit the snippet instead.

import 'package:riverpod_sqflite/riverpod_sqflite.dart';
import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/experimental/persist.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Todo {
  Todo.fromJson(Map<String, Object?> json);
}

final storageProvider = FutureProvider<JsonSqFliteStorage>((ref) async {
  // Initialize SQFlite. We should share the Storage instance between providers.
  return JsonSqFliteStorage.open(join(await getDatabasesPath(), 'riverpod.db'));
});
