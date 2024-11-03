// ignore_for_file: invalid_use_of_internal_member, avoid_types_on_closure_parameters, deprecated_member_use_from_same_package, deprecated_member_use

import 'dart:async';

import 'package:flutter/widgets.dart' hide Listener;
import 'package:flutter_riverpod/src/internals.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../utils.dart';

void main() {
  test('Guards ChangeNotifier.dispose', () {
    final notifier = DelegateNotifier(
      onDispose: () => throw StateError('called'),
    );
    final container = ProviderContainer.test();
    final provider = ChangeNotifierProvider((_) => notifier);

    container.read(provider);

    final errors = <Object>[];

    runZonedGuarded(
      () => container.invalidate(provider),
      (error, stack) => errors.add(error),
    );

    expect(errors, [isStateError]);
  });

  test('supports overrideWith', () {
    final provider =
        ChangeNotifierProvider<ValueNotifier<int>>((ref) => ValueNotifier(0));
    final autoDispose = ChangeNotifierProvider.autoDispose<ValueNotifier<int>>(
      (ref) => ValueNotifier(0),
    );

    final container = ProviderContainer.test(
      overrides: [
        provider.overrideWith((ref) => ValueNotifier(42)),
        autoDispose.overrideWith((ref) => ValueNotifier(84)),
      ],
    );

    expect(container.read(provider).value, 42);
    expect(container.read(autoDispose).value, 84);
  });

  test('supports family overrideWith', () {
    final family = ChangeNotifierProvider.family<ValueNotifier<String>, int>(
      (ref, arg) => ValueNotifier('0 $arg'),
    );
    final autoDisposeFamily =
        ChangeNotifierProvider.autoDispose.family<ValueNotifier<String>, int>(
      (ref, arg) => ValueNotifier('0 $arg'),
    );
    final container = ProviderContainer.test(
      overrides: [
        family.overrideWith((ref, int arg) => ValueNotifier('42 $arg')),
        autoDisposeFamily
            .overrideWith((ref, int arg) => ValueNotifier('84 $arg')),
      ],
    );

    expect(container.read(family(10)).value, '42 10');
    expect(container.read(autoDisposeFamily(10)).value, '84 10');
  });

  test('support null ChangeNotifier', () {
    final container = ProviderContainer.test();
    final provider = ChangeNotifierProvider<ValueNotifier<int>?>((ref) => null);

    expect(container.read(provider), null);
    expect(container.read(provider.notifier), null);

    container.dispose();
  });

  test('can refresh .notifier', () async {
    var initialValue = 1;
    final provider = ChangeNotifierProvider<ValueNotifier<int>>(
      (ref) => ValueNotifier<int>(initialValue),
    );
    final container = ProviderContainer.test();

    expect(container.read(provider).value, 1);
    expect(container.read(provider.notifier).value, 1);

    initialValue = 42;

    expect(container.refresh(provider.notifier).value, 42);
    expect(container.read(provider).value, 42);
  });

  test('can be refreshed', () async {
    var result = ValueNotifier(0);
    final container = ProviderContainer.test();
    final provider = ChangeNotifierProvider((ref) => result);

    expect(container.read(provider), result);
    expect(container.read(provider.notifier), result);

    result = ValueNotifier(42);
    expect(container.refresh(provider), result);

    expect(container.read(provider), result);
    expect(container.read(provider.notifier), result);
  });

  test('pass the notifier as previous value when notifying listeners', () {
    final container = ProviderContainer.test();
    final notifier = ValueNotifier(0);
    final provider = ChangeNotifierProvider((ref) => notifier);
    final listener = Listener<ValueNotifier<int>>();

    container.listen(provider, listener.call, fireImmediately: true);

    verifyOnly(listener, listener(null, notifier));

    notifier.value++;

    verifyOnly(listener, listener(notifier, notifier));
  });

  group('scoping an override overrides all the associated subproviders', () {
    test('when passing the provider itself', () {
      final provider = ChangeNotifierProvider(
        (ref) => ValueNotifier(0),
        dependencies: const [],
      );
      final root = ProviderContainer.test();
      final container =
          ProviderContainer.test(parent: root, overrides: [provider]);

      expect(container.read(provider.notifier).value, 0);
      expect(container.read(provider).value, 0);
      expect(
        container.getAllProviderElements(),
        unorderedEquals(<Object>[
          isA<ProviderElement>().having((e) => e.origin, 'origin', provider),
        ]),
      );
      expect(root.getAllProviderElements(), isEmpty);
    });

    test('when using provider.overrideWith', () {
      final provider = ChangeNotifierProvider(
        (ref) => ValueNotifier(0),
        dependencies: const [],
      );
      final root = ProviderContainer.test();
      final container = ProviderContainer.test(
        parent: root,
        overrides: [
          provider.overrideWith((ref) => ValueNotifier(42)),
        ],
      );

      expect(container.read(provider.notifier).value, 42);
      expect(container.read(provider).value, 42);
      expect(
        container.getAllProviderElements(),
        unorderedEquals(<Object>[
          isA<ProviderElement>().having((e) => e.origin, 'origin', provider),
        ]),
      );
      expect(root.getAllProviderElements(), isEmpty);
    });
  });

  test('refresh recreates the ChangeNotifier', () {
    final provider = ChangeNotifierProvider((ref) => ValueNotifier(0));
    final container = ProviderContainer.test();

    container.read(provider).value = 42;

    container.refresh(provider);

    expect(container.read(provider).value, 0);
    expect(container.read(provider.notifier).value, 0);
  });

  test('family', () {
    final container = ProviderContainer.test();
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
        child: Consumer(
          builder: (c, ref, _) {
            return Text(
              ref.watch(provider).count.toString(),
              textDirection: TextDirection.ltr,
            );
          },
        ),
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
      return ref.watch(dep) == 0 ? notifier : notifier2;
    });
    final container = ProviderContainer.test();
    addTearDown(container.dispose);

    var callCount = 0;
    final sub = container.listen(
      provider.notifier,
      (_, __) => callCount++,
    );

    expect(sub.read(), notifier);
    expect(callCount, 0);

    notifier.count++;

    await container.pump();
    expect(callCount, 0);

    container.read(dep.notifier).state++;

    expect(sub.read(), notifier2);

    await container.pump();
    expect(sub.read(), notifier2);
    expect(callCount, 1);
  });

  test('ChangeNotifier can be auto-scoped', () async {
    final dep = Provider((ref) => 0, dependencies: const []);
    final provider = ChangeNotifierProvider(
      (ref) => ValueNotifier(ref.watch(dep)),
      dependencies: [dep],
    );
    final root = ProviderContainer.test();
    final container = ProviderContainer.test(
      parent: root,
      overrides: [dep.overrideWithValue(42)],
    );

    expect(container.read(provider).value, 42);
    expect(container.read(provider.notifier).value, 42);

    expect(root.getAllProviderElements(), isEmpty);
  });

  test('overrideWith preserves the state across update', () async {
    final provider = ChangeNotifierProvider((_) {
      return TestNotifier();
    });
    final notifier = TestNotifier();
    final notifier2 = TestNotifier();
    final container = ProviderContainer.test(
      overrides: [
        provider.overrideWith((_) => notifier),
      ],
    );
    addTearDown(container.dispose);

    var callCount = 0;
    final sub = container.listen(provider, (prev, value) => callCount++);

    expect(sub.read(), notifier);
    expect(container.read(provider.notifier), notifier);
    expect(notifier.hasListeners, true);
    expect(callCount, 0);

    notifier.count++;

    await container.pump();
    expect(callCount, 1);

    container.updateOverrides([
      provider.overrideWith((_) => notifier2),
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

class DelegateNotifier extends ChangeNotifier {
  DelegateNotifier({this.onDispose});

  final void Function()? onDispose;

  @override
  void dispose() {
    onDispose?.call();
    super.dispose();
  }
}
