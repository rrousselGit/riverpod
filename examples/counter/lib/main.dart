import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'main.g.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProviderScope(
      child: MaterialApp(
        home: MainPage(title: 'Riverpod test'),
      ),
    );
  }
}

class MainPage extends ConsumerWidget {
  const MainPage({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () async {
                final a = await ref.read(aProvider.future);
                log(a, name: 'A');
              },
              child: const Text('A'),
            ),
            ElevatedButton(
              onPressed: () async {
                final b = await ref.read(bProvider.future);
                log(b, name: 'B');
              },
              child: const Text('B'),
            ),
            ElevatedButton(
              onPressed: () async {
                final c = await ref
                    .read(watchDatabaseProvider.selectAsync((id) => '$id+456'));
                log(c, name: 'C');
              },
              child: const Text('C'),
            ),
          ],
        ),
      ),
    );
  }
}

// Provider using `.selectAsync`
@riverpod
Future<String> a(ARef ref) async {
  print('a');
  ref.onDispose(() {
    print('a disposed');
  });

  try {
    return await ref
        .watch(watchDatabaseProvider.selectAsync((id) => '$id+456'));
  } finally {
    print('b');
  }
}

// Provider using `.future`
@riverpod
Future<String> b(BRef ref) async {
  final id = await ref.watch(watchDatabaseProvider.future);
  return '$id+456';
}

@riverpod
Stream<String> watchDatabase(WatchDatabaseRef ref) => databaseStream;

Stream<String> get databaseStream async* {
  // Mock DB query delay
  await Future.delayed(const Duration(milliseconds: 100));

  yield '123';
}
