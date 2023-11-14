// ignore_for_file: unused_local_variable

import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

/* SNIPPET START */
final provider = FutureProvider.autoDispose<String>((ref) async {
  final response = await http.get(Uri.parse('https://example.com'));
  // We keep the provider alive only after the request has successfully completed.
  // If the request failed (and threw an exception), then when the provider stops being
  // listened to, the state will be destroyed.
  final link = ref.keepAlive();

  // We can use the `link` to restore the auto-dispose behavior with:
  // link.close();

  return response.body;
});
/* SNIPPET END */
