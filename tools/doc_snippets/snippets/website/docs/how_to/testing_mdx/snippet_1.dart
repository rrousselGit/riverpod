// GENERATED from website/docs/how_to/testing.mdx by scripts/snippets.sh.
// Do not modify by hand: edit the snippet instead.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';

class MyNotifier extends Notifier<int> {
  @override
  int build() => throw UnimplementedError();
}

class MyNotifierMock with Mock implements MyNotifier {}
