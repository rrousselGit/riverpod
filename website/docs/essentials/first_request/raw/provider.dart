/* SNIPPET START */

import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'activity.dart';

final activityProvider = FutureProvider.autoDispose((ref) async {
  // {@template raw_response}
  // Using package:http, we fetch a random activity from the Bored API.
  // {@endtemplate}
  final response = await http.get(Uri.https('boredapi.com', '/api/activity'));
  // {@template raw_json}
  // Using dart:convert, we then decode the JSON payload into a Map data structure.
  // {@endtemplate}
  final json = jsonDecode(response.body) as Map<String, dynamic>;
  // {@template raw_fromJson}
  // Finally, we convert the Map into an Activity instance.
  // {@endtemplate}
  return Activity.fromJson(json);
});
