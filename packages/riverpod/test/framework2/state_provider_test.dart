import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

void main() {
  ProviderContainer container;
  setUp(() {
    container = ProviderContainer();
  });
  tearDown(() {
    container.dispose();
  });

  group('StateProvider.autoDispose', () {
    test('creates a new controller when no-longer listened', () async {
      final provider = StateProvider.autoDispose((ref) => 0);

      final sub = container.listen(provider);
      final first = sub.read();

      first.state++;
      expect(first.state, 1);
      expect(first.mounted, true);

      sub.close();
      await Future<void>.value();

      final second = container.read(provider);

      expect(first.mounted, false);
      expect(second, isNot(first));
      expect(second.state, 0);
      expect(second.mounted, true);
    });
  });
  group('StateProvider.family.autoDispose', () {
    test('creates a new controller when no-longer listened', () async {
      final provider =
          StateProvider.autoDispose.family<int, int>((ref, id) => id);

      final sub = container.listen(provider(0));
      final sub2 = container.listen(provider(42));
      final first = sub.read();

      first.state++;
      expect(sub2.read().state, 42);
      expect(first.state, 1);
      expect(first.mounted, true);

      sub.close();
      await Future<void>.value();

      final second = container.read(provider(0));

      expect(first.mounted, false);
      expect(second, isNot(first));
      expect(second.state, 0);
      expect(second.mounted, true);
    });
  });
}
