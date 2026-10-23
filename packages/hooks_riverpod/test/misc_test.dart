import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/misc.dart';

void main() {
  test('exports the devtool flags', () {
    expect(debugTrackProviderCreation, isFalse);
    expect(debugTrackProviderHistory, isFalse);
  });

  test('exports the APIs to write custom provider listenables', () {
    expect(<Type>[
      CustomProviderListenable,
      ProviderTransformer2,
      SyncProviderTransformer2,
      WhenComplete,
    ], hasLength(4));
  });
}
