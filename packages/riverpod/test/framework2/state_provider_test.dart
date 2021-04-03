import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

void main() {
  late ProviderContainer container;
  setUp(() {
    container = ProviderContainer();
  });
  tearDown(() {
    container.dispose();
  });

  group('StateProvider', () {
    test('.notifier obtains the controller without listening to it', () {
      final dep = StateProvider((ref) => 0);
      final provider = StateProvider((ref) {
        ref.watch(dep);
        return 0;
      });

      var callCount = 0;
      final sub = container.listen(
        provider.notifier,
        didChange: (_) => callCount++,
      );

      final controller = container.read(provider);

      expect(sub.read(), controller);
      expect(callCount, 0);

      controller.state++;

      sub.flush();
      expect(callCount, 0);

      container.read(dep).state++;

      final controller2 = container.read(provider);
      expect(controller2, isNot(controller));

      sub.flush();
      expect(sub.read(), controller2);
      expect(callCount, 1);
    });
  });

  group('StateProvider.autoDispose', () {
    test('.notifier obtains the controller without listening to it', () {
      final dep = StateProvider((ref) => 0);
      final provider = StateProvider.autoDispose((ref) {
        ref.watch(dep);
        return 0;
      });

      var callCount = 0;
      final sub = container.listen(
        provider.notifier,
        didChange: (_) => callCount++,
      );

      final controller = container.read(provider);

      expect(sub.read(), controller);
      expect(callCount, 0);

      controller.state++;

      sub.flush();
      expect(callCount, 0);

      container.read(dep).state++;

      final controller2 = container.read(provider);
      expect(controller2, isNot(controller));

      sub.flush();
      expect(sub.read(), controller2);
      expect(callCount, 1);
    });

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
      StateProvider.family.autoDispose<int, String>((ref, id) {
        return 42;
      });

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
