import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Counter provider.
final counterProvider = StateProvider((ref) => 0);

/// Counter widget.
class CounterWidget extends ConsumerWidget {
  /// Counter widget.
  const CounterWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Consumer(
        builder: (context, ref, _) {
          final count = ref.watch(counterProvider);
          return Text('$count');
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ref.read(counterProvider.notifier).state++,
        child: const Icon(Icons.add),
      ),
    );
  }
}
