import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/legacy.dart';

final p = StateProvider((ref) => 0);

final p2 = StateProvider.autoDispose((ref) => 0);

final p3 = ChangeNotifierProvider<ValueNotifier<int>>((ref) {
  throw UnimplementedError();
});

final p4 = StateNotifierProvider<StateNotifier<int>, int>((ref) {
  throw UnimplementedError();
});

class MyNotifier extends StateNotifier<int> {
  MyNotifier() : super(0);
}
