// ignore_for_file: use_key_in_widget_constructors, omit_local_variable_types

/* SNIPPET START */ import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

<<<<<<<< HEAD:website/i18n/it/docusaurus-plugin-content-docs/current/introduction/getting_started/hello_world/raw.dart
// Creiamo un "provider", che conterrà un valore (qui "Hello, world").
// Utilizzando un provider, ciò ci consente di simulare/sostituire il valore esposto.
========
// 我们创建了一个 "provider"，它可以存储一个值（这里是 "Hello world"）。
// 通过使用提供者程序，这可以允许我们模拟或者覆盖一个暴露的值。
>>>>>>>> zh-tr:website/i18n/zh-Hans/docusaurus-plugin-content-docs/current/introduction/getting_started/hello_world/raw.dart
final helloWorldProvider = Provider((_) => 'Hello world');

void main() {
  runApp(
<<<<<<<< HEAD:website/i18n/it/docusaurus-plugin-content-docs/current/introduction/getting_started/hello_world/raw.dart
    // Per consentire ai widget di leggere i provider, è necessario incapsulare l'intera
    // applicazione in un widget "ProviderScope".
    // Questo è il luogo in cui verrà memorizzato lo stato dei nostri provider.
========
    // 为了使小组件可以读取提供者程序，
    // 我们需要将整个应用程序包装在“ProviderScope”小部件中。
    // 这是我们的提供者程序的状态将被存储的地方。
>>>>>>>> zh-tr:website/i18n/zh-Hans/docusaurus-plugin-content-docs/current/introduction/getting_started/hello_world/raw.dart
    ProviderScope(
      child: MyApp(),
    ),
  );
}

<<<<<<<< HEAD:website/i18n/it/docusaurus-plugin-content-docs/current/introduction/getting_started/hello_world/raw.dart
// Estendiamo ConsumerWidget invece di StatelessWidget, il quale è esposto da Riverpod
========
// 继承父类使用 ConsumerWidget 替代 StatelessWidget，这样可以获取到提供者程序的引用
>>>>>>>> zh-tr:website/i18n/zh-Hans/docusaurus-plugin-content-docs/current/introduction/getting_started/hello_world/raw.dart
class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String value = ref.watch(helloWorldProvider);

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Example')),
        body: Center(
          child: Text(value),
        ),
      ),
    );
  }
}
