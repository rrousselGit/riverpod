import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../../first_request/raw/activity.dart';

/* SNIPPET START */

final activityProvider = FutureProvider.autoDispose((ref) async {
  final response = await http.get(Uri.https('boredapi.com', '/api/activity'));
  final json = jsonDecode(response.body) as Map<String, dynamic>;
  return Activity.fromJson(json);
});
