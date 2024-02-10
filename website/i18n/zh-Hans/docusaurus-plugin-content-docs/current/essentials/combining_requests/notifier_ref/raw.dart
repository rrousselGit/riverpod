// ignore_for_file: unused_local_variable

import 'package:riverpod_annotation/riverpod_annotation.dart';

final otherProvider = Provider<int>((ref) => 0);

/* SNIPPET START */
final provider = NotifierProvider<MyNotifier, int>(MyNotifier.new);

class MyNotifier extends Notifier<int> {
  @override
  int build() {
    // "Ref" 可以在这里用来阅读其他提供者程序
    final otherValue = ref.watch(otherProvider);

    return 0;
  }
}
/* SNIPPET END */
