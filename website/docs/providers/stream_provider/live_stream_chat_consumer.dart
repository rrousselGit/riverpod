import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'live_stream_chat_provider.dart';

/* SNIPPET START */
Widget build(BuildContext context, WidgetRef ref) {
  final liveChats = ref.watch(chatProvider);
  // Like FutureProvider, it is possible to handle loading/error states using AsyncValue.when
  return liveChats.when(
    loading: () => const CircularProgressIndicator(),
    error: (error, stackTrace) => Text(error.toString()),
    data: (messages) {
      return Text(msgs);
    },
  );
}
