// ignore_for_file: omit_local_variable_types, unused_local_variable, prefer_final_locals

import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../first_request/raw/activity.dart';

/* SNIPPET START */

// provider에게 전달할 매개변수를 나타내는 record를 정의합니다.
// typedef는 선택 사항이지만 코드를 더 읽기 쉽게 만들 수 있습니다.

typedef ActivityParameters = ({String type, int maxPrice});

final activityProvider = FutureProvider.autoDispose
    // 이제 새로 정의된 record를 인수 유형으로 사용합니다.
    .family<Activity, ActivityParameters>((ref, arguments) async {
  final response = await http.get(
    Uri(
      scheme: 'https',
      host: 'boredapi.com',
      path: '/api/activity',
      queryParameters: {
        // 마지막으로 인수를 사용하여 쿼리 매개변수를 업데이트할 수 있습니다.
        'type': arguments.type,
        'price': arguments.maxPrice,
      },
    ),
  );
  final json = jsonDecode(response.body) as Map<String, dynamic>;
  return Activity.fromJson(json);
});
