// ignore_for_file: unused_local_variable

import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'codegen.g.dart';

/* SNIPPET START */
@riverpod
Future<String> example(ExampleRef ref) async {
  final response = await http.get(Uri.parse('https://example.com'));
  // We keep the provider alive only after the request has successfully completed.
  // If the request failed (and threw), then when the provider stops being
  // listened, the state will be destroyed.
  ref.keepAlive();

  // We can use the `link` to restore the auto-dispose behavior with:
  // link.close();

  return response.body;
}
