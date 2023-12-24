import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../detail_screen/codegen.dart';

part 'codegen.g.dart';

/* SNIPPET START */
@riverpod
Future<Activity> activity(ActivityRef ref) async {
  // 我们使用 package:http 创建一个 HTTP 客户端
  final client = http.Client();
  // 处置时，我们会关闭客户端。
  // 这将取消客户端可能有的任何待处理请求。
  ref.onDispose(client.close);

  // 现在，我们使用客户端提出请求，而不是使用 "get "函数。
  final response = await client.get(
    Uri.https('www.boredapi.com', '/api/activity'),
  );

  // 其余代码与之前的相同
  final json = jsonDecode(response.body) as Map;
  return Activity.fromJson(Map.from(json));
}
/* SNIPPET END */
