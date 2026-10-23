import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/legacy.dart' as legacy;
import 'package:hooks_riverpod/misc.dart';
import 'package:hooks_riverpod/misc.dart' as misc;

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

  test('still exports the ChangeNotifierProviderFamily of legacy.dart', () {
    expect(
      // ignore: deprecated_export_use, https://github.com/rrousselGit/riverpod/issues/4942
      misc.ChangeNotifierProviderFamily,
      legacy.ChangeNotifierProviderFamily,
    );
  });
}
