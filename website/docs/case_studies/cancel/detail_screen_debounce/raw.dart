import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../detail_screen/codegen.dart';

/* SNIPPET START */
final activityProvider = FutureProvider.autoDispose<Activity>((ref) async {
  // {@template didDispose}
  // We capture whether the provider is currently disposed or not.
  // {@endtemplate}
  var didDispose = false;
  ref.onDispose(() => didDispose = true);

  // {@template delayed}
  // We delay the request by 500ms, to wait for the user to stop refreshing.
  // {@endtemplate}
  await Future<void>.delayed(const Duration(milliseconds: 500));

  // {@template cancelled}
  // If the provider was disposed during the delay, it means that the user
  // refreshed again. We throw an exception to cancel the request.
  // It is safe to use an exception here, as it will be caught by Riverpod.
  // {@endtemplate}
  if (didDispose) {
    throw Exception('Cancelled');
  }

  // {@template http}
  // The following code is unchanged from the previous snippet
  // {@endtemplate}
  final client = http.Client();
  ref.onDispose(client.close);

  final response = await client.get(
    Uri.https('www.boredapi.com', '/api/activity'),
  );

  final json = jsonDecode(response.body) as Map;
  return Activity.fromJson(Map.from(json));
});
/* SNIPPET END */
