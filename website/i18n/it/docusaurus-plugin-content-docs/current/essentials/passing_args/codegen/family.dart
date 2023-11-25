import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../first_request/codegen/activity.dart';

part 'family.g.dart';

/* SNIPPET START */
@riverpod
Future<Activity> activity(
  ActivityRef ref,
  // We can add arguments to the provider.
  // The type of the parameter can be whatever you wish.
  String activityType,
) async {
  // We can use the "activityType" argument to build the URL.
  // This will point to "https://boredapi.com/api/activity?type=<activityType>"
  final response = await http.get(
    Uri(
      scheme: 'https',
      host: 'boredapi.com',
      path: '/api/activity',
      // No need to manually encode the query parameters, the "Uri" class does it for us.
      queryParameters: {'type': activityType},
    ),
  );
  final json = jsonDecode(response.body) as Map<String, dynamic>;
  return Activity.fromJson(json);
}
