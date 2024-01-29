/* SNIPPET START */

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'activity.dart';

// 코드 생성이 작동하는 데 필요합니다.
part 'provider.g.dart';

/// 그러면 `activityProvider`라는 이름의 provider가 생성됩니다.
/// 이 함수의 결과를 캐시하는 공급자를 생성합니다.
@riverpod
Future<Activity> activity(ActivityRef ref) async {
  // package:http를 사용하여 Bored API에서 임의의 Activity를 가져옵니다.
  final response = await http.get(Uri.https('boredapi.com', '/api/activity'));
  // 그런 다음 dart:convert를 사용하여 JSON 페이로드를 맵 데이터 구조로 디코딩합니다.
  final json = jsonDecode(response.body) as Map<String, dynamic>;
  // 마지막으로 맵을 Activity 인스턴스로 변환합니다.
  return Activity.fromJson(json);
}
