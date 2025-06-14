import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

import '../matrix.dart' as utils;
import '../utils.dart' as utils;

void main() {
  test('Simple example', () {
    final container = ProviderContainer.test();
    final listener = utils.Listener<String>();
    final notifier = utils.DeferredNotifier<int>((self, ref) => 0);
    final provider = NotifierProvider<Notifier<int>, int>(() => notifier);

    final listenable = DelegatingTransformer<int, String>((context) {
      return ProviderTransformer(
        initialState: () => 'Hello ${context.sourceState.requireState}',
        listener: (self, prev, next) {},
      );
    });
  });
  test('If no state is initialized during creation, throw', () {});
  test('Setting state during init does not notify', () {});
  test('Calls transformer listener on state change', () {});
  test('Respect weak flag', () {});
  test('Supports both providers and other listenables as source', () {});
  test('ProviderSubscription.read reads current value, if any', () {});

  group('error handling', () {
    test('If transform throws, reports to onError', () {});
    test('If listener throws, reports to onError', () {});
    test('Setting state to ResultError notifies onError', () {});
    test('ProviderSubscription.read rethrows transformer error if any', () {});
    test('ProviderSubscription.read rethrows state error if any', () {});
  });
}

class DelegatingTransformer<InT, OutT>
    implements ProviderTransformerMixin<InT, OutT> {
  DelegatingTransformer(this.transformCb);

  final ProviderTransformer<InT, OutT> Function(
    ProviderTransformerContext<InT, OutT> context,
  ) transformCb;

  @override
  ProviderTransformer<InT, OutT> transform(
    ProviderTransformerContext<InT, OutT> context,
  ) {
    return transformCb(context);
  }
}
