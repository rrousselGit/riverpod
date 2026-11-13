// GENERATED from packages/flutter_riverpod/lib/src/core/consumer.dart by scripts/snippets.sh.
// Do not modify by hand: edit the snippet instead.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart' show riverpod;

class User {
  String get name => 'John';
}

final userProvider = FutureProvider<User>((ref) async => User());
final someProvider = Provider((ref) => 'Hello world');
final anotherProvider = Provider((ref) => 42);

class Example extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(someProvider);
    final another = ref.watch(anotherProvider);
    return Text(value); // Hello world
  }
}
