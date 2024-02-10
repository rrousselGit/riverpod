/* SNIPPET START */

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'activity.dart';

// Necessario affinché la generazione del codice funzioni
part 'provider.g.dart';

/// This will create a provider named `activityProvider`
/// which will cache the result of this function.
@riverpod
Future<Activity> activity(ActivityRef ref) async {
  // Usando il package http, otteniamo un'attività casuale dalle Bored API
  final response = await http.get(Uri.https('boredapi.com', '/api/activity'));
  // Usando dart:convert, decodifichiamo il payload JSON in una Map.
  final json = jsonDecode(response.body) as Map<String, dynamic>;
  // Infine, convertiamo la mappa in un'istanza Activity
  return Activity.fromJson(json);
}
