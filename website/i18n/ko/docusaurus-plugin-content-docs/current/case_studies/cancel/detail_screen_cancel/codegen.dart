import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../detail_screen/codegen.dart';

part 'codegen.g.dart';

/* SNIPPET START */
@riverpod
Future<Activity> activity(ActivityRef ref) async {
  // package:http를 사용하여 HTTP 클라이언트를 생성합니다.
  final client = http.Client();
  // dispose 시 클라이언트를 닫습니다.
  // 그러면 클라이언트에 있을 수 있는 모든 보류 중인 요청이 취소됩니다.
  ref.onDispose(client.close);

  // 이제 "get" 함수 대신 클라이언트를 사용하여 요청을 수행합니다.
  final response = await client.get(
    Uri.https('www.boredapi.com', '/api/activity'),
  );

  // 나머지 코드는 이전과 동일합니다.
  final json = jsonDecode(response.body) as Map;
  return Activity.fromJson(Map.from(json));
}
/* SNIPPET END */
