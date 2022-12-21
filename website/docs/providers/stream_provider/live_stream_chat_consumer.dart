import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'live_stream_chat_provider.dart';

/* SNIPPET START */
// UI part is same as like Future provider
Widget build(BuildContext context, WidgetRef ref) {
  final liveChats = ref.watch(liveStreamProvider);
  return liveChats.when(
    loading: () => const CircularProgressIndicator(),
    error: (error, stackTrace) => Text(error.toString()),
    data: (msgs) {
      return Text(msgs);
    },
  );
}
