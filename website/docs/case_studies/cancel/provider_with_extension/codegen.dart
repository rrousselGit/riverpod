import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../detail_screen/codegen.dart';
import '../extension.dart';

part 'codegen.g.dart';

/* SNIPPET START */
@riverpod
Future<Activity> activity(ActivityRef ref) async {
  // {@template client}
  // We obtain an HTTP client using the extension we created earlier.
  // {@endtemplate}
  final client = await ref.getDebouncedHttpClient();

  // {@template get}
  // We now use the client to make the request instead of the "get" function.
  // Our request will naturally be debounced and be cancelled if the user
  // leaves the page.
  // {@endtemplate}
  final response = await client.get(
    Uri.https('www.boredapi.com', '/api/activity'),
  );

  final json = jsonDecode(response.body) as Map;
  return Activity.fromJson(Map.from(json));
}
/* SNIPPET END */
