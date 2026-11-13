// GENERATED from packages/riverpod/lib/src/providers/stream_provider.dart by scripts/snippets.sh.
// Do not modify by hand: edit the snippet instead.

import 'package:riverpod/riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show WidgetRef;
import 'package:material_ui/material_ui.dart';

final messageProvider = StreamProvider.autoDispose<String>((ref) async* {});

Widget build(BuildContext context, WidgetRef ref) {
  AsyncValue<String> message = ref.watch(messageProvider);

  return message.when(
    loading: () => const CircularProgressIndicator(),
    error: (err, stack) => Text('Error: $err'),
    data: (message) {
      return Text(message);
    },
  );
}
