import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../detail_screen/codegen.dart';

/* SNIPPET START */
final activityProvider = FutureProvider.autoDispose<Activity>((ref) async {
  // Capiamo se il provider è al momento distrutto oppure no.
  var didDispose = false;
  ref.onDispose(() => didDispose = true);

  // Ritardiamo la richiesta di 500ms per aspettare che l'utente finisca di aggiornare.
  await Future<void>.delayed(const Duration(milliseconds: 500));

  // Se il provider è stato distrutto durante il ritardo, significa che l'utente
  // ha aggiornato di nuovo. Generiamo un'eccezione per cancellare la richiesta.
  // È sicuro generare un'eccezione qui dato che sarà catturata da Riverpod.
  if (didDispose) {
    throw Exception('Cancelled');
  }

  // Il codice seguente non è cambiato dallo snippet precedente
  final client = http.Client();
  ref.onDispose(client.close);

  final response = await client.get(
    Uri.https('www.boredapi.com', '/api/activity'),
  );

  final json = jsonDecode(response.body) as Map;
  return Activity.fromJson(Map.from(json));
});
/* SNIPPET END */
