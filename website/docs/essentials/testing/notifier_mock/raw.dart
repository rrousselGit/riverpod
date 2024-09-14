// ignore_for_file: prefer_mixin

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/mockito.dart';

/* SNIPPET START */
class MyNotifier extends Notifier<int> {
  @override
  int build() => throw UnimplementedError();
}

// {@template mock}
// Your mock needs to subclass the Notifier base-class corresponding
// to whatever your notifier uses
// {@endtemplate}
class MyNotifierMock extends Notifier<int> with Mock implements MyNotifier {}
/* SNIPPET END */
