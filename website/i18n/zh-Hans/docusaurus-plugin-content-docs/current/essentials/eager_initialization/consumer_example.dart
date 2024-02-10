// ignore_for_file: unused_local_variable, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final myProvider = Provider<int>((ref) => 0);

/* SNIPPET START */
void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const _EagerInitialization(
      // TODO: 在这里渲染你的 APP
      child: MaterialApp(),
    );
  }
}

class _EagerInitialization extends ConsumerWidget {
  const _EagerInitialization({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 通过观察提供者程序，来初始化提供者程序。
    // 通过使用 "watch"，提供者程序将保持存活，不会被处置。
    ref.watch(myProvider);
    return child;
  }
}
/* SNIPPET END */

