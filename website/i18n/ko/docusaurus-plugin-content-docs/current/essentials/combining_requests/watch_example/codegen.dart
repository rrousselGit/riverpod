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
  // TO-DO: 현재 위치를 가져오는 Stream을 반환합니다.
  return someStream;
}

@riverpod
Future<List<String>> restaurantsNearMe(RestaurantsNearMeRef ref) async {
  // "ref.watch"를 사용하여 최신 위치를 가져옵니다.
  // 공급자 뒤에 ".future"를 지정하면 코드가 적어도 하나의 위치를 사용할 수 있을 때까지 기다립니다.
  final location = await ref.watch(locationProvider.future);

  // 이제 해당 위치를 기반으로 네트워크 요청을 할 수 있습니다.
  // 예를 들어 Google 지도 API를 사용할 수 있습니다:
  // https://developers.google.com/maps/documentation/places/web-service/search-nearby
  final response = await http.get(
    Uri.https('maps.googleapis.com', 'maps/api/place/nearbysearch/json', {
      'location': '${location.latitude},${location.longitude}',
      'radius': '1500',
      'type': 'restaurant',
      'key': '<your api key>',
    }),
  );
  // JSON에서 레스토랑 이름 가져오기
  final json = jsonDecode(response.body) as Map;
  final results = (json['results'] as List).cast<Map<Object?, Object?>>();
  return results.map((e) => e['name']! as String).toList();
}
/* SNIPPET END */
