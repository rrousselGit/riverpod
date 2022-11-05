// ignore_for_file: avoid_print

/* SNIPPET START */

import 'package:riverpod/riverpod.dart';

// Мы создаем "provider", который будет хранить значение (т.е. "Hello world").
// Использование provider позволяет нам имитировать/переопределять хранимое значение.
final helloWorldProvider = Provider((_) => 'Hello world');

void main() {
  // В данном объекте хранятся состояния наших провайдеров.
  final container = ProviderContainer();

  // Благодаря "container", мы можем узнать/прочесть значение нашего провайдера.
  final value = container.read(helloWorldProvider);

  print(value); // Hello world
}
