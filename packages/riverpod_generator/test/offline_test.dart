import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:test/test.dart';

import 'integration/offline.dart';

void main() {
  test('Custom annotation', () {
    final container = ProviderContainer.test();

    final customAnnotation = container.read(customAnnotationProvider);
    a a;
  });
}
