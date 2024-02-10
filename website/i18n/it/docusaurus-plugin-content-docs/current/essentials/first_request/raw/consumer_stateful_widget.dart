// ignore_for_file: omit_local_variable_types, prefer_const_constructors, unused_local_variable, todo

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'activity.dart';
import 'provider.dart';

/* SNIPPET START */

// Estendiamo "ConsumerStatefulWidget".
// Questo è l'equivalente di usare "Consumer" in un "StatefulWidget"
class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeState();
}

// Si noti come invece di "State", stiamo estendendo "ConsumerState".
// Ciò usa lo stesso principio di "ConsumerWidget" al posto di "StatelessWidget"
class _HomeState extends ConsumerState<Home> {
  @override
  void initState() {
    super.initState();

    // Anche i cicli di vita dello stato hanno accesso a "ref".
    // Ciò consente operazioni come l'aggiunta di un listener a un provider specifico
    // per mostrare dialoghi/snackbars.
    ref.listenManual(activityProvider, (previous, next) {
      // TODO mostrare una snackbar/dialog
    });
  }

  @override
  Widget build(BuildContext context) {
    // "ref" non è più passato come parametro, ma è invece una proprietà di "ConsumerState".
    // Possiamo quindi tenere "ref.watch" dentro il metodo "build".
    final AsyncValue<Activity> activity = ref.watch(activityProvider);

    return Center(/* ... */);
  }
}
