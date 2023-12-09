import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../detail_screen/codegen.dart';

/* SNIPPET START */
final activityProvider = FutureProvider.autoDispose<Activity>((ref) async {
  // Creiamo un client HTTP usando package:http
  final client = http.Client();
  // Durante la distruzione, chiudiamo il client.
  // Questo cancellerà qualsiasi richiesta pendente che il client potrebbe avere.
  ref.onDispose(client.close);

  // Ora utilizziamo il client per eseguire la richiesta "get"
  final response = await client.get(
    Uri.https('www.boredapi.com', '/api/activity'),
  );

  // Il resto del codice è uguale a prima
  final json = jsonDecode(response.body) as Map;
  return Activity.fromJson(Map.from(json));
});
/* SNIPPET END */
