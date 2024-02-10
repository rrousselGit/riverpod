import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../detail_screen/codegen.dart';

part 'codegen.g.dart';

/* SNIPPET START */
@riverpod
Future<Activity> activity(ActivityRef ref) async {
  // provider가 현재 폐기(disposed)되었는지 여부를 캡처합니다.
  var didDispose = false;
  ref.onDispose(() => didDispose = true);

  // 사용자가 새로 고침(refreshing)을 중단할 때까지 기다리기 위해
  // 요청을 500밀리초 지연합니다.
  await Future<void>.delayed(const Duration(milliseconds: 500));

  // 지연 중에 provider가 폐기(disposed)되었다면 사용자가 다시 새로고침했다는 의미입니다.
  // 예외를 던져 요청을 취소합니다.
  // Riverpod에 의해 잡히므로 여기서 예외를 사용하는 것이 안전합니다.
  if (didDispose) {
    throw Exception('Cancelled');
  }

  // 다음 코드는 이전 스니펫에서 변경되지 않았습니다.
  final client = http.Client();
  ref.onDispose(client.close);

  final response = await client.get(
    Uri.https('www.boredapi.com', '/api/activity'),
  );

  final json = jsonDecode(response.body) as Map;
  return Activity.fromJson(Map.from(json));
}
/* SNIPPET END */
