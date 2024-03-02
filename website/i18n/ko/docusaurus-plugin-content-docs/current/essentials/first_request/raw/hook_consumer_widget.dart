// ignore_for_file: omit_local_variable_types, unused_local_variable, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'activity.dart';
import 'provider.dart';

/* SNIPPET START */

/// "HookConsumerWidget"을 서브클래스화했습니다.
/// 이것은 "StatelessWidget" + "Consumer" + "HookWidget"을 함께 결합합니다.
class Home extends HookConsumerWidget {
  const Home({super.key});

  @override
  // 이제 "build"가 추가 매개 변수 "ref"를 받는 것에 주목하세요.
  Widget build(BuildContext context, WidgetRef ref) {
    // 위젯 내부에서 "useState"와 같은 훅을 사용할 수 있습니다.
    final counter = useState(0);

    // providers도 읽을 수 있습니다.
    final AsyncValue<Activity> activity = ref.watch(activityProvider);

    return Center(/* ... */);
  }
}
