import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../first_request/codegen/activity.dart';

// Necessary for code-generation to work
part 'provider.g.dart';

/* SNIPPET START */
@riverpod
Future<Activity> activity(ActivityRef ref) async {
  final response = await http.get(
    Uri(scheme: 'https', host: 'boredapi.com', path: '/api/activity'),
  );
  final json = jsonDecode(response.body) as Map<String, dynamic>;
  return Activity.fromJson(json);
}
