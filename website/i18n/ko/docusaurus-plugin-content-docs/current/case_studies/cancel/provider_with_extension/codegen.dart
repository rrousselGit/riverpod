import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../detail_screen/codegen.dart';
import '../extension.dart';

part 'codegen.g.dart';

/* SNIPPET START */
@riverpod
Future<Activity> activity(ActivityRef ref) async {
  // 앞서 만든 확장자를 사용하여 HTTP 클라이언트를 가져옵니다.
  final client = await ref.getDebouncedHttpClient();

  // 이제 "get" 함수 대신 클라이언트를 사용하여 요청을 수행합니다.
  // 사용자가 페이지를 떠나면 요청은 자연스럽게 디바운스(debounced)되고 취소(cancelled)됩니다.
  final response = await client.get(
    Uri.https('www.boredapi.com', '/api/activity'),
  );

  final json = jsonDecode(response.body) as Map;
  return Activity.fromJson(Map.from(json));
}
/* SNIPPET END */
