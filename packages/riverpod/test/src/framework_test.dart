import 'package:riverpod/src/framework.dart';
import 'package:riverpod/src/internals.dart' show Provider;
import 'package:test/test.dart';

void main() {
  test('RemoveListener removes the listener it was returned for', () {
    final container = ProviderContainer.test();
    var disposeCount = 0;
    final provider = Provider((ref) {
      final RemoveListener remove = ref.onDispose(() => disposeCount++);
      remove();
      return 0;
    });

    container.read(provider);
    container.invalidate(provider);
    container.read(provider);

    expect(disposeCount, 0);
  });
}
