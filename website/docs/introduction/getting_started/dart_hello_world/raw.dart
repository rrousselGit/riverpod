// ignore_for_file: avoid_print

/* SNIPPET START */

import 'package:riverpod/riverpod.dart';

// {@template helloWorld}
// We create a "provider", which will store a value (here "Hello world").
// By using a provider, this allows us to mock/override the value exposed.
// {@endtemplate}
final helloWorldProvider = Provider((_) => 'Hello world');

void main() {
  // {@template container}
  // This object is where the state of our providers will be stored.
  // {@endtemplate}
  final container = ProviderContainer();

  // {@template value}
  // Thanks to "container", we can read our provider.
  // {@endtemplate}
  final value = container.read(helloWorldProvider);

  print(value); // Hello world
}
