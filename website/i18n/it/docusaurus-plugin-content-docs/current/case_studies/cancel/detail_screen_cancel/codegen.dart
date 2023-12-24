import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../detail_screen/codegen.dart';

part 'codegen.g.dart';

/* SNIPPET START */
@riverpod
Future<Activity> activity(ActivityRef ref) async {
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
}
/* SNIPPET END */
