import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../detail_screen/codegen.dart';

part 'codegen.g.dart';

/* SNIPPET START */
@riverpod
Future<Activity> activity(ActivityRef ref) async {
  // Capiamo se il provider è al momento distrutto oppure no.
  var didDispose = false;
  ref.onDispose(() => didDispose = true);

  // Ritardiamo la chiamata di 500ms per aspettare che l'utente finisca di riaggiornare.
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
}
/* SNIPPET END */
