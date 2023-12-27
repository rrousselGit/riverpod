import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../detail_screen/codegen.dart';

/* SNIPPET START */
final activityProvider = FutureProvider.autoDispose<Activity>((ref) async {
  // 我们会捕捉提供者程序目前是否已被处置。
  var didDispose = false;
  ref.onDispose(() => didDispose = true);

  // 我们将请求延迟 500 毫秒，以等待用户停止刷新。
  await Future<void>.delayed(const Duration(milliseconds: 500));

  // 如果在延迟期间处理了提供者程序，则意味着用户再次刷新了请求。
  // 我们会抛出一个异常来取消请求。
  // 在这里使用异常是安全的，因为它会被 Riverpod 捕捉到。
  if (didDispose) {
    throw Exception('Cancelled');
  }

  // 以下代码与之前的代码片段保持不变
  final client = http.Client();
  ref.onDispose(client.close);

  final response = await client.get(
    Uri.https('www.boredapi.com', '/api/activity'),
  );

  final json = jsonDecode(response.body) as Map;
  return Activity.fromJson(Map.from(json));
});
/* SNIPPET END */
