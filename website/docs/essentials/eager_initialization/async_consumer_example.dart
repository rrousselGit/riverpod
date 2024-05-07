// ignore_for_file: unused_local_variable, use_key_in_widget_constructors, unused_element

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final myProvider = FutureProvider<int>((ref) => 0);

/* SNIPPET START */
class _EagerInitialization extends ConsumerWidget {
  const _EagerInitialization({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final result = ref.watch(myProvider);

    // {@template states}
    // Handle error states and loading states
    // {@endtemplate}
    if (result.isLoading) {
      return const CircularProgressIndicator();
    } else if (result.hasError) {
      return const Text('Oopsy!');
    }

    return child;
  }
}
/* SNIPPET END */

