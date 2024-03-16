import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

import '../matrix.dart';
import '../utils.dart';

void main() {
  group('ClassFamily', () {
    notifierProviderFactory.createGroup((factory) {
      test('overrideWithBuild', () {
        final provider = factory.simpleTestProvider((ref) => 0);
        final overrideWithBuild =
            OverrideWithBuildMock<TestNotifier<int>, int, int>(-1);

        when(overrideWithBuild.call(any, any)).thenReturn(42);

        final container = ProviderContainer.test(
          overrides: [
            provider.overrideWithBuild(overrideWithBuild.call),
          ],
        );

        verifyZeroInteractions(overrideWithBuild);

        container.read(provider);

        final [ref as Ref<int>, notifier as TestNotifier<int>] = verify(
          overrideWithBuild.call(captureAny, captureAny),
        ).captured;

        // ignore: invalid_use_of_protected_member
        expect(ref, same(notifier.ref));

        expect(notifier.state, 42);
      });
    });
  });
}
