// ignore_for_file: invalid_use_of_internal_member

import 'package:test/test.dart';

import 'integration/hash/hash1.dart';

void main() {
  test('Generates hash function for providers', () {
    expect(
      simpleProvider.debugGetCreateSourceHash!(),
      simpleProvider.debugGetCreateSourceHash!(),
    );
    expect(
      simple2Provider.debugGetCreateSourceHash!(),
      simple2Provider.debugGetCreateSourceHash!(),
    );
    expect(
      simpleClassProvider.debugGetCreateSourceHash!(),
      simpleClassProvider.debugGetCreateSourceHash!(),
    );

    expect(
      simpleProvider.debugGetCreateSourceHash!(),
      isNot(simple2Provider.debugGetCreateSourceHash!()),
    );
    expect(
      simpleProvider.debugGetCreateSourceHash!(),
      isNot(simpleClassProvider.debugGetCreateSourceHash!()),
    );
    expect(
      simpleProvider.debugGetCreateSourceHash!(),
      isNot(simple2Provider.debugGetCreateSourceHash!()),
    );
  });
}
