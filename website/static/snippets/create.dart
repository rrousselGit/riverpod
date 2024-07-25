// ignore_for_file: use_key_in_widget_constructors

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create.g.dart';

/* SNIPPET START */

@riverpod
Future<String> boredSuggestion(BoredSuggestionRef ref) async {
  final response = await http.get(
    Uri.https('boredapi.com', '/api/activity'),
  );
  final json = jsonDecode(response.body) as Map;
  return json['activity']! as String;
}
