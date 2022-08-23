import 'package:test/test.dart';

import 'integration/hash/hash1.dart';

void main() {
  test('Generates hash function for providers', () {
    expect(
      SimpleProvider.debugGetCreateSourceHash!(),
      SimpleProvider.debugGetCreateSourceHash!(),
    );
    expect(
      Simple2Provider.debugGetCreateSourceHash!(),
      Simple2Provider.debugGetCreateSourceHash!(),
    );
    expect(
      SimpleClassProvider.debugGetCreateSourceHash!(),
      SimpleClassProvider.debugGetCreateSourceHash!(),
    );

    expect(
      SimpleProvider.debugGetCreateSourceHash!(),
      isNot(Simple2Provider.debugGetCreateSourceHash!()),
    );
    expect(
      SimpleProvider.debugGetCreateSourceHash!(),
      isNot(SimpleClassProvider.debugGetCreateSourceHash!()),
    );
    expect(
      SimpleProvider.debugGetCreateSourceHash!(),
      isNot(Simple2Provider.debugGetCreateSourceHash!()),
    );
  });
}
