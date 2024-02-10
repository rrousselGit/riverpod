// ignore_for_file: unused_local_variable, avoid_multiple_declarations_per_line, omit_local_variable_types, prefer_final_locals, use_key_in_widget_constructors

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/* SNIPPET START */
class User {
  late String firstName, lastName;
}

final provider = Provider(
  (ref) => User()
    ..firstName = 'John'
    ..lastName = 'Doe',
);

class ConsumerExample extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 替代这种写法：
    // String name = ref.watch(provider).firstName!;
    // 我们可以写：
    String name = ref.watch(provider.select((it) => it.firstName));
    // 这将导致 widget 只监听 "firstName" 上的更改。

    return Text('Hello $name');
  }
}
/* SNIPPET END */
