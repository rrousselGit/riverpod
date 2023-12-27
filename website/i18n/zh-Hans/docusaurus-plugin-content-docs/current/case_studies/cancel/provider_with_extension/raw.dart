import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../detail_screen/codegen.dart';
import '../extension.dart';

/* SNIPPET START */
final activityProvider = FutureProvider.autoDispose<Activity>((ref) async {
  // 我们使用之前创建的扩展来获取 HTTP 客户端。
  final client = await ref.getDebouncedHttpClient();

  // 现在，我们使用客户端而不是 "get "函数来发出请求。
  // 如果用户离开页面，我们的请求自然会被取消。
  final response = await client.get(
    Uri.https('www.boredapi.com', '/api/activity'),
  );

  final json = jsonDecode(response.body) as Map;
  return Activity.fromJson(Map.from(json));
});
/* SNIPPET END */
