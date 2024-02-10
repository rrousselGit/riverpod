// ignore_for_file: unused_local_variable, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final myProvider = Provider<int>((ref) => 0);

/* SNIPPET START */
void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const _EagerInitialization(
      // TODO: Renderizza la tua app qui
      child: MaterialApp(),
    );
  }
}

class _EagerInitialization extends ConsumerWidget {
  const _EagerInitialization({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Inizializza anticipatamente i provider osservandoli.
    // Usando "watch", il provider resterà in vita e non sarà distrutto.
    ref.watch(myProvider);
    return child;
  }
}
/* SNIPPET END */

