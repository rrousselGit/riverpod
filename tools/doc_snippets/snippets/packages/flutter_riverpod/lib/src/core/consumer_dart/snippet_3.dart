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

class Example extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User')),
      body: Consumer(
        builder: (context, ref, child) {
          return switch (ref.watch(userProvider)) {
            AsyncValue(:final value?) => Text(value.name),
            AsyncValue(hasError: true) => Text('Error'),
            _ => CircularProgressIndicator(),
          };
        },
      ),
    );
  }
}
