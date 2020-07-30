import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod/src/internals.dart' show SelectorSubscription;
import 'package:test/test.dart';

import '../utils.dart';

void main() {
  final mayHaveChanged = MayHaveChangedMock<String>();
  final didChange = DidChangedMock<String>();
  ProviderContainer container;
  final provider = StateProvider((_) => 0);
  setUp(() {
    container = ProviderContainer();
  });
  tearDown(() {
    clearInteractions(mayHaveChanged);
    clearInteractions(didChange);
    container.dispose();
  });

  group('provider.select', () {
    test('simple flow', () {
      final sub = container.listen(
        provider.select((value) {
          return value.state.sign.toString();
        }),
        mayHaveChanged: mayHaveChanged,
        didChange: didChange,
      );

      expect(sub, isA<SelectorSubscription<StateController<int>, String>>());

      expect(sub.read(), '0');

      verifyZeroInteractions(mayHaveChanged);
      verifyZeroInteractions(didChange);

      container.read(provider).state = 10;

      verifyOnly(mayHaveChanged, mayHaveChanged(sub));
      verifyZeroInteractions(didChange);

      expect(sub.flush(), true);
      expect(sub.read(), '1');
      verifyOnly(didChange, didChange(sub));
      verifyNoMoreInteractions(mayHaveChanged);

      container.read(provider).state = 42;

      verifyOnly(mayHaveChanged, mayHaveChanged(sub));
      verifyNoMoreInteractions(didChange);

      expect(sub.flush(), false);
      expect(sub.read(), '1');

      verifyNoMoreInteractions(mayHaveChanged);
      verifyNoMoreInteractions(didChange);

      container.read(provider).state = -10;

      verifyOnly(mayHaveChanged, mayHaveChanged(sub));
      verifyNoMoreInteractions(didChange);

      expect(sub.flush(), true);
      expect(sub.read(), '-1');

      verifyOnly(didChange, didChange(sub));
      verifyNoMoreInteractions(mayHaveChanged);
    });
    test('can change the selector without creating a new subscription', () {
      final provider = Provider((_) => 42);

      final sub = container.listen(
        provider.select((value) => value.sign.toString()),
        mayHaveChanged: mayHaveChanged,
        didChange: didChange,
      ) as SelectorSubscription<int, String>;

      expect(sub.read(), '1');
      verifyZeroInteractions(mayHaveChanged);
      verifyZeroInteractions(didChange);

      sub.updateSelector(provider.select((value) => '$value'));

      expect(sub.read(), '42');
      verifyZeroInteractions(mayHaveChanged);
      verifyZeroInteractions(didChange);
    });
    test('closing the subscription closes the internal subscription too', () {
      final element = container.readProviderElement(provider);

      expect(element.hasListeners, false);

      final sub = container.listen(provider.select((value) => value));

      expect(element.hasListeners, true);

      sub.close();

      expect(element.hasListeners, false);
    });
  });
}
