import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../detail_screen/codegen.dart';

/* SNIPPET START */
final activityProvider = FutureProvider.autoDispose<Activity>((ref) async {
  // We capture whether the provider is currently disposed or not.
  var didDispose = false;
  ref.onDispose(() => didDispose = true);

  // We delay the request by 500ms, to wait for the user to stop refreshing.
  await Future<void>.delayed(const Duration(milliseconds: 500));

  // If the provider was disposed during the delay, it means that the user
  // refreshed again. We throw an exception to cancel the request.
  // It is safe to use an exception here, as it will be caught by Riverpod.
  if (didDispose) {
    throw Exception('Cancelled');
  }

  // The following code is unchanged from the previous snippet
  final client = http.Client();
  ref.onDispose(client.close);

  final response = await client.get(
    Uri.https('www.boredapi.com', '/api/activity'),
  );

  final json = jsonDecode(response.body) as Map;
  return Activity.fromJson(Map.from(json));
});
/* SNIPPET END */
