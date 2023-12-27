// ignore_for_file: avoid_print

/* SNIPPET START */

import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'main.g.dart';

<<<<<<<< HEAD:website/i18n/it/docusaurus-plugin-content-docs/current/introduction/getting_started/dart_hello_world/main.dart
// Creiamo un "provider", che conterrà un valore (qui "Hello, world").
// Utilizzando un provider, ciò ci consente di simulare/sostituire il valore esposto.
========
// 我们创建了一个 "provider"，它可以存储一个值（这里是 "Hello world"）。
// 通过使用提供者程序，这可以允许我们模拟或者覆盖一个暴露的值。
>>>>>>>> zh-tr:website/i18n/zh-Hans/docusaurus-plugin-content-docs/current/introduction/getting_started/dart_hello_world/main.dart
@riverpod
String helloWorld(HelloWorldRef ref) {
  return 'Hello world';
}

void main() {
<<<<<<<< HEAD:website/i18n/it/docusaurus-plugin-content-docs/current/introduction/getting_started/dart_hello_world/main.dart
  // Questo oggetto è dove lo stato dei nostri provider sarà salvato.
  final container = ProviderContainer();

  // Grazie a "container", possiamo leggere il nostro provider.
========
  // 这个对象是我们的提供者程序的状态将被存储的地方。
  final container = ProviderContainer();

  // 多亏有了 "container"，我们可以读取我们的提供者程序。
>>>>>>>> zh-tr:website/i18n/zh-Hans/docusaurus-plugin-content-docs/current/introduction/getting_started/dart_hello_world/main.dart
  final value = container.read(helloWorldProvider);

  print(value); // Hello world
}
