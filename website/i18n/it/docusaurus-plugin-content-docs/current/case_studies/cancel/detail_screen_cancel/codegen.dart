import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../detail_screen/codegen.dart';

part 'codegen.g.dart';

/* SNIPPET START */
@riverpod
Future<Activity> activity(ActivityRef ref) async {
  // We create an HTTP client using package:http
  final client = http.Client();
  // On dispose, we close the client.
  // This will cancel any pending request that the client might have.
  ref.onDispose(client.close);

  // We now use the client to make the request instead of the "get" function
  final response = await client.get(
    Uri.https('www.boredapi.com', '/api/activity'),
  );

  // The rest of the code is the same as before
  final json = jsonDecode(response.body) as Map;
  return Activity.fromJson(Map.from(json));
}
/* SNIPPET END */
