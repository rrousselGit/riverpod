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
      // {@template render}
      // TODO: Render your app here
      // {@endtemplate}
      child: MaterialApp(),
    );
  }
}

class _EagerInitialization extends ConsumerWidget {
  const _EagerInitialization({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // {@template watch}
    // Eagerly initialize providers by watching them.
    // By using "watch", the provider will stay alive and not be disposed.
    // {@endtemplate}
    ref.watch(myProvider);
    return child;
  }
}
/* SNIPPET END */

