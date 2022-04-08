import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'reading_counter.dart';

/* SNIPPET START */

class HomeView extends ConsumerStatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends ConsumerState<HomeView> {
  @override
  void initState() {
    super.initState();
    // "ref"는 StatefulWidget의 모든 생명주기 상에서 사용할 수 있습니다.
    ref.read(counterProvider);
  }

  @override
  Widget build(BuildContext context) {
    // "ref"는 build 메소드 안에서 프로바이더를 구독(listen)하기위해 사용할 수 있습니다.
    final counter = ref.watch(counterProvider);
    return Text('$counter');
  }
}
