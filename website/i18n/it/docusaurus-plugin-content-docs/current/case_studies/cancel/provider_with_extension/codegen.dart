import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../detail_screen/codegen.dart';
import '../extension.dart';

part 'codegen.g.dart';

/* SNIPPET START */
@riverpod
Future<Activity> activity(ActivityRef ref) async {
  // Otteniamo un client HTTP usando l'estensione creata prima.
  final client = await ref.getDebouncedHttpClient();

  // Usiamo ora il client per effettuare la richiesta "get".
  // La nostra richiesta sarà automaticamente respinta e cancellata se l'utente
  // lascia la pagina
  final response = await client.get(
    Uri.https('www.boredapi.com', '/api/activity'),
  );

  final json = jsonDecode(response.body) as Map;
  return Activity.fromJson(Map.from(json));
}
/* SNIPPET END */
