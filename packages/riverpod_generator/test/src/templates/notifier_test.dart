import 'package:test/test.dart';

import '../prefixed_output.dart';

void main() {
  test('writes notifiers with the prefix of their import', () {
    expectPrefixed([
      r'$AsyncNotifier',
      r'$StreamNotifier',
      r'$Notifier',
      r'$mustCallSuper',
      'WhenComplete',
      r'$Ref',
      r'$ClassProviderElement',
      'AnyNotifier',
      'MissingScopeException',
    ]);
  });
}
