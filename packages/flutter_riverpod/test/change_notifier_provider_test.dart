import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('family', () {
    final container = ProviderContainer();
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
    final container = ProviderContainer(overrides: [
      provider.overrideWithProvider((ref, value) => ValueNotifier(value * 2))
    ]);

    expect(
      container.read(provider(0)),
      isA<ValueNotifier<int>>().having((source) => source.value, 'value', 0),
    );
    expect(
      container.read(provider(42)),
      isA<ValueNotifier<int>>().having((source) => source.value, 'value', 84),
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
        child: Consumer((c, watch) {
          return Text(
            watch(provider).count.toString(),
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
