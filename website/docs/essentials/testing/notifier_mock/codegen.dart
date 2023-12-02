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

// Your mock needs to subclass the Notifier base-class corresponding
// to whatever your notifier uses
class MyNotifierMock extends _$MyNotifier with Mock implements MyNotifier {}
/* SNIPPET END */
