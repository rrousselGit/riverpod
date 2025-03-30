import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'models.dart';

part 'codegen.g.dart';

final dio = Dio();

/* SNIPPET START */

// The current search filter
final searchProvider = StateProvider((ref) => '');

@riverpod
Stream<Configuration> configs(Ref ref) {
  return Stream.value(Configuration());
}

@riverpod
Future<List<Character>> characters(Ref ref) async {
  final search = ref.watch(searchProvider);
  final configs = await ref.watch(configsProvider.future);
  final response = await dio.get<List<Map<String, dynamic>>>(
      '${configs.host}/characters?search=$search');

  return response.data!.map(Character.fromJson).toList();
}
