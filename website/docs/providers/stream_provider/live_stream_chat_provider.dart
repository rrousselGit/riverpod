import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/* SNIPPET START */
// Fake chats as data sorce
// Error last index is represent error which type is not a string
const fakeChats = ['John Hi', 'Flutter is Cute', 1];

// stream provider
final liveStreamProvider = StreamProvider((ref) {
  return liveStreamChat();
});
// fake chats come as Stream
Stream<String> liveStreamChat() async* {
  for (var i = 0; i < 10; i++) {
// Wait for a second
    yield await Future.delayed(const Duration(seconds: 1));
    try {
      // yield chats
      yield fakeChats[i] as String;
    } catch (error) {
      // handling error
      yield* Stream.error(error);
    }
  }
}
