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

// Il tuo mock necessita di subclassare la classe base del Notifier
class MyNotifierMock extends _$MyNotifier with Mock implements MyNotifier {}
/* SNIPPET END */
