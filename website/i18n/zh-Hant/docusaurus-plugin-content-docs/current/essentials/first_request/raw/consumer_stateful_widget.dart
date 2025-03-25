// ignore_for_file: omit_local_variable_types, prefer_const_constructors, unused_local_variable, todo

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'activity.dart';
import 'provider.dart';

/* SNIPPET START */ // 我們擴充套件了 ConsumerStatefulWidget。
// 這等效於 "Consumer" + "StatefulWidget".
class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeState();
}

// 請注意，我們如何擴充套件“ConsumerState”而不是“State”。
// 這和 "ConsumerWidget" 與 "StatelessWidget" 是相同的原理。
class _HomeState extends ConsumerState<Home> {
  @override
  void initState() {
    super.initState();

    // 狀態生命週期也可以訪問“ref”。
    // 這使得在特定提供者程式上新增監聽器，以便實現顯示對話方塊/資訊欄等功能。
    ref.listenManual(activityProvider, (previous, next) {
      // TODO 顯示一個 snackbar/dialog
    });
  }

  @override
  Widget build(BuildContext context) {
    // "ref" is not passed as parameter anymore, but is instead a property of "ConsumerState".
    // We can therefore keep using "ref.watch" inside "build".
    // “ref”不再作為引數傳遞，而是作為“ConsumerState”的屬性。
    // 因此，我們可以繼續在“build”中使用“ref.watch”。
    final AsyncValue<Activity> activity = ref.watch(activityProvider);

    return Center(/* ... */);
  }
}
