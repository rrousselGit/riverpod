// ignore_for_file: use_key_in_widget_constructors, unused_local_variable

import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../providers/creating_a_provider/codegen.dart';

class MyValue {}

/* SNIPPET START */

// HookWidget 대신 HookConsumerWidget을 확장합니다.
class Example extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 여기서는 hooks과 providers를 모두 사용할 수 있습니다.
    final counter = useState(0);
    final value = ref.watch(myProvider);

    return Text('Hello $counter $value');
  }
}
