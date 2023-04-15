// ignore_for_file: use_key_in_widget_constructors, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/* SNIPPET START */

// riverpod과 Logger를 사용한 카운터 앱 예제

class Logger extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    print('''
{
  "provider": "${provider.name ?? provider.runtimeType}",
  "newValue": "$newValue"
}''');
  }
}

void main() {
  runApp(
    // ProviderScope를 추가하여 프로젝트 전반적으로 Riverpod을 사용가능하도록 합니다.
    // observers 리스트(목록)에 위에서 정의한 Logger 클래스를 추가합니다.
    ProviderScope(observers: [Logger()], child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Home());
  }
}

final counterProvider = StateProvider((ref) => 0, name: 'counter');

class Home extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Counter example')),
      body: Center(
        child: Text('$count'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ref.read(counterProvider.notifier).state++,
        child: const Icon(Icons.add),
      ),
    );
  }
}
