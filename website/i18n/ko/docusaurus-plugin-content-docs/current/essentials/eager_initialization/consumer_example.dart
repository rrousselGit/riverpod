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
      // TODO: 여기에서 앱 렌더링
      child: MaterialApp(),
    );
  }
}

class _EagerInitialization extends ConsumerWidget {
  const _EagerInitialization({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // providers를 감시하여 이른 초기화(Eagerly initialize)합니다.
    // "watch"를 사용하면 provider가 폐기(disposed)되지 않고 계속 살아 있습니다.
    ref.watch(myProvider);
    return child;
  }
}
/* SNIPPET END */
