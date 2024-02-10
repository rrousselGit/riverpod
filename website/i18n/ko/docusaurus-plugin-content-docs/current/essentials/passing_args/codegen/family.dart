import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../first_request/codegen/activity.dart';

part 'family.g.dart';

/* SNIPPET START */
@riverpod
Future<Activity> activity(
  ActivityRef ref,
  // provider에 인수를 추가할 수 있습니다.
  // 매개변수 타입은 원하는 대로 지정할 수 있습니다.
  String activityType,
) async {
  // "activityType" 인수를 사용하여 URL을 작성할 수 있습니다.
  // "https://boredapi.com/api/activity?type=<activityType>"을 가리키게 됩니다.
  final response = await http.get(
    Uri(
      scheme: 'https',
      host: 'boredapi.com',
      path: '/api/activity',
      // 쿼리 매개변수를 수동으로 인코딩할 필요 없이 "Uri" 클래스가 자동으로 인코딩합니다.
      queryParameters: {'type': activityType},
    ),
  );
  final json = jsonDecode(response.body) as Map<String, dynamic>;
  return Activity.fromJson(json);
}
