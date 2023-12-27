// ignore_for_file: prefer_mixin

import 'package:mockito/mockito.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'codegen.g.dart';

/* SNIPPET START */
@riverpod
class MyNotifier extends _$MyNotifier {
  @override
  int build() => throw UnimplementedError();
}

// 您的模拟类需要作为 Notifier 的子类，与您的通知者程序使用的基类相对应
class MyNotifierMock extends _$MyNotifier with Mock implements MyNotifier {}
/* SNIPPET END */
