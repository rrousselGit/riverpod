/* SNIPPET START */

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'activity.dart';

// {@template codegen_note}
// Necessary for code-generation to work
// {@endtemplate}
part 'provider.g.dart';

// {@template codegen_provider}
/// This will create a provider named `activityProvider`
/// which will cache the result of this function.
// {@endtemplate}
@riverpod
Future<Activity> activity(ActivityRef ref) async {
  // {@template response}
  // Using package:http, we fetch a random activity from the Bored API.
  // {@endtemplate}
  final response = await http.get(Uri.https('boredapi.com', '/api/activity'));
  // {@template json}
  // Using dart:convert, we then decode the JSON payload into a Map data structure.
  // {@endtemplate}
  final json = jsonDecode(response.body) as Map<String, dynamic>;
  // {@template fromJson}
  // Finally, we convert the Map into an Activity instance.
  // {@endtemplate}
  return Activity.fromJson(json);
}
