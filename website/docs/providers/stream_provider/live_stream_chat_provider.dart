import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/* SNIPPET START */
// Fake chats as data sorce
// Error last index is represent error which type is not a string
const fakeChats = ['John Hi', 'Flutter is Cute', 1];

// stream provider
final chatProvider = StreamProvider<List<String>>((ref) async* {
  // Connect to an API using sockets, and decode the output
  final socket = await Socket.connect('my-api', 4242);
  ref.onDispose(socket.close);
  
  var allMessages = const <String>[];
  await for (final message in socket.map(utf8.decode)) {
    // A new message has been received. Let's add it to the list of all messages.
    allMessages = [...allMessages, message];
    yield allMessages;
  }
});
