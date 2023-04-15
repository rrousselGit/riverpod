// ignore_for_file: avoid_print

/* SNIPPET START */

import 'package:riverpod/riverpod.dart';

// Creiamo un "provider", il quale immagazzinerà un valore (qui "Hello world").
// Usare un provider ci permetterà di simulare/sovrascrivere il valore esposto.

final helloWorldProvider = Provider((_) => 'Hello world');

void main() {
  // Questo è l'oggetto dove lo stato dei nostri provider sarà salvato.
  final container = ProviderContainer();

  // Grazie a "container", possiamo leggere il nostro provider.
  final value = container.read(helloWorldProvider);

  print(value); // Hello world
}
