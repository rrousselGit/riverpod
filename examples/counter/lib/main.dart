import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() => runApp(const ProviderScope(child: MyPage()));

class MyPage extends ConsumerWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('===');
    ref.watch(combine);
    return MaterialApp(
      home: Scaffold(
        body: Text(ref.watch(myNotifierProvider).toString()),
      ),
    );
  }
}

final data = FutureProvider.autoDispose(name: 'data', (ref) async {
  print('data start');
  await Future<void>.delayed(
    const Duration(seconds: 1),
  ); // Simulating network request
  print('===');
  return 'data';
});

final data2 = Provider.autoDispose(name: 'data2', (ref) {
  print('data2 start');
  return ref.watch(data).value;
});

final data3 = Provider.autoDispose(name: 'data3', (ref) {
  print('data3 start');
  return ref.watch(data2);
});

final myNotifierProvider =
    NotifierProvider.autoDispose<MyNotifier, int>(MyNotifier.new);

class MyNotifier extends Notifier<int> {
  @override
  int build() {
    print('notifier start');
    // change to return ref.watch to fix
    ref.listen(
      data3,
      (previous, next) {
        print('set new state');
        state = 1;
      },
    );
    return 0;
  }
}

final combine = Provider.autoDispose(name: 'combine', (ref) {
  print('combine start');
  ref.watch(data2);
  // ref.watch(data3); // uncomment this to fix
  ref.watch(myNotifierProvider);
  print('provider end');
  return 0;
});
