// An application that uses Riverpod, but has not created anything yet.
import 'dart:async';

import 'package:riverpod/riverpod.dart';

final provider = Provider((ref) => 0);

void main() {
  print('ready');

  Timer.periodic(const Duration(hours: 1), (_) {});
}
