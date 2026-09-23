// ignore_for_file: use_key_in_widget_constructors

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
      body: RefreshIndicator(
        // {@template onRefresh}
        // By refreshing "breweryProvider.future", and returning that result,
        // the refresh indicator will keep showing until the new brewery is
        // fetched.
        // {@endtemplate}
        /* highlight-start */
        onRefresh: () => ref.refresh(breweryProvider.future),
        /* highlight-end */
        child: ListView(
          children: [
            Text(brewery.value?.name ?? ''),
          ],
        ),
      ),
    );
  }
}
