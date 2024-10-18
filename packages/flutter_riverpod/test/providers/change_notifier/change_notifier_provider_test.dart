// ignore_for_file: invalid_use_of_internal_member, avoid_types_on_closure_parameters, deprecated_member_use_from_same_package, deprecated_member_use

import 'package:flutter/widgets.dart' hide Listener;
import 'package:flutter_riverpod/src/internals.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../utils.dart';

void main() {
  test('supports overrideWith', () {
    final provider =
        ChangeNotifierProvider<ValueNotifier<int>>((ref) => ValueNotifier(0));
    final autoDispose = ChangeNotifierProvider.autoDispose<ValueNotifier<int>>(
      (ref) => ValueNotifier(0),
    );

    final container = createContainer(
      overrides: [
        provider.overrideWith(
          (ChangeNotifierProviderRef<ValueNotifier<int>> ref) =>
              ValueNotifier(42),
        ),
        autoDispose.overrideWith(
          (AutoDisposeChangeNotifierProviderRef<ValueNotifier<int>> ref) =>
              ValueNotifier(84),
        ),
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
    final container = createContainer(
      overrides: [
        family.overrideWith(
          (ChangeNotifierProviderRef<ValueNotifier<String>> ref, int arg) =>
              ValueNotifier('42 $arg'),
        ),
        autoDisposeFamily.overrideWith(
          (
            AutoDisposeChangeNotifierProviderRef<ValueNotifier<String>> ref,
            int arg,
          ) =>
              ValueNotifier('84 $arg'),
        ),
      ],
    );

    expect(container.read(family(10)).value, '42 10');
    expect(container.read(autoDisposeFamily(10)).value, '84 10');
  });

  test('ref.listenSelf listens to state changes', () {
    final listener = Listener<ValueNotifier<int>>();
    final container = createContainer();
    final provider = ChangeNotifierProvider<ValueNotifier<int>>((ref) {
      ref.listenSelf(listener.call);
      return ValueNotifier(0);
    });

    final notifier = container.read(provider);

    verifyOnly(listener, listener(null, notifier));

    container.read(provider.notifier).value++;

    verifyOnly(listener, listener(notifier, notifier));
  });

  test('support null ChangeNotifier', () {
    final container = createContainer();
    final provider = ChangeNotifierProvider<ValueNotifier<int>?>((ref) => null);

    expect(container.read(provider), null);
    expect(container.read(provider.notifier), null);

    container.dispose();
  });

  test('can read and set current ChangeNotifier', () async {
    final container = createContainer();
    final listener = Listener<ValueNotifier<int>>();
    late ChangeNotifierProviderRef<ValueNotifier<int>> ref;
    final provider = ChangeNotifierProvider<ValueNotifier<int>>((r) {
      ref = r;
      return ValueNotifier(0);
    });

    container.listen(provider, listener.call);

    verifyZeroInteractions(listener);
    expect(ref.notifier.value, 0);
  });

  test('can refresh .notifier', () async {
    var initialValue = 1;
    final provider = ChangeNotifierProvider<ValueNotifier<int>>(
      (ref) => ValueNotifier<int>(initialValue),
    );
    final container = createContainer();

    expect(container.read(provider).value, 1);
    expect(container.read(provider.notifier).value, 1);

    initialValue = 42;

    expect(container.refresh(provider.notifier).value, 42);
    expect(container.read(provider).value, 42);
  });

  test('can be refreshed', () async {
    var result = ValueNotifier(0);
    final container = createContainer();
    final provider = ChangeNotifierProvider((ref) => result);

    expect(container.read(provider), result);
    expect(container.read(provider.notifier), result);

    result = ValueNotifier(42);
    expect(container.refresh(provider), result);

    expect(container.read(provider), result);
    expect(container.read(provider.notifier), result);
  });

  test('pass the notifier as previous value when notifying listeners', () {
    final container = createContainer();
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
      final provider = ChangeNotifierProvider((ref) => ValueNotifier(0));
      final root = createContainer();
      final container = createContainer(parent: root, overrides: [provider]);

      expect(container.read(provider.notifier).value, 0);
      expect(container.read(provider).value, 0);
      expect(
        container.getAllProviderElements(),
        unorderedEquals(<Object>[
          isA<ProviderElementBase<Object?>>()
              .having((e) => e.origin, 'origin', provider),
        ]),
      );
      expect(root.getAllProviderElements(), isEmpty);
    });

    // test('when using provider.overrideWithValue', () {
    //   final provider = ChangeNotifierProvider((ref) => ValueNotifier(0));
    //   final root = createContainer();
    //   final container = createContainer(parent: root, overrides: [
    //     provider.overrideWithValue(ValueNotifier(42)),
    //   ]);

    //   expect(container.read(provider.notifier).value, 42);
    //   expect(container.read(provider).value, 42);
    //   expect(
    //     container.getAllProviderElements(),
    //     unorderedEquals(<Object>[
    //       isA<ProviderElementBase<Object?>>()
    //           .having((e) => e.origin, 'origin', provider),
    //       isA<ProviderElementBase<Object?>>()
    //           .having((e) => e.origin, 'origin', provider.notifier)
    //     ]),
    //   );
    //   expect(root.getAllProviderElements(), isEmpty);
    // });

    test('when using provider.overrideWithProvider', () {
      final provider = ChangeNotifierProvider((ref) => ValueNotifier(0));
      final root = createContainer();
      final container = createContainer(
        parent: root,
        overrides: [
          provider.overrideWithProvider(
            ChangeNotifierProvider((ref) => ValueNotifier(42)),
          ),
        ],
      );

      expect(container.read(provider.notifier).value, 42);
      expect(container.read(provider).value, 42);
      expect(
        container.getAllProviderElements(),
        unorderedEquals(<Object>[
          isA<ProviderElementBase<Object?>>()
              .having((e) => e.origin, 'origin', provider),
        ]),
      );
      expect(root.getAllProviderElements(), isEmpty);
    });
  });

  // test('overriding with value listens to the ChangeNotifier', () {
  //   final provider = ChangeNotifierProvider((ref) => ValueNotifier(0));
  //   final notifier = ValueNotifier(42);
  //   final listener = Listener<int>();

  //   final container = createContainer(
  //     overrides: [provider.overrideWithValue(notifier)],
  //   );

  //   container.listen<ValueNotifier<int>>(
  //     provider,
  //     (prev, value) => listener(prev?.value, value.value),
  //   );

  //   expect(container.read(provider).value, 42);
  //   expect(container.read(provider.notifier).value, 42);

  //   notifier.value = 21;

  //   verifyOnly(listener, listener(21, 21));
  // });

  test('refresh recreates the ChangeNotifier', () {
    final provider = ChangeNotifierProvider((ref) => ValueNotifier(0));
    final container = createContainer();

    container.read(provider).value = 42;

    container.refresh(provider);

    expect(container.read(provider).value, 0);
    expect(container.read(provider.notifier).value, 0);
  });

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
    final container = createContainer();
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

  // test(
  //     'overrideWithValue listens to the notifier, support notifier change, and does not dispose of the notifier',
  //     () async {
  //   final provider = ChangeNotifierProvider((_) {
  //     return TestNotifier('a');
  //   });
  //   final notifier = TestNotifier('b');
  //   final notifier2 = TestNotifier('c');
  //   final container = createContainer(overrides: [
  //     provider.overrideWithValue(notifier),
  //   ]);
  //   addTearDown(container.dispose);

  //   var callCount = 0;
  //   final sub = container.listen(provider, (_, __) => callCount++);
  //   final notifierSub = container.listen(provider.notifier, (_, __) {});

  //   expect(sub.read(), notifier);
  //   expect(callCount, 0);
  //   expect(notifierSub.read(), notifier);
  //   expect(notifier.hasListeners, true);

  //   notifier.count++;

  //   await container.pump();
  //   expect(callCount, 1);

  //   container.updateOverrides([
  //     provider.overrideWithValue(notifier2),
  //   ]);

  //   await container.pump();
  //   expect(callCount, 2);
  //   expect(notifier.hasListeners, false);
  //   expect(notifier2.hasListeners, true);
  //   expect(notifier.mounted, true);
  //   expect(notifierSub.read(), notifier2);

  //   notifier2.count++;

  //   await container.pump();
  //   expect(callCount, 3);

  //   container.dispose();

  //   expect(callCount, 3);
  //   expect(notifier2.hasListeners, false);
  //   expect(notifier2.mounted, true);
  //   expect(notifier.mounted, true);
  // });

  test('ChangeNotifier can be auto-scoped', () async {
    final dep = Provider((ref) => 0);
    final provider = ChangeNotifierProvider(
      (ref) => ValueNotifier(ref.watch(dep)),
      dependencies: [dep],
    );
    final root = createContainer();
    final container = createContainer(
      parent: root,
      overrides: [dep.overrideWithValue(42)],
    );

    expect(container.read(provider).value, 42);
    expect(container.read(provider.notifier).value, 42);

    expect(root.getAllProviderElements(), isEmpty);
  });

  test('overrideWithProvider preserves the state across update', () async {
    final provider = ChangeNotifierProvider((_) {
      return TestNotifier();
    });
    final notifier = TestNotifier();
    final notifier2 = TestNotifier();
    final container = createContainer(
      overrides: [
        provider.overrideWithProvider(ChangeNotifierProvider((_) => notifier)),
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
