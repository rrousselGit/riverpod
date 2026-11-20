// GENERATED from packages/riverpod/lib/src/core/modifiers/select.dart by scripts/snippets.sh.
// Do not modify by hand: edit the snippet instead.

import 'package:riverpod/riverpod.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'
    show ConsumerWidget, WidgetRef;
import 'package:flutter_riverpod/legacy.dart';

class Person extends ChangeNotifier {
  int _age = 0;
  int get age => _age;
  set age(int age) {
    _age = age;
    notifyListeners();
  }

  String _name = '';
  String get name => _name;
  set name(String name) {
    _name = name;
    notifyListeners();
  }
}

final personProvider = ChangeNotifierProvider((_) => Person());

class Age extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final age = ref.watch(personProvider.select((p) => p.age));
    return Text('$age');
  }
}

class IsAdult extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAdult = ref.watch(personProvider.select((p) => p.age >= 18));
    return Text('$isAdult');
  }
}
