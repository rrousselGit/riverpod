import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../detail_screen/codegen.dart';

/* SNIPPET START */
final activityProvider = FutureProvider.autoDispose<Activity>((ref) async {
  // {@template client}
  // We create an HTTP client using package:http
  // {@endtemplate}
  final client = http.Client();
  // {@template onDispose}
  // On dispose, we close the client.
  // This will cancel any pending request that the client might have.
  // {@endtemplate}
  ref.onDispose(client.close);

  // {@template get}
  // We now use the client to make the request instead of the "get" function.
  // {@endtemplate}
  final response = await client.get(
    Uri.https('www.boredapi.com', '/api/activity'),
  );

  // {@template jsonDecode}
  // The rest of the code is the same as before
  // {@endtemplate}
  final json = jsonDecode(response.body) as Map;
  return Activity.fromJson(Map.from(json));
});
/* SNIPPET END */
