// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/* SNIPPET START */

// A shared state that can be accessed by multiple
// objects at the same time
final countProvider = StateProvider((ref) => 0);

// Consumes the shared state and rebuild when it changes
class Title extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(countProvider);
    return Text('$count');
  }
}
