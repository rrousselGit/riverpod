import 'package:riverpod/persist.dart';
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
    persist.write('CustomAnnotation', '21', const PersistOptions());

    expect(
      await container
          .listen(customAnnotationProvider.future, (prev, next) {})
          .read(),
      '21',
    );
  });
}
