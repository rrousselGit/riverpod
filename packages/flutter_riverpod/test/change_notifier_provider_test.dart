import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('ChangeNotifierProviderDependency can be assigned to ProviderDependency',
      () async {
    final provider = ChangeNotifierProvider((ref) {
      return ValueNotifier(0);
    });
    final owner = ProviderStateOwner();

    // ignore: omit_local_variable_types
    final ProviderDependency<ValueNotifier<int>> dep =
        owner.ref.dependOn(provider);

    await expectLater(dep.value.value, 0);
  });
  test('family', () {
    final owner = ProviderStateOwner();
    final provider =
        ChangeNotifierProviderFamily<ValueNotifier<int>, int>((ref, value) {
      return ValueNotifier(value);
    });

    expect(
      provider(0).readOwner(owner),
      isA<ValueNotifier<int>>().having((source) => source.value, 'value', 0),
    );
    expect(
      provider(42).readOwner(owner),
      isA<ValueNotifier<int>>().having((source) => source.value, 'value', 42),
    );
  });
  test('family override', () {
    final provider =
        ChangeNotifierProviderFamily<ValueNotifier<int>, int>((ref, value) {
      return ValueNotifier(value);
    });
    final owner = ProviderStateOwner(overrides: [
      provider.overrideAs((ref, value) => ValueNotifier(value * 2))
    ]);

    expect(
      provider(0).readOwner(owner),
      isA<ValueNotifier<int>>().having((source) => source.value, 'value', 0),
    );
    expect(
      provider(42).readOwner(owner),
      isA<ValueNotifier<int>>().having((source) => source.value, 'value', 84),
    );
  });
  test('can be assigned to provider', () {
    final Provider<ValueNotifier<int>> provider = ChangeNotifierProvider((_) {
      return ValueNotifier(0);
    });
    final owner = ProviderStateOwner();

    expect(provider.readOwner(owner), isA<ValueNotifier<int>>());
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
        child: Consumer((c, read) {
          return Text(
            read(provider).count.toString(),
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
}

class TestNotifier extends ChangeNotifier {
  bool mounted = true;

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
}
