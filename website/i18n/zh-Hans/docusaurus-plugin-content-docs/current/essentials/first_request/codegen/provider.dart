/* SNIPPET START */ import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'activity.dart';

// 代码生成正常工作的必要条件
part 'provider.g.dart';

/// 这将创建一个名为 `activityProvider` 的提供者程序
/// 它可以缓存函数执行的结果
@riverpod
Future<Activity> activity(ActivityRef ref) async {
  // 使用 package:http, 我们可以从 Bored API 获取一个随机的活动。
  final response = await http.get(Uri.https('boredapi.com', '/api/activity'));
  // 使用 dart:convert, 然后我们将 JSON 有效负载解码为 Map 数据结构。
  final json = jsonDecode(response.body) as Map<String, dynamic>;
  // 最后，我们将 Map 转换为 Activity 实例。
  return Activity.fromJson(json);
}
