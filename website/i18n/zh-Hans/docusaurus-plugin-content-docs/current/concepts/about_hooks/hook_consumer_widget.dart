// ignore_for_file: use_key_in_widget_constructors, unused_local_variable

import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../providers/creating_a_provider/codegen.dart';

class MyValue {}

/* SNIPPET START */

// 我们扩展了 HookConsumerWidget，而不是 HookWidget
class Example extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 我们可以在这里同时使用钩子和提供者程序
    final counter = useState(0);
    final value = ref.watch(myProvider);

    return Text('Hello $counter $value');
  }
}
