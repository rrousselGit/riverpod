// ignore_for_file: unused_local_variable

import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'codegen.g.dart';

/* SNIPPET START */
@riverpod
Future<String> example(ExampleRef ref) async {
  final response = await http.get(Uri.parse('https://example.com'));
  // {@template keepAlive}
  // We keep the provider alive only after the request has successfully completed.
  // If the request failed (and threw an exception), then when the provider stops being
  // listened to, the state will be destroyed.
  // {@endtemplate}
  ref.keepAlive();

  // {@template closeLink}
  // We can use the `link` to restore the auto-dispose behavior with:
  // {@endtemplate}
  // link.close();

  return response.body;
}
