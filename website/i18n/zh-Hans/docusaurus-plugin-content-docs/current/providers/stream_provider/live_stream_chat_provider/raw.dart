import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

/* SNIPPET START */
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
