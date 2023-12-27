// ignore_for_file: omit_local_variable_types, unused_local_variable, prefer_final_locals

import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../first_request/raw/activity.dart';

/* SNIPPET START */
// 我们定义一条记录，表示我们想要传递给提供者程序的参数。
// 创建 typedef 是可选的，但可以使代码更具可读性。
typedef ActivityParameters = ({String type, int maxPrice});

final activityProvider = FutureProvider.autoDispose
    // 我们现在使用新定义的记录作为参数类型。
    .family<Activity, ActivityParameters>((ref, arguments) async {
  final response = await http.get(
    Uri(
      scheme: 'https',
      host: 'boredapi.com',
      path: '/api/activity',
      queryParameters: {
        // 最后，我们可以使用参数来更新请求的查询参数。
        'type': arguments.type,
        'price': arguments.maxPrice,
      },
    ),
  );
  final json = jsonDecode(response.body) as Map<String, dynamic>;
  return Activity.fromJson(json);
});
