// ignore_for_file: unused_local_variable

import 'package:riverpod/riverpod.dart';

final otherProvider = Provider<int>((ref) => 0);

/* SNIPPET START */
final provider = NotifierProvider<MyNotifier, int>(MyNotifier.new);

class MyNotifier extends Notifier<int> {
  @override
  int build() {
    // {@template watch}
    // "Ref" can be used here to read other providers
    // {@endtemplate}
    final otherValue = ref.watch(otherProvider);

    return 0;
  }
}
/* SNIPPET END */
