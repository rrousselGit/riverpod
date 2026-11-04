import 'package:test/test.dart';

import '../prefixed_output.dart';

void main() {
  test('writes providers with the prefix of their import', () {
    expectPrefixed([
      r'$FunctionalProvider',
      r'$FutureModifier',
      r'$FutureProvider',
      r'$StreamProvider',
      r'$Provider',
      r'$AsyncNotifierProvider',
      r'$StreamNotifierProvider',
      r'$NotifierProvider',
      r'$FutureProviderElement',
      r'$StreamProviderElement',
      r'$ProviderElement',
      r'$ProviderPointer',
      r'$internal',
      'Override',
      'Ref',
      r'$ProviderOverride',
      r'$SyncValueProvider',
    ]);
  });
}
