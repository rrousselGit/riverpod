import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'live_stream_chat_provider.dart';

/* SNIPPET START */
Widget build(BuildContext context, WidgetRef ref) {
  final liveChats = ref.watch(chatProvider);
  // 与 FutureProvider 一样，可以使用 AsyncValue.when 处理加载/错误状态
  return liveChats.when(
    loading: () => const CircularProgressIndicator(),
    error: (error, stackTrace) => Text(error.toString()),
    data: (messages) {
      // 使用 ListView 组件显示所有消息
      return ListView.builder(
        // 此参数定为 true 将信息按从下到上的顺序显示
        reverse: true,
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final message = messages[index];
          return Text(message);
        },
      );
    },
  );
}
