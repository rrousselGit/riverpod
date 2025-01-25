import 'package:riverpod/persist.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:test/test.dart';

import 'integration/offline.dart';

void main() {
  test('Custom annotation', () {
    final persist = Persist<String, String>.inMemory();
    persist.write('CustomAnnotation', '21', const PersistOptions());
    final container = ProviderContainer.test(persist: persist);

    expect(container.read(customAnnotationProvider), '21');
  });
}
