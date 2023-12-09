import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

/* SNIPPET START */
extension DebounceAndCancelExtension on Ref {
  /// Aspetta per la [duration] (di default a 500ms) e poi ritorna un [http.Client]
  /// con il quale possiamo effettuare una richiesta.
  ///
  /// Il client sarà chiuso automaticamente quando il provider verrà distrutto.
  Future<http.Client> getDebouncedHttpClient([Duration? duration]) async {
    // Per prima cosa gestiamo il debouncing.
    var didDispose = false;
    onDispose(() => didDispose = true);

    // Ritardiamo la richiesta di 500ms per aspettare che l'utente finisca di aggiornare.
    await Future<void>.delayed(duration ?? const Duration(milliseconds: 500));

    // Se il provider è stato distrutto durante il ritardo, significa che l'utente
    // ha aggiornato di nuovo. Generiamo un'eccezione per cancellare la richiesta.
    // È sicuro generare un'eccezione qui dato che sarà catturata da Riverpod.
    if (didDispose) {
      throw Exception('Cancelled');
    }

    // Ora possiamo creare il client e chiuderlo quando il provider viene distrutto.
    final client = http.Client();
    onDispose(client.close);

    // Infine, restituiamo il client per permettere al nostro provider di effettuare la richiesta.
    return client;
  }
}
