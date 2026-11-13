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

class MyConsumer extends ConsumerStatefulWidget {
  const MyConsumer({Key? key}) : super(key: key);

  @override
  ConsumerState<MyConsumer> createState() => _MyConsumerState();
}

class _MyConsumerState extends ConsumerState<MyConsumer> {
  @override
  void initState() {
    // All State life-cycles can be used
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // "ref" is a property of ConsumerState and can be used to read providers
    final value = ref.watch(someProvider);
    return Text(value);
  }
}
