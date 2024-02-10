import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../first_request/codegen/activity.dart';

part 'family.g.dart';

/* SNIPPET START */
@riverpod
Future<Activity> activity(
  ActivityRef ref,
  // 我们可以向提供者程序添加参数。
  // 参数的类型可以是您想要的任何类型。
  String activityType,
) async {
  // 我们可以使用“activityType”参数来构建 URL。
  // 这将指向 "https://boredapi.com/api/activity?type=<activityType>"
  final response = await http.get(
    Uri(
      scheme: 'https',
      host: 'boredapi.com',
      path: '/api/activity',
      // 无需手动编码查询参数，“Uri”类为我们完成了这一工作。
      queryParameters: {'type': activityType},
    ),
  );
  final json = jsonDecode(response.body) as Map<String, dynamic>;
  return Activity.fromJson(json);
}
