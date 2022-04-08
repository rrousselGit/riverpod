// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'reading_counter.dart';

class HomeView extends HookConsumerWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return
/* SNIPPET START */
        Scaffold(
      body: HookConsumer(
        builder: (context, ref, child) {
          // HookConsumerWidget과 같이, builder안에서 hooks을 사용할 수 있습니다.
          final state = useState(0);

          // 프로바이더를 사용/구독(listen)하기 위해서 ref 매개변수도 사용할 수 있습니다.
          final counter = ref.watch(counterProvider);
          return Text('$counter');
        },
      ),
    );
/* SNIPPET END */
  }
}
