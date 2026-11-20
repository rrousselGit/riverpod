// GENERATED from packages/riverpod/lib/src/core/async_value.dart by scripts/snippets.sh.
// Do not modify by hand: edit the snippet instead.

import 'package:riverpod/riverpod.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'
    show ConsumerWidget, WidgetRef;
import 'package:material_ui/material_ui.dart';

class User {
  String get name => '';
}

class MyData {
  MyData();
  factory MyData.fromJson(Object? json) => MyData();
}

final dio = Dio();
late Ref ref;
late Object error;
Future<void> something() async {}
final provider = FutureProvider<int>((ref) async => 0);
final someProvider = FutureProvider<int>((ref) async => 0);
final anotherProvider = FutureProvider<int>((ref) async => 0);

class MyNotifier extends AsyncNotifier<MyData> {
  @override
  Future<MyData> build() async {
    state = AsyncLoading(progress: 0);
    await something();
    state = AsyncLoading(progress: 1);

    return MyData();
  }
}
