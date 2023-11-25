// ignore_for_file: omit_local_variable_types, unused_local_variable, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'activity.dart';
import 'provider.dart';

/* SNIPPET START */

/// Estendiamo "HookConsumerWidget".
/// Questo combina "StatelessWidget" + "Consumer" + "HookWidget" insieme.
class Home extends HookConsumerWidget {
  const Home({super.key});

  @override
  // Si noti come il metodo "build" ora riceve un extra parametro: "ref"
  Widget build(BuildContext context, WidgetRef ref) {
    // È possibile usare gli hooks come "useState" all'interno del widget
    final counter = useState(0);

    // Possiamo anche leggere provider
    final AsyncValue<Activity> activity = ref.watch(activityProvider);

    return Center(/* ... */);
  }
}
