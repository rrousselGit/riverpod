// ignore_for_file: use_key_in_widget_constructors, omit_local_variable_types

/* SNIPPET START */ import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Creiamo un "provider", che conterrà un valore (qui "Hello, world").
// Utilizzando un provider, ciò ci consente di simulare/sostituire il valore esposto.
final helloWorldProvider = Provider((_) => 'Hello world');

void main() {
  runApp(
    // Per consentire ai widget di leggere i provider, è necessario incapsulare l'intera
    // applicazione in un widget "ProviderScope".
    // Questo è il luogo in cui verrà memorizzato lo stato dei nostri provider.
    ProviderScope(
      child: MyApp(),
    ),
  );
}

// Estendiamo HookConsumerWidget invece di StatelessWidget, il quale è esposto da Riverpod
class MyApp extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Possiamo usare gli hooks all'interno di un HookConsumerWidget
    final counter = useState(0);

    final String value = ref.watch(helloWorldProvider);

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Example')),
        body: Center(
          child: Text('$value ${counter.value}'),
        ),
      ),
    );
  }
}
