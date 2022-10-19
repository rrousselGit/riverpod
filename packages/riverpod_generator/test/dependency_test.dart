import 'package:test/test.dart';

import 'integration/dependencies.dart';
import 'utils.dart';

void main() {
  test(
      'Creates a FutureProvider<T> if @provider is used on a synchronous function',
      () {
    final container = createContainer();

    expect(() => container.read(publicProvider), returnsNormally);
    expect(() => container.read(privateProvider), returnsNormally);
    expect(() => container.read(privateClassProvider), returnsNormally);
    expect(() => container.read(publicClassProvider), returnsNormally);
    expect(() => container.read(familyClassProvider('')), returnsNormally);
    expect(
      () => container.read(familyClassStringProvider('')),
      returnsNormally,
    );
  });
}
