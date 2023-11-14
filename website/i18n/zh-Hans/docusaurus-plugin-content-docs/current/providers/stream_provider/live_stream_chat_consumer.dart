import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'live_stream_chat_provider.dart';

/* SNIPPET START */
Widget build(BuildContext context, WidgetRef ref) {
  final liveChats = ref.watch(chatProvider);

  // Like FutureProvider, it is possible to handle loading/error states using AsyncValue.when
  return switch (liveChats) {
    // Display all the messages in a scrollable list view.
    AsyncData(:final value) => ListView.builder(
        // Show messages from bottom to top
        reverse: true,
        itemCount: value.length,
        itemBuilder: (context, index) {
          final message = value[index];
          return Text(message);
        },
      ),
    AsyncError(:final error) => Text(error.toString()),
    _ => const CircularProgressIndicator(),
  };
}
