import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../utils.dart';

void main() {
  group('scoping an override overrides all the associated subproviders', () {
    test('when passing the provider itself', () {
      final provider = ChangeNotifierProvider((ref) => ValueNotifier(0));
      final root = createContainer();
      final container = createContainer(parent: root, overrides: [provider]);

      expect(container.read(provider.notifier).value, 0);
      expect(container.read(provider).value, 0);
      expect(
        container.getAllProviderElements(),
        unorderedEquals(<Object>[
          isA<ProviderElementBase>()
              .having((e) => e.origin, 'origin', provider),
          isA<ProviderElementBase>()
              .having((e) => e.origin, 'origin', provider.notifier)
        ]),
      );
      expect(root.getAllProviderElements(), isEmpty);
    });

    test('when using provider.overrideWithValue', () {
      final provider = ChangeNotifierProvider((ref) => ValueNotifier(0));
      final root = createContainer();
      final container = createContainer(parent: root, overrides: [
        provider.overrideWithValue(ValueNotifier(42)),
      ]);

      expect(container.read(provider.notifier).value, 42);
      expect(container.read(provider).value, 42);
      expect(
        container.getAllProviderElements(),
        unorderedEquals(<Object>[
          isA<ProviderElementBase>()
              .having((e) => e.origin, 'origin', provider),
          isA<ProviderElementBase>()
              .having((e) => e.origin, 'origin', provider.notifier)
        ]),
      );
      expect(root.getAllProviderElements(), isEmpty);
    });

    test('when using provider.overrideWithProvider', () {
      final provider = ChangeNotifierProvider((ref) => ValueNotifier(0));
      final root = createContainer();
      final container = createContainer(parent: root, overrides: [
        provider.overrideWithProvider(
          ChangeNotifierProvider((ref) => ValueNotifier(42)),
        ),
      ]);

      expect(container.read(provider.notifier).value, 42);
      expect(container.read(provider).value, 42);
      expect(
        container.getAllProviderElements(),
        unorderedEquals(<Object>[
          isA<ProviderElementBase>()
              .having((e) => e.origin, 'origin', provider),
          isA<ProviderElementBase>()
              .having((e) => e.origin, 'origin', provider.notifier)
        ]),
      );
      expect(root.getAllProviderElements(), isEmpty);
    });
  });

  test('overriding listens to the ChangeNotifier', () {}, skip: true);
  test('overriding family listens to the ChangeNotifier', () {}, skip: true);
  test('refresh recreates the ChangeNotifier', () {}, skip: true);

  test('family', () {
    final container = createContainer();
    final provider =
        ChangeNotifierProvider.family<ValueNotifier<int>, int>((ref, value) {
      return ValueNotifier(value);
    });

    expect(
      container.read(provider(0)),
      isA<ValueNotifier<int>>().having((source) => source.value, 'value', 0),
    );
    expect(
      container.read(provider(42)),
      isA<ValueNotifier<int>>().having((source) => source.value, 'value', 42),
    );
  });

  test('family override', () {
    final provider =
        ChangeNotifierProvider.family<ValueNotifier<int>, int>((ref, value) {
      return ValueNotifier(value);
    });
    final container = createContainer(overrides: [
      provider.overrideWithProvider(
        (value) => ChangeNotifierProvider((ref) => ValueNotifier(value * 2)),
      ),
    ]);

    expect(
      container.read(provider(0)),
      isA<ValueNotifier<int>>().having((source) => source.value, 'value', 0),
    );
    expect(
      container.read(provider(42)),
      isA<ValueNotifier<int>>().having((source) => source.value, 'value', 84),
    );
  }, skip: true);

  test('can specify name', () {
    final provider = ChangeNotifierProvider(
      (_) => ValueNotifier(0),
      name: 'example',
    );

    expect(provider.name, 'example');

    final provider2 = ChangeNotifierProvider((_) => ValueNotifier(0));

    expect(provider2.name, isNull);
  });

  testWidgets('listen to the notifier', (tester) async {
    final notifier = TestNotifier();
    final provider = ChangeNotifierProvider((_) => notifier);

    await tester.pumpWidget(
      ProviderScope(
        child: Consumer(builder: (c, ref, _) {
          return Text(
            ref.watch(provider).count.toString(),
            textDirection: TextDirection.ltr,
          );
        }),
      ),
    );

    expect(find.text('0'), findsOneWidget);

    notifier.count++;
    await tester.pump();

    expect(find.text('1'), findsOneWidget);

    await tester.pumpWidget(Container());

    expect(notifier.mounted, isFalse);
  });

  test('.notifier obtains the controller without listening to it', () async {
    final dep = StateProvider((ref) => 0);
    final notifier = TestNotifier();
    final notifier2 = TestNotifier();
    final provider = ChangeNotifierProvider((ref) {
      return ref.watch(dep).state == 0 ? notifier : notifier2;
    });
    final container = createContainer();
    addTearDown(container.dispose);

    var callCount = 0;
    final sub = container.listen(
      provider.notifier,
      (_) => callCount++,
    );

    expect(sub.read(), notifier);
    expect(callCount, 0);

    notifier.count++;

    await container.pump();
    expect(callCount, 0);

    container.read(dep).state++;

    expect(sub.read(), notifier2);

    await container.pump();
    expect(sub.read(), notifier2);
    expect(callCount, 1);
  });

  test(
      'overrideWithValue listens to the notifier, support notifier change, and does not dispose of the notifier',
      () async {
    final provider = ChangeNotifierProvider((_) {
      return TestNotifier('a');
    });
    final notifier = TestNotifier('b');
    final notifier2 = TestNotifier('c');
    final container = createContainer(overrides: [
      provider.overrideWithValue(notifier),
    ]);
    addTearDown(container.dispose);

    var callCount = 0;
    final sub = container.listen(provider, (_) => callCount++);
    final notifierSub = container.listen(provider.notifier, (_) {});

    expect(sub.read(), notifier);
    expect(callCount, 0);
    expect(notifierSub.read(), notifier);
    expect(notifier.hasListeners, true);

    notifier.count++;

    await container.pump();
    expect(callCount, 1);

    container.updateOverrides([
      provider.overrideWithValue(notifier2),
    ]);

    await container.pump();
    expect(callCount, 2);
    expect(notifier.hasListeners, false);
    expect(notifier2.hasListeners, true);
    expect(notifier.mounted, true);
    expect(notifierSub.read(), notifier2);

    notifier2.count++;

    await container.pump();
    expect(callCount, 3);

    container.dispose();

    expect(callCount, 3);
    expect(notifier2.hasListeners, false);
    expect(notifier2.mounted, true);
    expect(notifier.mounted, true);
  });

  test('overrideWithProvider preserves the state accross update', () async {
    final provider = ChangeNotifierProvider((_) {
      return TestNotifier();
    });
    final notifier = TestNotifier();
    final notifier2 = TestNotifier();
    final container = createContainer(overrides: [
      provider.overrideWithProvider(ChangeNotifierProvider((_) => notifier)),
    ]);
    addTearDown(container.dispose);

    var callCount = 0;
    final sub = container.listen(provider, (_) => callCount++);

    expect(sub.read(), notifier);
    expect(container.read(provider.notifier), notifier);
    expect(notifier.hasListeners, true);
    expect(callCount, 0);

    notifier.count++;

    await container.pump();
    expect(callCount, 1);

    container.updateOverrides([
      provider.overrideWithProvider(ChangeNotifierProvider((_) => notifier2)),
    ]);

    await container.pump();
    expect(callCount, 1);
    expect(container.read(provider.notifier), notifier);
    expect(notifier2.hasListeners, false);

    notifier.count++;

    await container.pump();
    expect(callCount, 2);
    expect(container.read(provider.notifier), notifier);
    expect(notifier.mounted, true);

    container.dispose();

    expect(callCount, 2);
    expect(notifier.mounted, false);
  });
}

class TestNotifier extends ChangeNotifier {
  TestNotifier([this.debugLabel]);

  final String? debugLabel;

  bool mounted = true;

  @override
  // ignore: unnecessary_overrides
  bool get hasListeners => super.hasListeners;

  int _count = 0;
  int get count => _count;
  set count(int count) {
    _count = count;
    notifyListeners();
  }

  @override
  void dispose() {
    mounted = false;
    super.dispose();
  }

  @override
  String toString() {
    return 'TestNotifier($debugLabel)';
  }
}
