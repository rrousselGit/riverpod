// ignore_for_file: prefer_mixin

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/mockito.dart';

/* SNIPPET START */
class MyNotifier extends Notifier<int> {
  @override
  int build() => throw UnimplementedError();
}

// 您的模拟类需要作为 Notifier 的子类，与您的通知者程序使用的基类相对应
class MyNotifierMock extends Notifier<int> with Mock implements MyNotifier {}
/* SNIPPET END */
