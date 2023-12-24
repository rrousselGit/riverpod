// ignore_for_file: avoid_print, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'fetch_activity/codegen.dart';

/* SNIPPET START */
class ActivityView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activity = ref.watch(activityProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Pull to refresh')),
      body: RefreshIndicator(
        // Aggiornando "activityProvider.future" e restituendo il risultato,
        // l'indicatore di aggiornamento continuerà ad apparire finchè la nuova attività
        // non viene ottenuta.
        /* highlight-start */
        onRefresh: () => ref.refresh(activityProvider.future),
        /* highlight-end */
        child: ListView(
          children: [
            Text(activity.valueOrNull?.activity ?? ''),
          ],
        ),
      ),
    );
  }
}
