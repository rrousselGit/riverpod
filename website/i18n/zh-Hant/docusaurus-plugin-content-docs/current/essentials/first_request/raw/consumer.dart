// ignore_for_file: omit_local_variable_types

/* SNIPPET START */ import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'activity.dart';
import 'provider.dart';

/// 我們應用程式主頁
class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        // 讀取 activityProvider。如果沒有準備開始，這將會開始一個網路請求。
        // 透過使用 ref.watch，小元件將會在 activityProvider 更新時重建。
        // 當下面的事情發生時，會更新小元件：
        // - 響應從“正在載入”變為“資料/錯誤”
        // - 請求重重新整理
        // - 結果被本地修改（例如執行副作用時）
        // ...
        final AsyncValue<Activity> activity = ref.watch(activityProvider);

        return Center(
          /// 由於網路請求是非同步的並且可能會失敗，我們需要處理錯誤和載入的狀態。
          /// 我們可以為此使用模式匹配。
          /// 我們也可以使用 `if (activity.isLoading) { ... } else if (...)`
          child: switch (activity) {
            AsyncData(:final value) => Text('Activity: ${value.activity}'),
            AsyncError() => const Text('Oops, something unexpected happened'),
            _ => const CircularProgressIndicator(),
          },
        );
      },
    );
  }
}
