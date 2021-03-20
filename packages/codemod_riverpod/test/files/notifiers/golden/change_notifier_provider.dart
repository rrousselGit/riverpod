import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Counter extends ChangeNotifier {
  Counter();
  int _state = 0;
  int get state => _state;
  void increment() {
    _state++;
    notifyListeners();
  }

  void decrement() {
    _state++;
    notifyListeners();
  }
}

final counterProvider = ChangeNotifierProvider((ref) => Counter());

final otherProvider = Provider((ref) {
  ref.read(counterProvider.notifier);
  return ref.watch(counterProvider);
});

class ConsumerWatch extends ConsumerWidget {
  const ConsumerWatch({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final count = watch(counterProvider);
    return Center(
      child: Text('$count'),
    );
  }
}
