import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final counterProvider = StateProvider((ref) => 1);

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
