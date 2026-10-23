import 'package:riverpod/legacy.dart';
import 'package:test/test.dart';

void main() {
  test('exports the legacy APIs', () {
    expect(<Type>[
      StateNotifier,
      StateController,
      StateNotifierProvider,
      StateNotifierProviderFamily,
      StateProvider,
      StateProviderFamily,
    ], hasLength(6));
  });
}
