import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

/* SNIPPET START */
final chatProvider = StreamProvider<List<String>>((ref) async* {
  // 使用 sockets 连接到 API，并解码输出
  final socket = await Socket.connect('my-api', 4242);
  ref.onDispose(socket.close);

  var allMessages = const <String>[];
  await for (final message in socket.map(utf8.decode)) {
    // 新信息已接收。让我们将其添加到所有信息的列表中。
    allMessages = [...allMessages, message];
    yield allMessages;
  }
});
