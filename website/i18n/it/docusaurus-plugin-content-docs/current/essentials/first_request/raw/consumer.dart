// ignore_for_file: omit_local_variable_types

/* SNIPPET START */
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'activity.dart';
import 'provider.dart';

/// La homepage della nostra applicazione
class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        // Legge l'activityProvider. Questo avvierà la richiesta di rete
        // se non era già in corso.
        // Utilizzando ref.watch, questo widget si ricostruirà ogni volta che
        // activityProvider si aggiorna. Ciò può verificarsi quando:
        // - La risposta passa da "loading" a "data/error"
        // - La richiesta è stata aggiornata
        // - Il risultato è stato modificato localmente (ad esempio durante l'esecuzione di side-effects)
        // ...
        final AsyncValue<Activity> activity = ref.watch(activityProvider);

        return Center(
          /// Poiché le richieste di rete sono asincrone e possono fallire, è necessario
          /// gestire sia gli stati di errore che di caricamento.
          /// Possiamo utilizzare il pattern matching per fare ciò.
          /// In alternativa, potremmo utilizzare `if (activity.isLoading) { ... } else if (...)`
          child: switch (activity) {
            AsyncData(:final value) => Text('Activity: ${value.activity}'),
            AsyncError() => const Text('Oops, something unexpected happened'),
            _ => const CircularProgressIndicator(),
          },
        );
      },
    );
  }
}
