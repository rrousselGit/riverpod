// An application that does not use Riverpod.
import 'dart:async';

void main() {
  print('ready');

  Timer.periodic(const Duration(hours: 1), (_) {});
}
