// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'codegen.g.dart';

final otherProvider = Provider<int>((ref) => 0);

const someStream = Stream<({double longitude, double latitude})>.empty();

/* SNIPPET START */
@riverpod
Stream<({double longitude, double latitude})> location(LocationRef ref) {
  // TO-DO: 返回获取当前位置的流
  return someStream;
}

@riverpod
Future<List<String>> restaurantsNearMe(RestaurantsNearMeRef ref) async {
  // 我们使用 "ref.watch" 来获取最新位置。
  // 通过在提供者程序之后指定 ".future"，
  // 我们的代码将在等待到至少一个位置信息后可用。
  final location = await ref.watch(locationProvider.future);

  // 我们现在可以根据该位置发出网络请求。
  // 例如，我们可以使用 Google Map API：
  // https://developers.google.com/maps/documentation/places/web-service/search-nearby
  final response = await http.get(
    Uri.https('maps.googleapis.com', 'maps/api/place/nearbysearch/json', {
      'location': '${location.latitude},${location.longitude}',
      'radius': '1500',
      'type': 'restaurant',
      'key': '<your api key>',
    }),
  );
  // 从 JSON 中获取餐厅名称
  final json = jsonDecode(response.body) as Map;
  final results = (json['results'] as List).cast<Map<Object?, Object?>>();
  return results.map((e) => e['name']! as String).toList();
}
/* SNIPPET END */
