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

// Mock 클래스는 notifier가 사용하는 것에 해당하는 Notifier base-class를 서브클래싱해야 합니다.
class MyNotifierMock extends _$MyNotifier with Mock implements MyNotifier {}
/* SNIPPET END */
