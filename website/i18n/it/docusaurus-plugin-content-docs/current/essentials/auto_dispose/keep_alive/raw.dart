// ignore_for_file: unused_local_variable

import 'package:http/http.dart' as http;
import 'package:riverpod/riverpod.dart';

/* SNIPPET START */
final provider = FutureProvider.autoDispose<String>((ref) async {
  final response = await http.get(Uri.parse('https://example.com'));
  // Manteniamo il provider in vita solo se la richiesta è stata completata correttamente.
  // Se la richiesta ha fallito, quando il provider verrà smesso di essere ascoltato,
  // lo stato verrà distrutto.
  final link = ref.keepAlive();

  // Possiamo usare il `link` per ristabilire il comportamento di auto-rimozione con:
  // link.close();

  return response.body;
});
/* SNIPPET END */
