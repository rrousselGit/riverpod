import 'package:riverpod/experimental/persist.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:test/test.dart';

import 'integration/offline.dart';

void main() {
  test('Custom annotation', () async {
    final container = ProviderContainer.test();
    final persist = await container
        .listen(
          storageProvider.future,
          (a, b) {},
        )
        .read();
    persist.write('CustomAnnotation', '21', const StorageOptions());

    expect(
      await container
          .listen(customAnnotationProvider.future, (prev, next) {})
          .read(),
      '21',
    );
  });

  test('CustomJson', () async {
    final container = ProviderContainer.test();
    final persist = await container
        .listen(
          storageProvider.future,
          (a, b) {},
        )
        .read();
    persist.write(
      'CustomJson',
      '{"foo": {"value": 42}}',
      const StorageOptions(),
    );

    final result = await container
        .listen(customJsonProvider.future, (prev, next) {})
        .read();

    expect(result, hasLength(1));
    expect(result.keys, ['foo']);
    expect(result.values, [isA<Bar>().having((e) => e.value, 'value', 42)]);
  });
}
