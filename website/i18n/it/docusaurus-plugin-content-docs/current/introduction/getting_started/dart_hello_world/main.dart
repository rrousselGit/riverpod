// ignore_for_file: avoid_print, unreachable_from_main

/* SNIPPET START */

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'main.g.dart';

// Creiamo un "provider", che conterrà un valore (qui "Hello, world").
// Utilizzando un provider, ciò ci consente di simulare/sostituire il valore esposto.
@riverpod
String helloWorld(HelloWorldRef ref) {
  return 'Hello world';
}

void main() {
  // Questo oggetto è dove lo stato dei nostri provider sarà salvato.
  final container = ProviderContainer();

  // Grazie a "container", possiamo leggere il nostro provider.
  final value = container.read(helloWorldProvider);

  print(value); // Hello world
}
