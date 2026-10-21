import 'package:riverpod/src/framework.dart';
import 'package:riverpod/src/providers/provider.dart';
import 'package:test/test.dart';

void main() {
  test('Ref life-cycles return a function that removes the listener', () {
    final container = ProviderContainer.test();
    var disposeCount = 0;
    late void Function() remove;
    final provider = Provider<int>((ref) {
      remove = ref.onDispose(() => disposeCount++);
      return 0;
    });

    container.read(provider);
    remove();
    container.invalidate(provider);
    container.read(provider);

    expect(disposeCount, 0);
  });
}
