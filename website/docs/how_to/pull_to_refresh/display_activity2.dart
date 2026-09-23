// ignore_for_file: avoid_print, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'fetch_activity/codegen.dart';

/* SNIPPET START */
class BreweryView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brewery = ref.watch(breweryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Pull to refresh')),
      /* highlight-start */
      body: RefreshIndicator(
        onRefresh: () async => print('refresh'),
        child: ListView(
          children: [
            /* highlight-end */
            Text(brewery.value?.name ?? ''),
          ],
        ),
      ),
    );
  }
}
