// ignore_for_file: deprecated_member_use_from_same_package
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'utils.dart';

void main() {
  testWidgets('can downcast the value', (tester) async {}, skip: true);

  group('ProviderListener', () {
    testWidgets('works with providers that returns null', (tester) async {
      final nullProvider = Provider((ref) => null);

      // should compile
      ProviderListener<void>(
        provider: nullProvider,
        onChange: (context, value) {},
        child: Container(),
      );
    });

    testWidgets('receives the buildContext as parameter on change',
        (tester) async {
      final provider = StateProvider((ref) => 0);
      final key = GlobalKey();
      BuildContext? context;
      final container = createContainer();

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: ProviderListener<StateController<int>>(
            key: key,
            provider: provider,
            onChange: (c, _) => context = c,
            child: Container(),
          ),
        ),
      );

      container.read(provider).state++;

      expect(context, key.currentContext);
    });

    testWidgets('renders child', (tester) async {
      final provider = StateProvider((ref) => 0);

      await tester.pumpWidget(
        ProviderScope(
          child: ProviderListener<StateController<int>>(
            provider: provider,
            onChange: (_, value) {},
            child: const Text('hello', textDirection: TextDirection.ltr),
          ),
        ),
      );

      expect(find.text('hello'), findsOneWidget);
    });

    testWidgets('calls onChange at the end of frame after a mayHaveChanged',
        (tester) async {
      final container = createContainer();
      final provider = StateProvider((ref) => 0);
      final onChange = ListenerMock<int>();

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: ProviderListener<StateController<int>>(
            provider: provider,
            onChange: (_, value) => onChange(value.state),
            child: Container(),
          ),
        ),
      );

      verifyZeroInteractions(onChange);

      container.read(provider).state++;

      verifyOnly(onChange, onChange(1));
    });

    testWidgets('can mark parents as dirty during onChange', (tester) async {
      final container = createContainer();
      final provider = StateProvider((ref) => 0);
      final onChange = ListenerMock<int>();

      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) {
            return UncontrolledProviderScope(
              container: container,
              child: ProviderListener<StateController<int>>(
                provider: provider,
                onChange: (_, value) => setState(() {}),
                child: Container(),
              ),
            );
          },
        ),
      );

      verifyZeroInteractions(onChange);

      // This would fail if the setState was not allowed
      container.read(provider).state++;
    });

    testWidgets('calls onChange synchronously if possible', (tester) async {
      final provider = StateProvider((ref) => 0);
      final onChange = ListenerMock<int>();
      final container = createContainer();

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: ProviderListener<StateController<int>>(
            provider: provider,
            onChange: (_, value) => onChange(value.state),
            child: Container(),
          ),
        ),
      );
      verifyZeroInteractions(onChange);

      container.read(provider).state++;
      container.read(provider).state++;
      container.read(provider).state++;

      verifyInOrder([
        onChange(1),
        onChange(2),
        onChange(3),
      ]);
      verifyNoMoreInteractions(onChange);
    });

    testWidgets('calls onChange asynchronously if the change is indirect',
        (tester) async {
      final provider = StateProvider((ref) => 0);
      final isEven = Provider((ref) => ref.watch(provider).state.isEven);
      final onChange = ListenerMock<bool>();
      final container = createContainer();

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: ProviderListener<bool>(
            provider: isEven,
            onChange: (_, value) => onChange(value),
            child: Container(),
          ),
        ),
      );
      verifyZeroInteractions(onChange);

      container.read(provider).state++;
      container.read(provider).state++;
      container.read(provider).state++;

      verifyZeroInteractions(onChange);

      await tester.pump();

      verifyOnly(onChange, onChange(false));
    });

    group('supports null', () {
      testWidgets('in didChangeDependencies', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            child: ProviderListener<StateController<int>>(
              provider: null,
              onChange: (_, value) {},
              child: Container(),
            ),
          ),
        );
      });

      testWidgets('in dispose', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            child: ProviderListener<StateController<int>>(
              provider: null,
              onChange: (_, value) {},
              child: Container(),
            ),
          ),
        );

        await tester.pumpWidget(Container());
      });
    });

    testWidgets('closes the subscription on dispose', (tester) async {
      final provider = StateProvider((ref) => 0);
      final onChange = ListenerMock<int>();
      final container = createContainer();

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: ProviderListener<StateController<int>>(
            provider: provider,
            onChange: (_, value) => onChange(value.state),
            child: Container(),
          ),
        ),
      );

      expect(container.readProviderElement(provider).hasListeners, true);

      await tester.pumpWidget(Container());

      expect(container.readProviderElement(provider).hasListeners, false);
    });

    testWidgets('closes the subscription on provider change', (tester) async {
      final provider = StateProvider.family<int, int>((ref, _) => 0);
      final container = createContainer();

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: ProviderListener<StateController<int>>(
            provider: provider(0),
            onChange: (_, value) {},
            child: Container(),
          ),
        ),
      );

      expect(container.readProviderElement(provider(0)).hasListeners, true);
      expect(container.readProviderElement(provider(1)).hasListeners, false);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: ProviderListener<StateController<int>>(
            provider: provider(1),
            onChange: (_, value) {},
            child: Container(),
          ),
        ),
      );

      expect(container.readProviderElement(provider(0)).hasListeners, false);
      expect(container.readProviderElement(provider(1)).hasListeners, true);
    });

    testWidgets('listen to the new provider on provider change',
        (tester) async {
      final provider = StateProvider.family<int, int>((ref, _) => 0);
      final container = createContainer();
      final onChange = ListenerMock<int>();

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: ProviderListener<StateController<int>>(
            provider: provider(0),
            onChange: (_, value) => onChange(value.state),
            child: Container(),
          ),
        ),
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: ProviderListener<StateController<int>>(
            provider: provider(1),
            onChange: (_, value) => onChange(value.state),
            child: Container(),
          ),
        ),
      );

      verifyZeroInteractions(onChange);

      container.read(provider(0)).state++;
      container.read(provider(1)).state = 42;

      await Future<void>.value();

      verifyOnly(onChange, onChange(42));
    });

    testWidgets('supports Changing the ProviderContainer', (tester) async {
      final provider = Provider((ref) => 0);
      final onChange = ListenerMock<int>();
      final container = createContainer(overrides: [
        provider.overrideWithValue(0),
      ]);
      final container2 = createContainer(overrides: [
        provider.overrideWithValue(0),
      ]);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: ProviderListener<int>(
            provider: provider,
            onChange: (_, value) => onChange(value),
            child: Container(),
          ),
        ),
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container2,
          child: ProviderListener<int>(
            provider: provider,
            onChange: (_, value) => onChange(value),
            child: Container(),
          ),
        ),
      );

      container.updateOverrides([
        provider.overrideWithValue(21),
      ]);
      container2.updateOverrides([
        provider.overrideWithValue(42),
      ]);

      await Future<void>.value();

      verifyOnly(onChange, onChange(42));
    });

    testWidgets('supports scoping Providers', (tester) async {
      final provider = Provider((ref) => 0);
      final onChange = ListenerMock<int>();
      final container = createContainer(overrides: [
        provider.overrideWithValue(42),
      ]);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: ProviderListener<int>(
            provider: provider,
            onChange: (_, value) => onChange(value),
            child: Container(),
          ),
        ),
      );

      container.updateOverrides([
        provider.overrideWithValue(21),
      ]);

      await Future<void>.value();

      verifyOnly(onChange, onChange(21));
    });
  });
}

class ListenerMock<T> extends Mock {
  void call(T value);
}
