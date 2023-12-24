// ignore_for_file: prefer_mixin

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/mockito.dart';

/* SNIPPET START */
class MyNotifier extends Notifier<int> {
  @override
  int build() => throw UnimplementedError();
}

// Il tuo mock necessita di subclassare la classe base del Notifier
class MyNotifierMock extends Notifier<int> with Mock implements MyNotifier {}
/* SNIPPET END */
