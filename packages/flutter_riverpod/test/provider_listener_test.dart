// ignore_for_file: deprecated_member_use_from_same_package
import 'package:flutter/material.dart' hide Listener;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'utils.dart';

void main() {
  group('ProviderListener', () {
    testWidgets('can downcast the value', (tester) async {
      final dep = StateProvider((ref) => 0);
      final provider = Provider((ref) => ref.watch(dep.state).state);

      final container = createContainer();
      final listener = Listener<num>();

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: ProviderListener<num>(
            provider: provider,
            onChange: (c, prev, value) => listener(prev, value),
            child: Container(),
          ),
        ),
      );

      verifyZeroInteractions(listener);

      container.read(dep.state).state++;
      await tester.pump();

      verifyOnly(listener, listener(0, 1));
    });

    testWidgets('works with providers that returns null', (tester) async {
      final nullProvider = Provider((ref) => null);

      // should compile
      ProviderListener<void>(
        provider: nullProvider,
        onChange: (context, prev, value) {},
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
            provider: provider.state,
            onChange: (c, _, __) => context = c,
            child: Container(),
          ),
        ),
      );

      container.read(provider.state).state++;

      expect(context, key.currentContext);
    });

    testWidgets('renders child', (tester) async {
      final provider = StateProvider((ref) => 0);

      await tester.pumpWidget(
        ProviderScope(
          child: ProviderListener<StateController<int>>(
            provider: provider.state,
            onChange: (_, prev, value) {},
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
      final onChange = Listener<int>();

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: ProviderListener<StateController<int>>(
            provider: provider.state,
            onChange: (_, prev, value) => onChange(prev?.state, value.state),
            child: Container(),
          ),
        ),
      );

      verifyZeroInteractions(onChange);

      container.read(provider.state).state++;

      verifyOnly(onChange, onChange(1, 1));
    });

    testWidgets('can mark parents as dirty during onChange', (tester) async {
      final container = createContainer();
      final provider = StateProvider((ref) => 0);
      final onChange = Listener<int>();

      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) {
            return UncontrolledProviderScope(
              container: container,
              child: ProviderListener<StateController<int>>(
                provider: provider.state,
                onChange: (_, prev, value) => setState(() {}),
                child: Container(),
              ),
            );
          },
        ),
      );

      verifyZeroInteractions(onChange);

      // This would fail if the setState was not allowed
      container.read(provider.state).state++;
    });

    testWidgets('calls onChange synchronously if possible', (tester) async {
      final provider = StateProvider((ref) => 0);
      final onChange = Listener<int>();
      final container = createContainer();

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: ProviderListener<StateController<int>>(
            provider: provider.state,
            onChange: (_, prev, value) => onChange(prev?.state, value.state),
            child: Container(),
          ),
        ),
      );
      verifyZeroInteractions(onChange);

      container.read(provider.state).state++;
      container.read(provider.state).state++;
      container.read(provider.state).state++;

      verifyInOrder([
        onChange(1, 1),
        onChange(2, 2),
        onChange(3, 3),
      ]);
      verifyNoMoreInteractions(onChange);
    });

    testWidgets('calls onChange asynchronously if the change is indirect',
        (tester) async {
      final provider = StateProvider((ref) => 0);
      final isEven = Provider((ref) => ref.watch(provider.state).state.isEven);
      final onChange = Listener<bool>();
      final container = createContainer();

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: ProviderListener<bool>(
            provider: isEven,
            onChange: (_, prev, value) => onChange(prev, value),
            child: Container(),
          ),
        ),
      );
      verifyZeroInteractions(onChange);

      container.read(provider.state).state++;
      container.read(provider.state).state++;
      container.read(provider.state).state++;

      verifyZeroInteractions(onChange);

      await tester.pump();

      verifyOnly(onChange, onChange(true, false));
    });

    group('supports null', () {
      testWidgets('in didChangeDependencies', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            child: ProviderListener<StateController<int>>(
              provider: null,
              onChange: (_, prev, value) {},
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
              onChange: (_, prev, value) {},
              child: Container(),
            ),
          ),
        );

        await tester.pumpWidget(Container());
      });
    });

    testWidgets('closes the subscription on dispose', (tester) async {
      final provider = StateProvider((ref) => 0);
      final onChange = Listener<int>();
      final container = createContainer();

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: ProviderListener<int>(
            provider: provider,
            onChange: (_, prev, value) => onChange(prev, value),
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
          child: ProviderListener<int>(
            provider: provider(0),
            onChange: (_, prev, value) {},
            child: Container(),
          ),
        ),
      );

      expect(container.readProviderElement(provider(0)).hasListeners, true);
      expect(container.readProviderElement(provider(1)).hasListeners, false);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: ProviderListener<int>(
            provider: provider(1),
            onChange: (_, prev, value) {},
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
      final onChange = Listener<int>();

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: ProviderListener<StateController<int>>(
            provider: provider(0).state,
            onChange: (_, prev, value) => onChange(prev?.state, value.state),
            child: Container(),
          ),
        ),
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: ProviderListener<StateController<int>>(
            provider: provider(1).state,
            onChange: (_, prev, value) => onChange(prev?.state, value.state),
            child: Container(),
          ),
        ),
      );

      verifyZeroInteractions(onChange);

      container.read(provider(0).state).state++;
      container.read(provider(1).state).state = 42;

      await Future<void>.value();

      verifyOnly(onChange, onChange(42, 42));
    });

    testWidgets('supports Changing the ProviderContainer', (tester) async {
      final provider = Provider((ref) => 0);
      final onChange = Listener<int>();
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
            onChange: (_, prev, value) => onChange(prev, value),
            child: Container(),
          ),
        ),
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container2,
          child: ProviderListener<int>(
            provider: provider,
            onChange: (_, prev, value) => onChange(prev, value),
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

      verifyOnly(onChange, onChange(0, 42));
    });

    testWidgets('supports scoping Providers', (tester) async {
      final provider = Provider((ref) => 0);
      final onChange = Listener<int>();
      final container = createContainer(overrides: [
        provider.overrideWithValue(42),
      ]);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: ProviderListener<int>(
            provider: provider,
            onChange: (_, prev, value) => onChange(prev, value),
            child: Container(),
          ),
        ),
      );

      container.updateOverrides([
        provider.overrideWithValue(21),
      ]);

      await Future<void>.value();

      verifyOnly(onChange, onChange(42, 21));
    });
  });
}
