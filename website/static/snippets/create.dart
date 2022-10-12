// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter_riverpod/flutter_riverpod.dart';

/* SNIPPET START */

@riverpod
Future<String> boredSuggestion(BoredSuggestionRef ref) async {
  final response = await http.get(
    Uri.https('https://www.boredapi.com/api/activity'),
  );
  final json = jsonDecode(response.body);
  return json['activity']! as String;
}
