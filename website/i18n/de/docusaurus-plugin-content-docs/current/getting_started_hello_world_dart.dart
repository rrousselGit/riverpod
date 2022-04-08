// ignore_for_file: avoid_print

/* SNIPPET START */

import 'package:riverpod/riverpod.dart';

// Wir erstellen einen "Provider", der einen Wert speichern wird (hier "Hello world").
// Durch die Nutzung eines Provider, ist es uns erlaubt den gelieferten Wert
// zu mocken oder zu überschreiben
final helloWorldProvider = Provider((_) => 'Hello world');

void main() {
  // Das ist das Objekt, in dem der Zustand unserer Provider gespeichert wird.
  final container = ProviderContainer();

  // Dank des "container" können wir unseren provider lesen.
  final value = container.read(helloWorldProvider);

  print(value); // Hello world
}
