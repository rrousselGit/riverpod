// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'reading_counter.dart';

/* SNIPPET START */

class HomeView extends HookConsumerWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // HookConsumerWidget은 build 메소드 안에서 hooks을 사용할 수 있도록 도와줍니다.
    final state = useState(0);

    // 프로바이더를 사용/구독하기 위해서 ref 매개변수도 사용할 수 있습니다.
    final counter = ref.watch(counterProvider);
    return Text('$counter');
  }
}
