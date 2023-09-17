import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

import 'integration/annotated.dart';

void main() {
  test('Applied meta annotations to provider', () {
    //TODO (SunlightBro): check if annotations are correctly applied.
    expect(functionalProvider, isA<AutoDisposeProvider<String>>());
  });
}
