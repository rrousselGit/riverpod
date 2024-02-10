// ignore_for_file: avoid_print, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'activity/codegen.dart';
import 'fetch_activity/codegen.dart';

/* SNIPPET START */
class ActivityView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activity = ref.watch(activityProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Pull to refresh')),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(activityProvider.future),
        child: ListView(
          children: [
            switch (activity) {
              // Se un dato è disponibile, lo mostriamo.
              // Nota che il dato rimarrà ancora disponibile durante un aggiornamento.
              AsyncValue<Activity>(:final valueOrNull?) => Text(valueOrNull.activity),
              // Un errore è disponibile, quindi lo mostriamo.
              AsyncValue(:final error?) => Text('Error: $error'),
              // Nessun dato ne errore, quindi siamo nello stato di caricamento.
              _ => const CircularProgressIndicator(),
            },
          ],
        ),
      ),
    );
  }
}
