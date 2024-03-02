import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'models.dart';

final dio = Dio();

/* SNIPPET START */

// The current search filter
final searchProvider = StateProvider((ref) => '');

/// Configurations which can change over time
final configsProvider = StreamProvider<Configuration>(
  (ref) => Stream.value(Configuration()),
);

final charactersProvider = FutureProvider<List<Character>>((ref) async {
  final search = ref.watch(searchProvider);
  final configs = await ref.watch(configsProvider.future);
  final response = await dio.get<List<Map<String, dynamic>>>(
      '${configs.host}/characters?search=$search');

  return response.data!.map(Character.fromJson).toList();
});
