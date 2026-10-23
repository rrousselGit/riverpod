import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('exports the legacy APIs', () {
    expect(<Type>[
      StateNotifier,
      StateController,
      StateNotifierProvider,
      StateNotifierProviderFamily,
      StateProvider,
      StateProviderFamily,
      ChangeNotifierProvider,
      ChangeNotifierProviderFamily,
    ], hasLength(8));
  });
}
