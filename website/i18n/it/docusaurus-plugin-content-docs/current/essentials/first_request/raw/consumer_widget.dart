// ignore_for_file: omit_local_variable_types, prefer_const_constructors, unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'activity.dart';
import 'provider.dart';

/* SNIPPET START */

/// Estendiamo "ConsumerWidget" al posto di "StatelessWidget".
/// Ciò è equivalente a creare uno "StatelessWidget" e ritornare un widget "Consumer".
class Home extends ConsumerWidget {
  const Home({super.key});

  @override
  // Si noti come il metodo "build" ora riceve un extra parametro: "ref"
  Widget build(BuildContext context, WidgetRef ref) {
    // Possiamo usare "ref.watch" dentro il nostro widget come facevamo con "Consumer"
    final AsyncValue<Activity> activity = ref.watch(activityProvider);

    // Il codice dell'interfaccia grafica rimane la stesso
    return Center(/* ... */);
  }
}
