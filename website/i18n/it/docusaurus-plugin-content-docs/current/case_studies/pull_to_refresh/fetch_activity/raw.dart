import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../activity/raw.dart';

/* SNIPPET START */
final activityProvider = FutureProvider.autoDispose<Activity>((ref) async {
  final response = await http.get(
    Uri.https('www.boredapi.com', '/api/activity'),
  );

  final json = jsonDecode(response.body) as Map;
  return Activity.fromJson(json);
});
/* SNIPPET END */
