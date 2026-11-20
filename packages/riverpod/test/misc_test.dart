import 'package:riverpod/misc.dart';
import 'package:test/test.dart';

void main() {
  test('exports the devtool flags', () {
    expect(debugTrackProviderCreation, isFalse);
    expect(debugTrackProviderHistory, isFalse);
  });
}
