import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../first_request/codegen/activity.dart';

part 'family.g.dart';

/* SNIPPET START */
@riverpod
Future<Activity> activity(
  Ref ref,
  // 我們可以向提供者程式新增引數。
  // 引數的型別可以是您想要的任何型別。
  String activityType,
) async {
  // 我們可以使用“activityType”引數來構建 URL。
  // 這將指向 "https://boredapi.com/api/activity?type=<activityType>"
  final response = await http.get(
    Uri(
      scheme: 'https',
      host: 'boredapi.com',
      path: '/api/activity',
      // 無需手動編碼查詢引數，“Uri”類為我們完成了這一工作。
      queryParameters: {'type': activityType},
    ),
  );
  final json = jsonDecode(response.body) as Map<String, dynamic>;
  return Activity.fromJson(json);
}
