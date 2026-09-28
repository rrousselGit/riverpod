// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'activity/codegen.dart';
import 'fetch_activity/codegen.dart';

/* SNIPPET START */
class BreweryView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brewery = ref.watch(breweryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Pull to refresh')),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(breweryProvider.future),
        child: ListView(
          children: [
            switch (brewery) {
              // {@template data}
              // If some data is available, we display it.
              // Note that data will still be available during a refresh.
              // {@endtemplate}
              AsyncValue<Brewery>(:final value?) => Text(value.name),
              // {@template error}
              // An error is available, so we render it.
              // {@endtemplate}
              AsyncValue(:final error?) => Text('Error: $error'),
              // {@template loading}
              // No data/error, so we're in loading state.
              // {@endtemplate}
              _ => const CircularProgressIndicator(),
            },
          ],
        ),
      ),
    );
  }
}
