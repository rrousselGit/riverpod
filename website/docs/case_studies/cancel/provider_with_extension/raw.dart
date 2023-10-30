import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../detail_screen/codegen.dart';
import '../extension.dart';

/* SNIPPET START */
final activityProvider = FutureProvider.autoDispose<Activity>((ref) async {
  // We obtain an HTTP client using the extension we created earlier.
  final client = await ref.getDebouncedHttpClient();

  // We now use the client to make the request instead of the "get" function.
  // Our request will naturally be debounced and be cancelled if the user
  // leaves the page.
  final response = await client.get(
    Uri.https('www.boredapi.com', '/api/activity'),
  );

  final json = jsonDecode(response.body) as Map;
  return Activity.fromJson(Map.from(json));
});
/* SNIPPET END */
