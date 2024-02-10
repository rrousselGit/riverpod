// ignore_for_file: omit_local_variable_types, unused_local_variable, prefer_final_locals

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'tuple_family.dart';

class Example extends ConsumerWidget {
  const Example({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
/* SNIPPET START */
    ref.watch(
      // Record를 사용하여 매개 변수를 전달할 수 있습니다.
      // Record가 ==를 재정의하므로 watch 호출에서 직접 Record를 생성해도 괜찮습니다.
      activityProvider((type: 'recreational', maxPrice: 40)),
    );
/* SNIPPET END */

    return Container();
  }
}
