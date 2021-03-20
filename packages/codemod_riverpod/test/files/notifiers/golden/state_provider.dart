import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final counterProvider = StateProvider((ref) => 1);

final otherProvider = Provider((ref) {
  ref.read(counterProvider.notifier);
  return ref.watch(counterProvider.state);
});

class ConsumerWatch extends ConsumerWidget {
  const ConsumerWatch({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final countController = watch(counterProvider.notifier);
    final count = watch(counterProvider.state);
    return Center(
      child: Text('$count'),
    );
  }
}
